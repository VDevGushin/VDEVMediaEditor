//
//  TutorialsSource.swift
//  
//
//  Created by Vladislav Gushin on 18.06.2023.
//

import Foundation

let tutorialsSource: [TutorialsModel] = [
    TutorialsModel(title: "Copy and paste or drag and drop",
                   subtitle: "Try copying and pasting objects from the web browser or gallery, or drag and drop them",
                   videoURL: URL.getLocal(fileName: "CopyPaste",
                                          ofType: "mp4")!),
    TutorialsModel(title: "Capture videos",
                   subtitle: "Use the camera to capture videos and use them in the editor.",
                   videoURL: URL.getLocal(fileName: "CameraVideo",
                                          ofType: "mp4")!),
    TutorialsModel(title: "Capture photos",
                   subtitle: "Use the camera to capture photos and use them in the editor.",
                   videoURL: URL.getLocal(fileName: "CameraPhoto",
                                          ofType: "mp4")!),
    TutorialsModel(title: "Photos from gallery",
                   subtitle: "Select and use your photos from the gallery",
                   videoURL: URL.getLocal(fileName: "AddPhotos",
                                          ofType: "mp4")!),
    TutorialsModel(title: "Videos from gallery",
                   subtitle: "Select and use your videos from the gallery",
                   videoURL: URL.getLocal(fileName: "AddVideos",
                                          ofType: "mp4")!),
    TutorialsModel(title: "Stickers",
                   subtitle: "Choose and use your favorite sticker from our collection of stickers",
                   videoURL: URL.getLocal(fileName: "Stickers",
                                          ofType: "mp4")!),
    TutorialsModel(title: "Text",
                   subtitle: "You can type text in different styles and colors",
                   videoURL: URL.getLocal(fileName: "Text",
                                          ofType: "mp4")!),
    TutorialsModel(title: "Templates",
                   subtitle: "A custom template will help you make your result more interesting and beautiful.",
                   videoURL: URL.getLocal(fileName: "Templates",
                                          ofType: "mp4")!),
    TutorialsModel(title: "Drawing",
                   subtitle: "You can draw anything with the drawing tool",
                   videoURL: URL.getLocal(fileName: "Drawing",
                                          ofType: "mp4")!),
    
    TutorialsModel(title: "Auto quality",
                   subtitle: "Try using auto quality to make your result more beautiful",
                   videoURL: URL.getLocal(fileName: "AutoQuality",
                                          ofType: "mp4")!),
    
    TutorialsModel(title: "Tutorials",
                   subtitle: """
You can see all our tutorials in settings menu:
Layers -> Settings -> Materials/Show tutorials
""",
                   videoURL: URL.getLocal(fileName: "AllTutorials",
                                          ofType: "mp4")!)
    
]
