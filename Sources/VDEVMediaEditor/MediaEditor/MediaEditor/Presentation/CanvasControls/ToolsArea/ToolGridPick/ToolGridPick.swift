//
//  ToolGridPick.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import SwiftUI
import Kingfisher

protocol GridToolItem {
    var coverUrl: URL? { get }

    static var cellAspect: CGFloat { get }
    static var contentMode: UIView.ContentMode { get }
}

struct GridPickTool<ItemModel: GridToolItem, DataSource>: View where DataSource: SectionedDataSource,
                                                                 DataSource.ItemModel == ItemModel,
                                                                     DataSource: ObservableObject {
    @StateObject private var dataSource: DataSource
    
    private let itemSelected: (ItemModel?) async -> ()
    
    init(
        dataSource: DataSource,
        itemSelected: @escaping (ItemModel?) async -> ()
    ) {
        self._dataSource = .init(wrappedValue: dataSource)
        self.itemSelected = itemSelected
    }
    
    private struct _GridSelectTool: UIViewRepresentable {
        let sections: [DataSource.Sect]
        let getTextForIndexPath: (IndexPath) -> String?
        let getSelectionForIndexPath: @MainActor (IndexPath) -> Bool
        let itemSelected: (IndexPath) async -> ()
        
        final class Coordinator: NSObject,
                                 UICollectionViewDelegate,
                                 UICollectionViewDataSource,
                                 UICollectionViewDelegateFlowLayout {
            private var parent: _GridSelectTool
            var sections: [DataSource.Sect]
            
            init(parent: _GridSelectTool, sections: [DataSource.Sect]) {
                self.parent = parent
                self.sections = sections
            }
            
            // MARK: - UICollectionViewDataSource
            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                sections[section].items.count
            }
            
            func numberOfSections(in collectionView: UICollectionView) -> Int {
                sections.count
            }
            
            // MARK: - UICollectionViewDelegate
            func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
                guard let cell = collectionView.cellForItem(at: indexPath) as? ToolGridPickCell else {
                    return true
                }
                
                return !cell.inProgress
            }
            
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "GridPickCell", for: indexPath)
            }
            
            func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
                guard let cell = cell as? ToolGridPickCell else { return }
                cell.imageView.contentMode = ItemModel.contentMode
                cell.imageView.kf.cancelDownloadTask()
                cell.imageView.image = nil
                
                let cellSize = cellSize(in: collectionView)
                let item = sections[indexPath.section].items[indexPath.item]
                if let coverUrl = item?.coverUrl?.uc.resized(width: cellSize.width) {
                    cell.imageView.kf.setImage(
                        with: coverUrl,
                        placeholder: ActivityPlaceholder()
                    )
                    cell.imageView.backgroundColor = nil
                } else {
                    cell.imageView.backgroundColor = AppColors.gray.uiColor
                }
                
                cell.label.text = parent.getTextForIndexPath(indexPath)
                
                cell.contentView.layer.borderColor = parent.getSelectionForIndexPath(indexPath) ? AppColors.white.cgColor : AppColors.clear.cgColor
            }
            
            func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                Task {
                    guard let cell = collectionView.cellForItem(at: indexPath) as? ToolGridPickCell else {
                        return
                    }
                    cell.inProgress = true
                    await parent.itemSelected(indexPath)
                    cell.inProgress = false
                    collectionView.reloadData()
                }
            }
            
            // MARK: - suplementary
            func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GridPickHeaders", for: indexPath)
                
                if view.subviews.isEmpty {
                    let label = UILabel()
                    label.font = UIFont(name: "Gramatika-Bold", size: 14)
                    label.textColor = AppColors.white.uiColor
                    label.textAlignment = .left
                    view.addSubview(label)
                    label.edgesTo(view)
                }
                
                return view
            }
            
            func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
                guard let labelView = view.subviews.first(where: { $0 is UILabel }) as? UILabel else { return }
                labelView.text = sections[indexPath.section].name
                if sections.count == 1 || indexPath.section > 0 {
                    labelView.textColor = AppColors.white.uiColor.withAlphaComponent(0.2)
                } else {
                    labelView.textColor = AppColors.white.uiColor
                }
            }
            
            // MARK: - UICollectionViewDelegateFlowLayout
            let columns: CGFloat = 3
            let interItemPadding: CGFloat = 8
            
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
                return cellSize(in: collectionView)
            }
            
            private func cellSize(in collectionView: UICollectionView) -> CGSize {
                let frameSize = collectionView.bounds.size
                let magicInset = CGFloat(4)
                let rowWidth = frameSize.width - (interItemPadding * (columns - 1)) - magicInset
                let cellWidth = rowWidth / columns
                let cellHeight = cellWidth * ItemModel.cellAspect
                
                return CGSize(width: cellWidth, height: cellHeight)
            }
            
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
                guard sections[section].name != nil else {
                    return CGSize(width: collectionView.bounds.width, height: 16)
                }
                return CGSize(width: collectionView.bounds.width, height: 50)
            }
            
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                interItemPadding
            }
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(parent: self, sections: [])
        }
        
        func makeUIView(context: Context) -> UICollectionView {
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            collectionView.delegate = context.coordinator
            collectionView.dataSource = context.coordinator
            collectionView.register(ToolGridPickCell.self, forCellWithReuseIdentifier: "GridPickCell")
            collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GridPickHeaders")
            collectionView.backgroundView = nil
            collectionView.backgroundColor = .clear
            return collectionView
        }
        
        func updateUIView(_ uiView: UICollectionView, context: Context) {
            context.coordinator.sections = sections
            uiView.reloadData()
        }
    }
    
    private func getLoadingSize(_ geometry: GeometryProxy) -> CGSize {
        let frameSize = geometry.size
        let columns: CGFloat = 3
        let magicInset = CGFloat(4)
        let interItemPadding: CGFloat = 8
        let rowWidth = frameSize.width - (interItemPadding * (columns - 1)) - magicInset
        let cellWidth = rowWidth / columns
        let cellHeight = cellWidth * ItemModel.cellAspect
        return .init(width: cellWidth, height: cellHeight)
    }
    
    var body: some View {
        Group {
            if dataSource.isLoading {
                GeometryReader { proxy in
                    LoadingView(inProgress: true,
                                color: AppColors.white.uiColor)
                        .frame(getLoadingSize(proxy))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal)
                }
            } else {
                _GridSelectTool(
                    sections: dataSource.sections,
                    getTextForIndexPath: dataSource.text(for:),
                    getSelectionForIndexPath: dataSource.selection(for:)
                ) { indexPath in
                    let item = dataSource.sections[indexPath.section].items[indexPath.item]
                    await itemSelected(item)
                }
            }
        }
        .onAppear {
            Task {
                await dataSource.load()
            }
        }
    }
}
