//
//  CustomBottomSheet.swift
//  Pinit
//
//  Created by 안정흠 on 3/13/25.
//

import UIKit

final class CustomBottomSheet: UIView {
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    let grabber: UIView = {
        let grabber = UIView()
        grabber.layer.cornerRadius = 4
        grabber.backgroundColor = .black
        grabber.layer.borderColor = UIColor.white.cgColor
        grabber.layer.borderWidth = 1
        grabber.clipsToBounds = true
        grabber.isUserInteractionEnabled = false //Grabber는 Guide용으로만 사용
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
        let cornerRadius = 20.0
        self.backgroundColor = .white
        self.layer.cornerRadius = cornerRadius
        // cornerRadius 상단 좌,우측만 적용하기
        self.layer.maskedCorners = .init(arrayLiteral: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        
        addSubviews(collectionView, grabber)

        grabber.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(8)
            $0.width.equalTo(100)
            $0.height.equalTo(grabber.layer.cornerRadius * 2)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(cornerRadius*2)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
