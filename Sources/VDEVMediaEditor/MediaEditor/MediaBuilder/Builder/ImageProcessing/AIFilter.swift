//
//  AIFilter.swift
//  
//
//  Created by Vladislav Gushin on 10.08.2023.
//

import UIKit
import CollectionConcurrencyKit

public final class AIFilter {
    @Injected private var networkConfig: VDEVNetworkConfig
    private var service: Image2ImageService?
    private var neuralFilterDescriptor: FilterDescriptor?
    
    public init?(
        _ descriptor: FilterDescriptor,
        _ networkConfigType: VDEVNetworkModuleConfigType = .image2image
    ) {
        guard descriptor.isNeural else { return nil }
        self.service = .init(networkConfig[networkConfigType])
        self.neuralFilterDescriptor = descriptor
    }
    
    func execute(_ image: CIImage) -> CIImage? {
        return BlockingTask { [neuralFilterDescriptor] in
            await self.service?.execute(
                image: UIImage(ciImage: image),
                filterDescriptor: neuralFilterDescriptor
            ) ?? nil
        }
    }
}

private final class Image2ImageService {
    private let image2imageNetworkModule: VDEVNetworkModuleConfig
    private(set) public var client: ApiClient
    
    init?(_ image2imageNetworkModule: VDEVNetworkModuleConfig?) {
        guard let image2imageNetworkModule = image2imageNetworkModule else { return nil }
        self.image2imageNetworkModule = image2imageNetworkModule
        self.client = ApiClientImpl(host: image2imageNetworkModule.host)
    }
    
    func execute(
        image: UIImage,
        filterDescriptor: FilterDescriptor?
    ) async -> CIImage? {
        guard let filterDescriptor else { return nil }
        var resultImage: UIImage? = image
        await filterDescriptor.params?.asyncForEach { id, value in
            guard case .neural(let config) = value,
                  let filterID = filterDescriptor.id else {
                resultImage = resultImage
                return
            }
            resultImage = await picturePreparation(image: resultImage, config: config)
            if let operation = Image2ImageRequestOperation(
                image2imageNetworkConfig: image2imageNetworkModule,
                image: resultImage,
                editorFilterId: filterID,
                filterStepId: id
            ),
               let result = try? await client.execute(operation) {
                resultImage = .init(data: result)
            }
        }
        return resultImage?.rotatedCIImage
    }
}

private extension Image2ImageService {
    func picturePreparation(image: UIImage?, config: NeuralConfig) async -> UIImage? {
        guard let image = image else { return nil }
        func getNearest(
            value: CGFloat,
            multipleOf: CGFloat
        ) -> CGFloat {
            floor(value / multipleOf)
        }
        let maxPixels = CGFloat(config.maxPixels)
        let ratio = image.size.width / image.size.height
        let psWidth = floor(sqrt(maxPixels * ratio))
        let psHeight = floor(psWidth / ratio)
        let multipleOf = CGFloat(config.dimensionsMultipleOf)
        let targetWidth = max(1, getNearest(value: psWidth, multipleOf: multipleOf)) * multipleOf
        let targetHeight = max(1, getNearest(value: psHeight, multipleOf: multipleOf)) * multipleOf
        let resizedImage = image.resized(to: .init(width: targetWidth, height: targetHeight))
        return resizedImage
    }
}

private extension Image2ImageService {
    // MARK: - Request operation
    struct Image2ImageRequestOperation: ApiOperationWithMultipartRequest {
        private let image2imageNetworkConfig: VDEVNetworkModuleConfig
        typealias Response = Data
        var multipartRequest: MultipartRequest = .init()
        var encoder: JSONEncoder = .init()
        var timeOut: TimeInterval { image2imageNetworkConfig.timeOut }
        var method: HTTPMethod { .post }
        var path: String { image2imageNetworkConfig.path }
        var headers: [String: String]? { image2imageNetworkConfig.headers }
        var token: String?
        private let image: UIImage
        private let editorFilterId: String
        private let filterStepId: String
        
        init?(
            image2imageNetworkConfig: VDEVNetworkModuleConfig,
            image: UIImage?,
            editorFilterId: String,
            filterStepId: String
        ) {
            guard let image = image else { return nil }
            
            self.image2imageNetworkConfig = image2imageNetworkConfig
            self.token = image2imageNetworkConfig.token
            self.image = image
            self.editorFilterId = editorFilterId
            self.filterStepId = filterStepId
            
            let body = Body(
                editorFilterId: editorFilterId,
                editorFilterStepId: filterStepId
            )
            
            guard let imageData = image.jpegData(compressionQuality: 0.8),
                  let bodyPart = try? encoder.encode(body)else {
                return nil
            }
            
            self.multipartRequest.add(
                key: "body",
                value: String(decoding: bodyPart, as: UTF8.self)
            )
            
            self.multipartRequest.add(
                key: "image",
                fileName: "image2image.jpg",
                fileMimeType: "image/png",
                fileData: imageData
            )
        }
        
        struct Body: Encodable {
            let editorFilterId: String
            let editorFilterStepId: String
        }
    }
}
