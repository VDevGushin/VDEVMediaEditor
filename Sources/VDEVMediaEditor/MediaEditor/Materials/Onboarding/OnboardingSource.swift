//
//  OnboardingSourceSource.swift
//  
//
//  Created by Vladislav Gushin on 19.06.2023.
//

import UIKit

struct OnboardingSourceModel: Identifiable {
    private(set) var title: String
    private(set) var subtitle: String
    // Image
    private(set) var imageURL: URL?
    
    var id: String { title }
    
    init(title: String, subtitle: String, imageURL: URL? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}

let onboardingSource: [OnboardingSourceModel] = [
    .init(title: "Capture videos and photos or add them from gallery",
          subtitle: "Use the camera or gallery to get media files and use them in the editor",
          imageURL: URL.getLocal(fileName: "Gallery",
                                ofType: "jpg")!),
    
    .init(title: "Copy and paste or drag and drop",
              subtitle: "Try copying and pasting objects from the web browser or gallery, or drag and drop them",
    imageURL: URL.getLocal(fileName: "Drag",
                          ofType: "jpg")!),
    
        .init(title: "Stickers",
              subtitle: "Choose and use your favorite sticker from our collection of stickers",
              imageURL: URL.getLocal(fileName: "Stickers",
                                     ofType: "jpg")!),
    
    .init(title: "Text",
          subtitle: "You can type text in different styles and colors",
          imageURL: URL.getLocal(fileName: "Text",
                                ofType: "jpg")!),
    
    .init(title: "Templates",
          subtitle: "A custom template will help you make your result more interesting and beautiful.",
          imageURL: URL.getLocal(fileName: "Templates",
                                ofType: "jpg")!),
    
    .init(title: "Drawing",
          subtitle: "You can draw anything with the drawing tool",
          imageURL: URL.getLocal(fileName: "Drawing",
                                ofType: "jpg")!),
    
        .init(title: "Tutorials",
              subtitle: """
You can see all our tutorials in settings menu:
Layers -> Settings -> Materials/Show tutorials
""",
              imageURL: URL.getLocal(fileName: "ShowMaterials",
                                    ofType: "jpg")!)
    
]
