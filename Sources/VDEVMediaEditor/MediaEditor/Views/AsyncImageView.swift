//
//  AsyncImageView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.02.2023.
//

import SwiftUI
import Combine
import Kingfisher

@MainActor
class AsyncImageLoader: ObservableObject {
    @Binding private var image: UIImage?
    private let url: URL

    init(url: URL, image: Binding<UIImage?>) {
        self.url = url
        self._image = image
    }

    func load() async {
        image = try? await ImageCache.default.retrieveImage(
            downloadAndStoreIfNeededFrom: url,
            forKey: url.absoluteString
        ).image
    }
}

struct AsyncImageView<ImageView: View, Placeholder: View>: View {
    @State private var image: UIImage?
    @State private var loader: AsyncImageLoader!

    private var url: URL

    @ViewBuilder var imageBlock: (UIImage) -> ImageView
    @ViewBuilder var placeholder: () -> Placeholder

    init(url: URL,
         @ViewBuilder imageBlock: @escaping (UIImage) -> ImageView,
         @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.imageBlock = imageBlock
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let image = image {
                imageBlock(image)
            } else {
                placeholder()
            }
        }
        .onAppear {
            loader = .init(url: url, image: $image)
            Task {
                await loader.load()
            }
        }
    }
}

