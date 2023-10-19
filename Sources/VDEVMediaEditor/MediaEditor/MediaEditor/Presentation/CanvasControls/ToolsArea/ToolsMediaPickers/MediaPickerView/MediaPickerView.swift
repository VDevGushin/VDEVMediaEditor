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
    @State private var animationSelection: SegmentedControlAnimation = .easeInOut
    @State private var selection: Section = .photos
    
    private var containerCornerRadius: CGFloat = 8
    private let options: [Section] = [.photos, .videos]
    private let insets: EdgeInsets = .zero
    private let interSegmentSpacing: CGFloat = 2
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
    
    private func selectionView(color: Color = AppColors.whiteWithOpacity2) -> some View {
        color.clipShape(RoundedRectangle(cornerRadius: containerCornerRadius - 4))
    }
    
    private func segmentView(
        title: String,
        imageName: UIImage?,
        isPressed: Bool
    ) -> some View {
        HStack(spacing: 4) {
            Text(title)
                .foregroundColor(AppColors.white)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
            
            imageName.map {
                Image(uiImage: $0)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .scaledToFit()
            }
        }
        .foregroundColor(.white.opacity(isPressed ? 0.7 : 1))
        .lineLimit(1)
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
    }
    
    
    @ViewBuilder
    private func mediaPickerForAll() -> some View {
        VStack {
            MediaPickerSegmentControl(
                selection: $selection,
                options: options,
                selectionView: selectionView(),
                segmentContent: { option, isPressed in
                    segmentView(
                        title: option.title,
                        imageName: option.imageName,
                        isPressed: isPressed
                    )
                }
            )
            .insets(insets)
            .segmentedControlContentStyle(.blendMode())
            .segmentedControlSlidingAnimation(animationSelection.value)
            .segmentedControl(interSegmentSpacing: interSegmentSpacing)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: containerCornerRadius))
            
            ZStack {
                PhotoPickerView(
                    type: .image,
                    needOriginal: needOriginal,
                    onComplete: onComplete
                )
                .opacity(selection == .photos ? 1.0 : 0.0)
                
                PhotoPickerView(
                    type: .video,
                    needOriginal: needOriginal,
                    onComplete: onComplete
                )
                .opacity(selection == .videos ? 1.0 : 0.0)
            }
            .clipShape(
                RoundedCorner(
                    radius: 8,
                    corners: [.topLeft, .topRight]
                )
            )
            .animation(.easeInOut, value: selection)
        }
        .edgesIgnoringSafeArea([.trailing, .leading, .bottom])
        .background(.black)
    }
}

extension MediaPickerView {
    enum Section : String, CaseIterable, Identifiable {
        case photos
        case videos
        var id: String { rawValue }
        var title: String {
            let strings = DI.resolve(VDEVMediaEditorStrings.self)
            switch self {
            case .photos: return strings.photos
            case .videos: return strings.videos
            }
        }
        var imageName: UIImage? {
            let images = DI.resolve(VDEVImageConfig.self)
            switch self {
            case .photos: return images.typed.typePhoto
            case .videos: return images.typed.typeVideo
            }
        }
    }
    
    enum SegmentedControlAnimation: String, CaseIterable, Identifiable {
        case `default`
        case easeInOut
        var id: String { rawValue }
        var title: String { rawValue.capitalized }
        var value: Animation {
            switch self {
            case .default: return .default
            case .easeInOut: return .easeInOut
            }
        }
    }
}
