//
//  NewPinReviewPanel.swift
//  Pinit
//
//  Created by nelime on 3/17/25.
//

import UIKit
import SnapKit

class ReviewCell: UITableViewCell {
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 컴포넌트 설정
    public lazy var reviewCellPanel: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    public lazy var reviewDate: UILabel = {
        let label = UILabel()
        label.text = "25년 3월 3일"
        label.font = DesignSystemFont.Pretendard_SemiBold16.value
        return label
    }()
    
    public lazy var reviewText: UILabel = {
        let label = UILabel()
        label.text = "뭐 대충 이런게 인생 아이겠심까"
        label.font = DesignSystemFont.Pretendard_Medium18.value
        return label
    }()
    
    public lazy var reviewMenuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    
    
    // MARK: - 데이터 설정 메서드
    func configure(date: String, desc: String) {
        reviewDate.text = date
        reviewText.text = desc
    }
    
    
    
    
    // MARK: - 레이아웃
    private func addComponents() {
        self.addSubviews(reviewCellPanel)
        reviewCellPanel.addSubviews(reviewDate, reviewText, reviewMenuButton)
        
        
        reviewCellPanel.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(60)
            $0.centerY.equalToSuperview()
        }
        
        reviewDate.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
        }
        
        reviewText.snp.makeConstraints{
            $0.top.equalTo(reviewDate.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(10)
        }
        
        reviewMenuButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
        
    }
    
}

#Preview {
    ReviewCell()
}

