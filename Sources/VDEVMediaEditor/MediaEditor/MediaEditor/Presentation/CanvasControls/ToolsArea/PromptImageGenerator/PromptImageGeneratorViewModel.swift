//
//  PromptImageGeneratorViewModel.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import Foundation
import Combine
import UIKit

final class PromptImageGeneratorViewModel: ObservableObject {
    @Published private(set) var state: VMState = .notStarted
    @Published private(set) var progressImage: UIImage? = nil
    private var operation: AnyCancellable?
    private let generateImageFromTextService = GenerateImageFromTextService()
    private let onComplete: (UIImage) -> Void
    
    init(onComplete: @escaping (UIImage) -> Void) {
        self.onComplete = onComplete
        
        operation = generateImageFromTextService.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                switch value {
                case.loading:
                    self?.state = .loading
                    self?.progressImage = nil
                case .notStarted:
                    self?.state = .notStarted
                    self?.progressImage = nil
                case .success(image: let image):
                    self?.onComplete(image)
                    self?.progressImage = nil
                case .error(error: let error):
                    self?.state = .error(error: error)
                    self?.progressImage = nil
                case .inProgress(progress: let progress,
                                 progressImageUrl: let progressImageUrl):
                    self?.state = .inProgress(progress: progress)
                    self?.getProgressImage(from: progressImageUrl)
                }
            }
    }
    
    private func getProgressImage(from url: URL?) {
        Task {
            guard let url = url else { return }
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                return
            }
            await MainActor.run { [weak self] in
                self?.progressImage = image
            }
        }
    }
    
    func submit(message: String) {
        generateImageFromTextService.execute(message: message)
    }
    
    func cancelLoadCoreML() {
        generateImageFromTextService.cancel()
    }
}

extension PromptImageGeneratorViewModel {
    enum VMState {
        case loading
        case notStarted
        case error(error: Error? = nil)
        case inProgress(progress: Int)
    }
}

extension String: Error {}
