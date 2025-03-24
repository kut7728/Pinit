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
    private let locationmanager = LocationManager()
    private let service: Service
    
    // MARK: UI Components
    private var adapter: PinCollectionViewAdapter?
    private let mapView = MKMapView(frame: .zero)
    private let bottomSheet = CustomBottomSheet()
    
    private lazy var addPinButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil.line"), for: .normal)
        button.backgroundColor = DesignSystemColor.Lavender.value
        button.tintColor = .white
        button.layer.cornerRadius = circleButtonSize / 2
        button.clipsToBounds = true
        return button
    }()
    private lazy var currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "dot.scope"), for: .normal)
        button.backgroundColor = DesignSystemColor.Lavender.value
        button.tintColor = .white
        button.layer.cornerRadius = circleButtonSize / 2
        button.clipsToBounds = true
        return button
    }()
    
    init(service: Service) {
        self.service = service
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
        loadAnnotations()
    }
    
    private func setupMapLocation() {
        mapView.delegate = self
        
        mapView.showsUserLocation = true
#warning("setCameraZoomRange 주석")
//        mapView.setCameraZoomRange(.init(minCenterCoordinateDistance: 333, maxCenterCoordinateDistance: 5000), animated: true)
        // Location 불러오기 전 기본값 설정
        var currentLocation = CLLocationCoordinate2D(
            latitude: 37.277252,
            longitude: 127.136331
        )
        if let location = locationmanager.getCurrentUserLocation() {
            currentLocation = location // 정상적으로 불러옴
        }
        else { showAlertAboutLocation() } // 권한이 없을경우 불러오지 못하고 알럿띄움
        
        mapView.setRegion(
            .init(
                center: currentLocation,
                span: .init(latitudeDelta: 0.003, longitudeDelta: 0.003)),
            animated: true
        )
        mapView.isRotateEnabled = false
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "annotation")
        mapView.register(CustomClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomClusterAnnotationView.identifier)
        
        loadAnnotations()
    }
    
    private func loadAnnotations() {
        service.fetchAllPins { pins in
            self.mapView.removeAnnotations(self.mapView.annotations)
            let annotations = pins.map { CustomAnnotation(pinData: $0) }
            self.mapView.addAnnotations(annotations)
            self.mapView(self.mapView, regionDidChangeAnimated: true)
            self.adapter?.data = pins.sorted(by: { $0.date > $1.date })
            self.bottomSheet.collectionView.reloadData()
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
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation", for: annotation) as! MKMarkerAnnotationView
        view.annotation = annotation
        view.clusteringIdentifier = "pinCluster" // 클러스터링 가능하게
        
        return view
    }
    
    private func createClusterView(for cluster: MKClusterAnnotation) -> MKAnnotationView {
        let identifier = CustomClusterAnnotationView.identifier
        var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomClusterAnnotationView
        
        if clusterView == nil {
            clusterView = CustomClusterAnnotationView(annotation: cluster, reuseIdentifier: identifier)
        } else {
            clusterView?.annotation = cluster
        }
        
        return clusterView!
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? CustomAnnotation {
            presentPinDetailViewController(selected: annotation.pinData)
        }
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let visibleAnnotations = mapView.annotations(in: mapView.visibleMapRect)
        let visibleMarkers = visibleAnnotations.compactMap { ($0 as? CustomAnnotation)?.pinData }
        
        guard let adapterData = adapter?.data else { return }
        let adapterSet = Set(adapterData.map(\.pin_id))
        let temp = Set(visibleMarkers.map{$0.pin_id}).symmetricDifference(adapterSet).count
        guard temp != 0 else { return }
        
        adapter?.data = visibleMarkers.sorted(by: { $0.date > $1.date })
        bottomSheet.collectionView.reloadData()
    }
}

// MARK: PinCollectionViewAdapterDelegate
extension HomeViewController: PinCollectionViewAdapterDelegate {
    func selectedItem(selected: PinEntity, indexPath: IndexPath) {
        presentPinDetailViewController(selected: selected)
    }
    
    func deletedItem(deleted: PinEntity?, indexPath: IndexPath) {
        guard let deleted = deleted else { return }
        service.deletePin(pinID: deleted.pin_id)
        removePinEntity(pinEntity: deleted)
    }
}

// MARK: 화면이동
extension HomeViewController {
    private func presentAddPinViewController(lat: Double, lon: Double) {
        let vc = PinEditViewController(pinMode: .create(latitude: lat, longitude: lon))
        vc.modalPresentationStyle = .fullScreen
        vc.isAdded = { pin in
            let newAnnotation = CustomAnnotation(pinData: pin)
            self.service.addPin(pin: pin)
            self.mapView.addAnnotation(newAnnotation)
            self.mapView(self.mapView, regionDidChangeAnimated: true)
        }
        present(vc, animated: true)
    }
    private func presentPinDetailViewController(selected: PinEntity) {
        let vc = PinDetailViewController(selected, isPin: true)
        vc.deletePinNoti = removePinEntity
        vc.updatePinNoti = { before, after in
            self.removePinEntity(pinEntity: before)
            let newAnnotation = CustomAnnotation(pinData: after)
            self.mapView.addAnnotation(newAnnotation)
            self.mapView(self.mapView, regionDidChangeAnimated: true)
        }
        present(vc, animated: true)
    }
    
    private func removePinEntity(pinEntity: PinEntity) { // 클로저용..
        if let annotationToRemove = mapView.annotations.first(
            where: { guard let custom = $0 as? CustomAnnotation else { return false }
                return custom.pinData.pin_id == pinEntity.pin_id
            })
        {
            mapView.removeAnnotation(annotationToRemove)
        }
        mapView(mapView, regionDidChangeAnimated: true)
        adapter?.data = adapter?.data.filter{$0.pin_id != pinEntity.pin_id} ?? []
        bottomSheet.collectionView.reloadData()
    }
}

// MARK: @objc event callback function
extension HomeViewController {
    @objc private func moveToAddPin() {
        // 유저 현재위치 못받아오면 권한 설정을 안한거니까 알럿띄움
        guard let location = locationmanager.getCurrentUserLocation() else {
            showAlertAboutLocation()
            return
        }
        presentAddPinViewController(lat: location.latitude, lon: location.longitude)
    }
    
    @objc private func moveToUserLocation() {
        guard let location = locationmanager.getCurrentUserLocation() else {
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
                bottomSheet.collectionView.isUserInteractionEnabled = true
            }

            else if newHeight > (view.frame.height * 0.25) {
#warning("0.3 -> 0.25")
                bottomSheetHeight = medium
                bottomSheet.collectionView.isUserInteractionEnabled = true
            }
            else {
                bottomSheetHeight = small
                bottomSheet.collectionView.isUserInteractionEnabled = false
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
    HomeViewController(service: DIContainer.service)
}
