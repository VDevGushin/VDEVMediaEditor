//
//  ActivityPlaceholder.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import Kingfisher
import UIKit

final class ActivityPlaceholder: Placeholder {
    func add(to imageView: KFCrossPlatformImageView) {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }

    func remove(from imageView: KFCrossPlatformImageView) {
        (imageView.subviews.first { $0 is UIActivityIndicatorView } as? UIActivityIndicatorView)?.removeFromSuperview()
    }
}
