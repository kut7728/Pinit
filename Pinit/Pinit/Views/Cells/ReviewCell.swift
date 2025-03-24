//
//  NewPinReviewPanel.swift
//  Pinit
//
//  Created by nelime on 3/17/25.
//

import UIKit
import SnapKit

class ReviewCell: UITableViewCell {
    
    // MARK: - 컴포넌트 설정
    public lazy var reviewCellPanel: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    public lazy var reviewDate: UILabel = {
        let label = UILabel()
        label.text = "25년 3월 3일"
        label.font = DesignSystemFont.Pretendard_Bold16.value
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
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 2, right: 0))
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            contentView.layer.shadowOffset = CGSize(width: 10, height: 10)
            contentView.layer.shadowColor = DesignSystemColor.Purple.value.cgColor
        }else{
            contentView.layer.shadowOffset = CGSize(width: 10, height: 10)
            contentView.layer.shadowColor = DesignSystemColor.Purple.value.cgColor
        }
    }
    
    
    // MARK: - 데이터 설정 메서드
    func configure(date: String, desc: String) {
        reviewDate.text = date
        reviewText.text = desc
    }
    // MARK: - 레이아웃
    private func addComponents() {

        self.addSubviews(reviewCellPanel)
        reviewCellPanel.addSubviews(reviewDate, reviewText, reviewMenuButton)
        
        
        reviewCellPanel.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        reviewDate.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(10)
        }
        
        reviewText.snp.makeConstraints{
            $0.top.equalTo(reviewDate.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(10)
        }
        
//        reviewMenuButton.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.trailing.equalToSuperview().inset(10)
//        }
        
    }
    
}

#Preview {
    ReviewCell()
}

