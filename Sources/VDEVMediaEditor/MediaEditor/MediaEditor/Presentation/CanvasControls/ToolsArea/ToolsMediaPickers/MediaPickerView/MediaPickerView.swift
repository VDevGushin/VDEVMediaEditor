//
//  MediaPickerView.swift
//  
//
//  Created by Vladislav Gushin on 18.10.2023.
//

import SwiftUI

enum MediaPickerViewType {
    case all
    case video
    case image
}

struct MediaPickerView: View {
    enum Section : String, CaseIterable {
        case photos = "Photos"
        case videos = "Videos"
    }
    
    @State private var segmentationSelection : Section = .photos
    
    private let needOriginal: Bool
    private let pickerType: MediaPickerViewType
    private let onComplete: (PickerMediaOutput?) -> Void
    
    init(
        pickerType: MediaPickerViewType = .all,
        needOriginal: Bool,
        onComplete: @escaping (PickerMediaOutput?) -> Void
    ) {
        self.needOriginal = needOriginal
        self.onComplete = onComplete
        self.pickerType = pickerType
    }
    
    var body: some View {
        switch pickerType {
        case .all:
            mediaPickerForAll()
        case .video:
            PhotoPickerView(
                type: .video,
                needOriginal: needOriginal,
                onComplete: onComplete
            )
            .edgesIgnoringSafeArea(.all)
        case .image:
            PhotoPickerView(
                type: .image,
                needOriginal: needOriginal,
                onComplete: onComplete
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    @ViewBuilder
    private func mediaPickerForAll() -> some View {
        VStack {
            Picker(segmentationSelection.rawValue, selection: $segmentationSelection) {
                ForEach(Section.allCases, id: \.self) { option in
                    Text(option.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            ZStack {
                PhotoPickerView(
                    type: .image,
                    needOriginal: needOriginal,
                    onComplete: onComplete
                )
                .opacity(segmentationSelection == .photos ? 1.0 : 0.0)
                
                PhotoPickerView(
                    type: .video,
                    needOriginal: needOriginal,
                    onComplete: onComplete
                )
                .opacity(segmentationSelection == .videos ? 1.0 : 0.0)
            }
            .clipShape(
                RoundedCorner(radius: 8, corners: [.topLeft, .topRight])
            )
            .animation(.easeInOut, value: segmentationSelection)
        }
        .edgesIgnoringSafeArea([.trailing, .leading, .bottom])
        .background(.black)
    }
}
