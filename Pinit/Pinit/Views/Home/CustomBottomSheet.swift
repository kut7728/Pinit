//
//  CustomBottomSheet.swift
//  Pinit
//
//  Created by 안정흠 on 3/13/25.
//

import UIKit

final class CustomBottomSheet: UIView {
    var collectionView = UICollectionView()
    let grabber: UIView = {
        let grabber = UIView()
        grabber.layer.cornerRadius = 3
        grabber.backgroundColor = .black
        grabber.layer.borderColor = UIColor.white.cgColor
        grabber.layer.borderWidth = 1
        return grabber
    }()
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = .init(arrayLiteral: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        
        addSubviews(collectionView, grabber)
        
        grabber.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(grabber.layer.cornerRadius * 2)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().offset(8)
            $0.top.equalToSuperview().offset(16)
        }
    }
}
