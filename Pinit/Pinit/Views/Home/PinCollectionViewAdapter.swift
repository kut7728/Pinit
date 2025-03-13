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
    var data: [PinEntity] = []
    var delegate: PinCollectionViewAdapterDelegate?
    init(
        collectionView: UICollectionView,
        width: CGFloat
    ) {
        super.init()
        let layout = UICollectionViewFlowLayout()
        let width = (width / 2) - 16
        layout.itemSize = .init(width: width, height: width)
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.backgroundColor = .yellow
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
        
        cell.configure()
        
        return cell
    }
}

// MARK: CollectionView Delegate
extension PinCollectionViewAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedItem(selected: data[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        // 단일 선택의 컨텍스트 메뉴만 지원할거임
        guard let indexPath = indexPaths.first else { return nil }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { elements in
            let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash")) {[weak self] action in
                let deleted = self?.data.remove(at: indexPath.row)
                self?.delegate?.deletedItem(deleted: deleted)
            }
            return UIMenu(title: "", children: [deleteAction])
        }
    }
}
