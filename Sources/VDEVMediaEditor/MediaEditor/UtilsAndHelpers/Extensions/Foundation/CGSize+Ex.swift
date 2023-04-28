//
//  CGSize+Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 12.02.2023.
//

import UIKit

extension CGSize {
    var rect: CGRect {
        .init(origin: .init(x: 0, y: 0), size: self)
    }

    func getScale(for child: CGSize) -> CGFloat {
        let scale: CGFloat

        if child.width >= child.height {
            scale = child.height / self.height
        } else {
            scale = child.width / self.width
        }

        return scale
    }

    static func aspectFit(aspectRatio: CGSize, boundingSize: CGSize) -> CGSize {
        var res = boundingSize
        let mW = boundingSize.width / aspectRatio.width;
        let mH = boundingSize.height / aspectRatio.height;

        if( mH < mW ) {
            res.width = boundingSize.height / aspectRatio.height * aspectRatio.width;
        }
        else if( mW < mH ) {
            res.height = boundingSize.width / aspectRatio.width * aspectRatio.height;
        }

        return res
    }

    static func aspectFill(aspectRatio: CGSize, minimumSize: CGSize) -> CGSize {
        var res = minimumSize
        let mW = minimumSize.width / aspectRatio.width;
        let mH = minimumSize.height / aspectRatio.height;

        if( mH > mW ) {
            res.width = minimumSize.height / aspectRatio.height * aspectRatio.width;
        }
        else if( mW > mH ) {
            res.height = minimumSize.width / aspectRatio.width * aspectRatio.height;
        }

        return res
    }

    func aspectFill(minimumSize: CGSize) -> CGSize {
        CGSize.aspectFill(aspectRatio: self, minimumSize: minimumSize)
    }

    func aspectFit(boundingSize: CGSize) -> CGSize {
        CGSize.aspectFit(aspectRatio: self, boundingSize: boundingSize)
    }

    func extended(insets: UIEdgeInsets) -> CGSize {
        return CGSize(width: insets.left + width + insets.right,
                      height: insets.top + height + insets.bottom)
    }

    func rounded() -> CGSize {
        CGSize(width: width.rounded(), height: height.rounded())
    }

    func rounded(_ rule: FloatingPointRoundingRule) -> CGSize {
        CGSize(width: width.rounded(rule), height: height.rounded(rule))
    }
    
    func add(value: CGSize = .init(width: 5, height: 5)) -> CGSize {
        self + value
    }
}


extension CGSize {
    static func + (lhs: Self, rhs: Self) -> Self {
        .init(width: lhs.width + rhs.width,
              height: lhs.height + rhs.height)
    }

    static func - (lhs: Self, rhs: Self) -> Self {
        .init(width: lhs.width - rhs.width,
              height: lhs.height - rhs.height)
    }

    static func / (lhs: Self, rhs: CGFloat) -> Self {
        .init(width: lhs.width / rhs,
              height: lhs.height / rhs)
    }


    static func * (lhs: Self, rhs: CGFloat) -> Self {
        .init(width: lhs.width * rhs,
              height: lhs.height * rhs)
    }
}

extension CGSize {
    static func centralOffset(withTemplateRect templateRect: CGRect, canvasSize: CGSize) -> Self {
        self.init(
            width: -(canvasSize.width / 2) + templateRect.origin.x + (templateRect.size.width / 2),
            height: -(canvasSize.height / 2) + templateRect.origin.y + (templateRect.size.height / 2)
        )
    }
}
