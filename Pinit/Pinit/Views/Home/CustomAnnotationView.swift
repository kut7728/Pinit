//
//  CustomAnnotationView.swift
//  Pinit
//
//  Created by 안정흠 on 3/14/25.
//

import UIKit
import MapKit

final class CustomAnnotationView: MKAnnotationView {
    static let identifier = "CustomAnnotationView"
    private let titleLabel = UILabel()
    override init(annotation: MKAnnotation?, reuseIdentifier: String?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        titleLabel.font = DesignSystemFont.Pretendard_Bold12.value
        titleLabel.textAlignment = .center
        titleLabel.clipsToBounds = true
        
        // 크기 조정한 이미지 적용
        let originalImage = UIImage(named: "recordPin2")!
        let resizedImage = resizeImage(originalImage, targetSize: CGSize(width: 40, height: 40))
        self.image = resizedImage
        self.centerOffset = CGPoint(x: 0, y: frame.size.height / 2)
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 4)

        addSubview(titleLabel)
    }
    
    func configure(with annotation: CustomAnnotation) {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.white,  // 보더 색상
            .strokeWidth: -3.0,           // 음수(-)일 경우 내부에 Stroke 적용됨
            .foregroundColor: UIColor.black,
        ]
        titleLabel.attributedText = NSAttributedString(string: annotation.pinData.title, attributes: attributes)
        titleLabel.sizeToFit()
        
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.snp.bottom)
            $0.width.equalTo(bounds.size.width*2)
        }
    }
    
    private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
}


class CustomAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let pinData: PinEntity
    
    init(pinData: PinEntity) {
        self.pinData = pinData
        self.coordinate = .init(
            latitude: self.pinData.latitude,
            longitude: self.pinData.longitude
        )
        super.init()
    }
    
}
