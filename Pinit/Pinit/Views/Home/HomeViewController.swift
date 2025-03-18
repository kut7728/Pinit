//
//  HomeViewController.swift
//  Pinit
//
//  Created by nelime on 3/10/25.
//

import UIKit
import MapKit
import SnapKit

class HomeViewController: UIViewController {
    // MARK: Variables
    // BottomSheet 동적 높이를 저장하기위한 변수
    private lazy var bottomSheetHeight: CGFloat = view.frame.height / 14
    private let circleButtonSize: CGFloat = 48
    private let locationmanager = CLLocationManager()
    private let usecase: UseCase
    
    // MARK: UI Components
    private var adapter: PinCollectionViewAdapter?
    private let mapView = MKMapView(frame: .zero)
    private let bottomSheet = CustomBottomSheet()
    private lazy var addPinButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "pencil.line")
        button.setImage(UIImage(systemName: "pencil.line"), for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = circleButtonSize / 2
        button.clipsToBounds = true
        return button
    }()
    private lazy var currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "dot.scope"), for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = circleButtonSize / 2
        button.clipsToBounds = true
        return button
    }()
    
    init(usecase: UseCase) {
        self.usecase = usecase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        setupMapLocation()
        setupAdapter()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        loadAnnotations()
    }
    
    private func setupMapLocation() {
        locationmanager.delegate = self
        mapView.delegate = self
        
        homeMapRequestAuthorization()
        
        mapView.showsUserLocation = true
        mapView.setCameraZoomRange(.init(minCenterCoordinateDistance: 333, maxCenterCoordinateDistance: 5000), animated: true)
        mapView.setRegion(
            .init(
                center: locationmanager.location?.coordinate ?? .init(),
                span: .init(latitudeDelta: 0.003, longitudeDelta: 0.003)),
            animated: true
        )
        mapView.isRotateEnabled = false
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
        //        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ClusterView")
        
        loadAnnotations(PinEntity.sampleData)
    }
    
    private func loadAnnotations(_ samepleData: [PinEntity]? = nil) {
        if let sampleData = samepleData {
            let annotations = PinEntity.sampleData.map{CustomAnnotation(pinData: $0)}
            mapView.addAnnotations(annotations)
        }
        else {
            usecase.fetchAllPins {[weak self] pins in
                let annotations = pins.map { CustomAnnotation(pinData: $0) }
                self?.mapView.addAnnotations(annotations)
            }
        }
    }
    
    private func setupProperties() {
        view.backgroundColor = .gray
        // 바텀시트 패닝 제스처 추가
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))
        bottomSheet.addGestureRecognizer(panGesture)
        // 버튼 액션 추가
        addPinButton.addTarget(self, action: #selector(moveToAddPin), for: .touchUpInside)
        currentLocationButton.addTarget(self, action: #selector(moveToUserLocation), for: .touchUpInside)
    }
    
    private func setupAdapter() {
        adapter = PinCollectionViewAdapter(
            collectionView: bottomSheet.collectionView,
            width: view.frame.width
        )
        adapter?.delegate = self
        adapter?.data = PinEntity.sampleData
    }
    
    private func setupLayout() {
        view.addSubviews(mapView, addPinButton, currentLocationButton, bottomSheet)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        bottomSheet.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(bottomSheetHeight)
        }
        addPinButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(bottomSheetHeight * 2.5)
            $0.size.equalTo(circleButtonSize)
        }
        currentLocationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.bottom.equalTo(addPinButton.snp.top).offset(-10)
            $0.size.equalTo(circleButtonSize)
        }
    }
}

