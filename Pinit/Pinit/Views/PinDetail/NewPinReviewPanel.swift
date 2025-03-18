//
//  NewPinReviewPanel.swift
//  Pinit
//
//  Created by nelime on 3/17/25.
//

import UIKit

class NewPinReviewPanel: UIView {

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public lazy var newReviewPanel: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    public lazy var reviewDate: UILabel = {
        let label = UILabel()
        label.text = "1998년 03월 02일"
        label.font = DesignSystemFont.Pretendard_SemiBold16.value
        return label
    }()
    
    public lazy var reviewText: UITextField = {
       let textField = UITextField()
        
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1).cgColor // #A9A9A9 (다크 라이트 그레이)
        textField.layer.borderWidth = 2
        textField.textColor = .black
        textField.layer.cornerRadius = 5
        textField.font = DesignSystemFont.Pretendard_Bold14
            .value
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        
        textField.placeholder = "test"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    public lazy var commitButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .default)
        let largeImage = UIImage(systemName: "arrow.right.circle.fill")?.withConfiguration(largeConfig)
        button.setImage(largeImage, for: .normal)
        button.tintColor = .systemGreen
        return button
    }()
    
    private func addComponents() {
        self.addSubview(newReviewPanel)
        newReviewPanel.addSubviews(reviewDate, reviewText, commitButton)
        
        newReviewPanel.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        reviewDate.snp.makeConstraints {
//            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.top.equalTo(newReviewPanel.snp.top).inset(10)
            $0.leading.equalToSuperview().offset(10)
        }
        
        reviewText.snp.makeConstraints {
            $0.top.equalTo(reviewDate.snp.bottom).offset(10)
            $0.width.equalTo(340)
            $0.height.equalTo(40)
            
            $0.leading.equalToSuperview().offset(10)
//            $0.trailing.equalTo(commitButton.snp.leading).offset(-10)
            
        }
        
        commitButton.snp.makeConstraints {
            $0.top.equalTo(reviewDate.snp.bottom).offset(10)
//            $0.leading.equalTo(reviewText.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalTo(reviewText.snp.centerY)  // y축 기준 정렬
            
        }
    }

}

#Preview {
    NewPinReviewPanel()
}
