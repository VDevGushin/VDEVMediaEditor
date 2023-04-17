//
//  ToolGridPickCell.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import UIKit

class ToolGridPickCell: UICollectionViewCell {
    private(set) var imageView: UIImageView!
    private(set) var label: UILabel!
    private var activityIndicator: UIActivityIndicatorView!

    var inProgress = false {
        didSet {
            if inProgress {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func commonInit() {
        imageView = UIImageView()
        contentView.addSubview(imageView)
        imageView.edgesTo(contentView)

        label = UILabel()
        label.textColor = AppColors.white.uiColor
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        contentView.addSubview(label)
        label.edgesTo(contentView)

        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = AppColors.white.uiColor
        activityIndicator.hidesWhenStopped = true
        contentView.addSubview(activityIndicator)
        activityIndicator.edgesTo(contentView)

        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 3
        contentView.clipsToBounds = true
    }
}
