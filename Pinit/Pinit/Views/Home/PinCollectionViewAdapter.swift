//
//  PinCollectionViewAdapter.swift
//  Pinit
//
//  Created by 안정흠 on 3/13/25.
//

import UIKit

// MARK: CollectionView Adapter Delegate
protocol PinCollectionViewAdapterDelegate: AnyObject {
    // 선택된 아이템 넘겨줌
    func selectedItem(selected: PinEntity)
    // 삭제된 아이템 넘겨줌 (id만 넘겨줄지 고민중 CoreData에서 id에 따라 삭제하는거 말고는 필요 없어서)
    func deletedItem(deleted: PinEntity?)
}

// MARK: CollectionView Adapter
final class PinCollectionViewAdapter: NSObject {
    var data: [PinEntity] = [] // 어댑터에서 datasource 관리
    var delegate: PinCollectionViewAdapterDelegate? // CollectionView 선택, 삭제등의 결과를 받기위한 Delegate
    init(
        collectionView: UICollectionView,
        width: CGFloat
    ) {
        super.init()
        // CollectionView 설정
        let layout = UICollectionViewFlowLayout()
        let spacing = 16.0
        let width = (width / 2) - (spacing * 2)
        layout.itemSize = .init(width: width, height: width * 1.2)
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.register(PinRecordCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: CollectionView DataSource
extension PinCollectionViewAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PinRecordCell
        else { return UICollectionViewCell() }
        
        cell.configure(model: data[indexPath.row])
        cell.layoutIfNeeded()
        
        return cell
    }
}

// MARK: CollectionView Delegate
extension PinCollectionViewAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedItem(selected: data[indexPath.row]) // 선택된 아이템 delegate로 보냄
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        // 단일 선택의 컨텍스트 메뉴만 지원할거임
        guard let indexPath = indexPaths.first else { return nil }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { elements in
            let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) {[weak self] action in
                let deleted = self?.data.remove(at: indexPath.row)
                self?.delegate?.deletedItem(deleted: deleted) // 삭제된 아이템 delegate로 보냄
            }
            return UIMenu(title: "", children: [deleteAction])
        }
    }
}
