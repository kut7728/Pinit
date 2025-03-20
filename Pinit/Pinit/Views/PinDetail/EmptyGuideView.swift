//
//  EmptyGuideView.swift
//  Pinit
//
//  Created by nelime on 3/17/25.
//


//
//  EmptyGuideView.swift
//  WeeklyProject-MyContentManager
//
//  Created by 안정흠 on 3/7/25.
//

import UIKit

final class EmptyGuideView: UIView {
    private let iconImageView: UIImageView
    private let guideTitleLabel: UILabel
    private let guideMessage: UILabel
    
    init(systemImage: UIImage?, title: String, message: String) {
        iconImageView = UIImageView(image: systemImage)
        guideTitleLabel = UILabel()
        guideMessage = UILabel()
        
        guideTitleLabel.text = title
        guideMessage.text = message
        super.init(frame: .infinite)
        setupViewProperties()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        [iconImageView, guideTitleLabel, guideMessage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 64),
            iconImageView.widthAnchor.constraint(equalToConstant: 64),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            guideTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            guideTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            guideTitleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            
            guideMessage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            guideMessage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            guideMessage.topAnchor.constraint(equalTo: guideTitleLabel.bottomAnchor, constant: 16)
        ])
    }
    
    private func setupViewProperties() {
        backgroundColor = .secondarySystemBackground
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .gray
        
        guideTitleLabel.font = .preferredFont(forTextStyle: .title1)
        guideMessage.font = .preferredFont(forTextStyle: .body)
        
        [guideTitleLabel, guideMessage].forEach {
            $0.textColor = .gray
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    }
}