// MARK: MapView Delegate
extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 사용자 위치 마커는 무시
        guard !(annotation is MKUserLocation) else { return nil }
        
        if let cluster = annotation as? MKClusterAnnotation {
            return createClusterView(for: cluster)
        }
        if let customAnnotation = annotation as? CustomAnnotation {
            return createCustomAnnotationView(for: customAnnotation, in: mapView)
        }
        
        return nil
        
    }
    private func createCustomAnnotationView(for annotation: CustomAnnotation, in mapView: MKMapView) -> MKAnnotationView {
        let identifier = CustomAnnotationView.identifier
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomAnnotationView
        
        if annotationView == nil {
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.configure(with: annotation)
        return annotationView!
    }
    
    private func createClusterView(for cluster: MKClusterAnnotation) -> MKAnnotationView {
        let identifier = "ClusterView"
        var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if clusterView == nil {
            clusterView = MKMarkerAnnotationView(annotation: cluster, reuseIdentifier: identifier)
        } else {
            clusterView?.annotation = cluster
        }
        
        clusterView?.markerTintColor = .systemBlue
        clusterView?.glyphText = "\(cluster.memberAnnotations.count)" // 클러스터 내 개수 표시
        clusterView?.displayPriority = .defaultHigh  // 클러스터를 우선적으로 표시
        
        return clusterView!
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? CustomAnnotation {
            print("Selected pin ID: \(annotation.pinData.pin_id)")
            // 상세 화면 이동
        }
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let visibleAnnotations = mapView.annotations(in: mapView.visibleMapRect)
        let visibleMarkers = visibleAnnotations.compactMap { $0 as? CustomAnnotation }
        // BottomSheet의 CollectionView 업데이트
        adapter?.data = visibleMarkers.map{ $0.pinData }
        bottomSheet.collectionView.reloadData()
    }
}

// MARK: CLLocationManager
extension HomeViewController: CLLocationManagerDelegate {
    func homeMapRequestAuthorization() {
        let status = locationmanager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationmanager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            showAlertAboutLocation()
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            showAlertAboutLocation()
        }
    }
}

// MARK: PinCollectionViewAdapterDelegate
extension HomeViewController: PinCollectionViewAdapterDelegate {
    func selectedItem(selected: PinEntity) {
        print("Selected: \(selected)")
        // 여기서 화면 이동
        //        PinDetailViewController(usecase: usecase, pin: selected)
    }
    
    func deletedItem(deleted: PinEntity?) {
        print("Deleted: \(deleted?.title ?? "empty")")
        // 여기서 CoreData 업데이트
//                guard let deleted = deleted else { return }
//        usecase.deletePin(pinID: deleted.pin_id)
//        let deletedAnnotation = CustomAnnotation(pinData: deleted)
//        mapView.removeAnnotation(deletedAnnotation)
//        삭제후 현재 위치의 어노테이션이 뭐가 있는지 다시 로드
//        mapView(mapView, regionDidChangeAnimated: true)
    }
}

// MARK: @objc event callback function
extension HomeViewController {
    @objc private func moveToAddPin() {
        // 유저 현재위치 못받아오면 권한 설정을 안한거니까 알럿띄움
        guard let location = locationmanager.location?.coordinate else {
            showAlertAboutLocation()
            return
        }
        
        print("기록하기 화면으로 이동")
    }
    
    @objc private func moveToUserLocation() {
        guard let location = locationmanager.location?.coordinate else {
            showAlertAboutLocation()
            return
        }
        mapView.setRegion(
            .init(
                center: location,
                span: .init(latitudeDelta: 0.001, longitudeDelta: 0.001)),
            animated: true
        )
    }
    
    @objc private func panGestureHandler(_ gesture: UIPanGestureRecognizer) {
        // Pretend 크기 설정
        let small = view.frame.height / 14
        let medium = view.frame.height * 0.4
        let large = view.frame.height * 0.8
        // 제스처 시작
        let translation = gesture.translation(in: view)
        let newHeight = bottomSheetHeight - translation.y
        // 제스처 (드래그) 위치에 따라 업데이트
        if newHeight >= small && newHeight <= large {
            bottomSheetHeight = newHeight
            gesture.setTranslation(.zero, in: view)
        }
        // 제스터 (드래그 끝났을때) 위치에 따라 최종 높이 업데이트
        if gesture.state == .ended {
            // 높이 조정 pretend?
            if newHeight > (view.frame.height * 0.6) {
                bottomSheetHeight = large
            }
            else if newHeight > (view.frame.height * 0.3) {
                bottomSheetHeight = medium
            }
            else {
                bottomSheetHeight = small
            }
        }
        bottomSheet.snp.updateConstraints {
            $0.height.equalTo(self.bottomSheetHeight)
        }
        // Constraint 업데이트 + Animation
        UIView.animate(withDuration: 0.07) {
            self.view.layoutIfNeeded()
        }
    }
}

#Preview{
    HomeViewController(usecase: DIContainer.usecase)
}
