//
//  PinDetailView.swift
//  Pinit
//
//  Created by nelime on 3/17/25.
//

import UIKit
import SnapKit
import MapKit

class PinDetailView: UIView {
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - View
    
    // 지도 뷰
    public lazy var mapView: MKMapView = {
        let map = MKMapView()
        
        let center = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // San Francisco, CA
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // San Francisco, CA
        annotation.title = "San Francisco"
        annotation.subtitle = "CA"
        map.addAnnotation(annotation)
        
        return map
    }()
    
    // 탈출 버튼
    public lazy var dismissButton: UIButton = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 45, weight: .bold, scale: .default)
        let largeImage = UIImage(systemName: "xmark.circle.fill")?.withConfiguration(largeConfig)
        let button = UIButton()
        button.setImage(largeImage, for: .normal)
        button.tintColor = .black
        button.alpha = 0.7 // 투명도 50% 설정
        return button
    }()
    
    // 리뷰 컨테이너
    public lazy var reviewContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
//        view.addSubview(PinReviewTableViewController.pinTableView)
        return view
    }()
    
    
    // 리뷰 작성 패널
    public lazy var reviewPanelContainerView: NewPinReviewPanel = {
        let view = NewPinReviewPanel()
        return view
    }()
    
    // MARK: - Layout
    private func addComponents() {
        self.addSubviews(mapView, dismissButton, reviewContainerView, reviewPanelContainerView)
        
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)  // 기기의 안전구역부터 시작하도록
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.25)  // 기기의 높이 *0.25로 높이 설정
        }
        
        dismissButton.snp.makeConstraints {
            $0.height.width.equalTo(40)
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(5)
            $0.trailing.equalToSuperview().inset(5)
        }
        
        reviewPanelContainerView.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(100)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        reviewContainerView.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom)  // 지도 밑으로
            $0.bottom.equalTo(reviewPanelContainerView.snp.top)  // 리뷰 패널 위로
            $0.leading.trailing.equalToSuperview()  // 가로세로 화면에 밀착
        }
        
        
    }
}


#Preview {
    PinDetailViewController()
}
