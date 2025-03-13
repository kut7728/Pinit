//
//  PinCollectionViewAdapter.swift
//  Pinit
//
//  Created by 안정흠 on 3/13/25.
//

import UIKit

//protocol

final class PinCollectionViewAdapter: NSObject {
    var data: [PinEntity] = []
    
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
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
    }
}

extension PinCollectionViewAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PinRecordCell
        else { return UICollectionViewCell() }
        
//        cell.configure()
        
        return cell
    }
    
    
}
