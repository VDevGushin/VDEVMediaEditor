//
//  UIView+Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import UIKit
import SwiftUI

extension UIView.ContentMode {
    init(verticalAlignment: SwiftUI.Alignment, horizontalAlignment: NSTextAlignment) {
        switch (horizontalAlignment, verticalAlignment) {
        case (.left, .top): self = UIView.ContentMode.topLeft
        case (.left, .center): self = UIView.ContentMode.left
        case (.left, .bottom): self = UIView.ContentMode.bottomLeft
        case (.center, .top): self = UIView.ContentMode.top
        case (.center, .center): self = UIView.ContentMode.center
        case (.center, .bottom): self = UIView.ContentMode.bottom
        case (.right, .top): self = UIView.ContentMode.topRight
        case (.right, .center): self = UIView.ContentMode.right
        case (.right, .bottom): self = UIView.ContentMode.bottomRight
        default: self = .center
        }
    }
}

extension UIView {
    struct Side: OptionSet {
        let rawValue: Int

        static let top      = Side(rawValue: 1 << 0)
        static let bottom   = Side(rawValue: 1 << 1)
        static let leading  = Side(rawValue: 1 << 2)
        static let trailing = Side(rawValue: 1 << 3)

        static let all: Side = [.top, .bottom, .leading, .trailing]

        static func allExcept(_ exception: Side) -> Side { all.subtracting(exception) }
    }

    func edgesTo(_ other: UIView, insets: UIEdgeInsets = .zero, sides: Side = .all) {
        translatesAutoresizingMaskIntoConstraints = false

        if sides.contains(.top) {
            topAnchor.constraint(equalTo: other.topAnchor, constant: insets.top).isActive = true
        }
        if sides.contains(.bottom) {
            bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -insets.bottom).isActive = true
        }
        if sides.contains(.leading) {
            leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: insets.left).isActive = true
        }
        if sides.contains(.trailing) {
            trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: -insets.right).isActive = true
        }
    }

    func trailingToLeading(of view: UIView, offset: CGFloat = 0) {
        trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset).isActive = true
    }

    func width(to view: UIView, multiplier: CGFloat = 1, offset: CGFloat = 0) {
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: offset).isActive = true
    }

    @discardableResult
    func height(_ constant: CGFloat) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func edgesToSuperview(insets: UIEdgeInsets = .zero, sides: Side = .all) -> Bool {
        guard let superview = superview else { return false }
        edgesTo(superview, insets: insets, sides: sides)
        return true
    }
}

extension UIImage {
  /**
    Resizes the image.

    - Parameter scale: If this is 1, `newSize` is the size in pixels.
  */
  @nonobjc public func resized(to newSize: CGSize, scale: CGFloat = 1) -> UIImage {
    let format = UIGraphicsImageRendererFormat.default()
    format.scale = scale
    let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
    let image = renderer.image { _ in
      draw(in: CGRect(origin: .zero, size: newSize))
    }
    return image
  }

  /**
    Rotates the image around its center.

    - Parameter degrees: Rotation angle in degrees.
    - Parameter keepSize: If true, the new image has the size of the original
      image, so portions may be cropped off. If false, the new image expands
      to fit all the pixels.
  */
  @nonobjc public func rotated(by degrees: CGFloat, keepSize: Bool = true) -> UIImage {
    let radians = degrees * .pi / 180
    let newRect = CGRect(origin: .zero, size: size).applying(CGAffineTransform(rotationAngle: radians))

    // Trim off the extremely small float value to prevent Core Graphics from rounding it up.
    var newSize = keepSize ? size : newRect.size
    newSize.width = floor(newSize.width)
    newSize.height = floor(newSize.height)

    return UIGraphicsImageRenderer(size: newSize).image { rendererContext in
      let context = rendererContext.cgContext
        context.setFillColor(AppColors.black.uiColor.cgColor)
      context.fill(CGRect(origin: .zero, size: newSize))
      context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
      context.rotate(by: radians)
      let origin = CGPoint(x: -size.width / 2, y: -size.height / 2)
      draw(in: CGRect(origin: origin, size: size))
    }
  }
}

