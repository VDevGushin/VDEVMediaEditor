//
//  InstagramStoriesActivity.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import UIKit
import AVKit
import Resolver

class InstagramStoriesActivity: UIActivity {
    @Injected private var images: VDEVImageConfig
    
    override class var activityCategory: UIActivity.Category { .share }

    override var activityType: UIActivity.ActivityType? { .init(rawValue: "com.instagram.shareStory") }
    override var activityTitle: String? { "Instagram Stories" }
    override var activityImage: UIImage? { images.common.iGStories }

    let urlScheme = URL(string: "instagram-stories://share?source_application=com.w1d1.ru")!

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        guard UIApplication.shared.canOpenURL(urlScheme) else { return false }
        return activityItems.contains { anyObj in
            guard let url = anyObj as? URL else { return false }
            if UIImage(contentsOfFile: url.path) != nil {
                return true
            } else if AVAsset(url: url).isPlayable {
                return true
            }
            return false
        }
    }

    override func prepare(withActivityItems activityItems: [Any]) {
        var images = [UIImage]()
        var videos = [AVURLAsset]()

        activityItems.forEach { anyObj in
            guard let url = anyObj as? URL else { return }
            if let img = UIImage(contentsOfFile: url.path) {
                images.append(img)
            } else if AVAsset(url: url).isPlayable {
                videos.append(AVURLAsset(url: url))
            }
        }

        var dict = [String: Any]()
        if let img = images.first,
           let data = img.jpegData(compressionQuality: 1) {
            dict["com.instagram.sharedSticker.backgroundImage"] = data
        } else if let video = videos.first,
                  let data = try? Data(contentsOf: video.url) {
            dict["com.instagram.sharedSticker.backgroundVideo"] = data
        }

        UIPasteboard.general.setItems([dict], options: [
            .expirationDate: Date().addingTimeInterval(60 * 5)
        ])
    }

    override func perform() {
        UIApplication.shared.open(urlScheme)
        activityDidFinish(true)
    }
}
