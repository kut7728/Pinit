//
//  PinDetailViewController.swift
//  Pinit
//
//  Created by 안정흠 on 3/12/25.
//


import UIKit
import SnapKit
import MapKit


// MARK: - Pin Detail Main ViewController
final class PinDetailViewController: UIViewController {
    
    private var pinTableView = UITableView(frame: .zero, style: .grouped)
    private var pinEntity: PinEntity
    private var isPin: Bool
    private var useCase = DIContainer.usecase
    var deletePinNoti: ((PinEntity) -> Void)?
    var updatePinNoti: ((_ before: PinEntity, _ after: PinEntity) -> Void)?
    
    init(_ entity: PinEntity, isPin: Bool) {
        self.pinEntity = entity
        self.isPin = isPin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 더미 리뷰 데이터
    private lazy var datasource: [ReviewEntity] = [
        ReviewEntity(id: UUID(), pinID: UUID(), date: Date(), description: "리뷰1"),
        ReviewEntity(id: UUID(), pinID: UUID(), date: Date(), description: "리뷰2"),
        ReviewEntity(id: UUID(), pinID: UUID(), date: Date(), description: "리뷰3")
    ]
    
    
    // MARK: - VIewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupReviewTable()
        addComponents()
        loadReviewData()
        setUpKeyboard()
        
        reviewPanelContainer.commitButton.addTarget(self, action: #selector(onCommitButtonTapped), for: .touchUpInside)
    }
    
    private func setUpKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func loadReviewData() {
        self.useCase.fetchAllReviewsByPinID(pinID: self.pinEntity.pin_id) {[weak self] items in
            self?.datasource = items
            self?.pinTableView.reloadData()
        }
    }
    
    // MARK: - View
    // 지도 뷰
    public lazy var mapView: MKMapView = {
        let map = MKMapView()
        let lat = pinEntity.latitude
        let long = pinEntity.longitude
        
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        
        map.setRegion(region, animated: true)
        map.showsUserLocation = false
        map.isUserInteractionEnabled = false
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        annotation.title = pinEntity.title
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
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)

        return button
    }()
    
    // 리뷰 테이블뷰 설정
    private func setupReviewTable() {
//        pinTableView = UITableView(frame: .zero, style: .grouped)
        pinTableView.estimatedRowHeight = UITableView.automaticDimension
        pinTableView.dataSource = self
        pinTableView.delegate = self
        pinTableView.register(ReviewCell.self, forCellReuseIdentifier: "CustomCell")
        
    }
    
    
    // 리뷰 작성 패널
    public lazy var reviewPanelContainer: NewPinReviewPanel = {
        let view = NewPinReviewPanel()
        return view
    }()
    
    // MARK: - Layout
    private func addComponents() {
        view.addSubviews(mapView,
                         dismissButton,
                         pinTableView,
                         reviewPanelContainer
        )
        
        // 지도 constraint
        mapView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)  // 기기의 안전구역부터 시작하도록
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.25)  // 기기의 높이 *0.25로 높이 설정
        }
        
        // 탈출버튼 constraint
        dismissButton.snp.makeConstraints {
            $0.height.width.equalTo(40)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(5)
            $0.trailing.equalToSuperview().inset(5)
        }
        
        // 리뷰 패널 constraint
        reviewPanelContainer.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        
        pinTableView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalTo(mapView.snp.bottom)
            $0.bottom.equalTo(reviewPanelContainer.snp.top)
        }
    }
}



// MARK: - objc function
extension PinDetailViewController {
    
    @objc func dismissButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onCommitButtonTapped() {
        let review: ReviewEntity = ReviewEntity(
            id: UUID(),
            pinID: pinEntity.pin_id,
            date: Date(),
            description: reviewPanelContainer.reviewText.text ?? ""
        )
        
        reviewPanelContainer.reviewText.text = ""
        
        useCase.addReview(review: review)
        self.datasource.append(review)
        
        self.pinTableView.reloadData()
    }
    
    @objc func doneBtnClicked() {
        view.endEditing(true)
    }
    
    //MARK: 키보드가 나타낼때 화면을 -300
    @objc func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y = -200
    }
    
    //MARK: 키보드가 사라질 때 동작
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    @objc func pinMenuButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "수정", style: .default) { _ in
            print("수정")
            let vc = PinEditViewController(pinMode: .edit(PinEntity: self.pinEntity))
            vc.isAdded = { pin in
                self.useCase.updatePin(pin: pin)
                self.updatePinNoti!(self.pinEntity, pin)
                self.pinEntity = pin
                self.pinTableView.reloadData()
            }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            print("삭제")
            self.useCase.deletePin(pinID: (self.pinEntity.pin_id))
            self.deletePinNoti?(self.pinEntity)
            self.dismiss(animated: true){
                self.showToast(message: "삭제가 완료되었습니다.")
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
}



// MARK: - Delegate
extension PinDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    // viewForHeaderInSection
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = PinDetailHeader(entity: pinEntity)
        if !isPin {
            header.pinMenuButton.isHidden = true
            header.reviewSectionTitle.text = "방명록"
        }
        header.pinMenuButton.addTarget(self, action: #selector(pinMenuButtonTapped), for: .touchUpInside)
        return header
    }
    
    
    
    // estimatedHeightForHeaderInSection
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    // heightForHeaderInSection
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // swipeAction
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completion in
            if let deleted = self?.datasource.remove(at: indexPath.row).id {
                self?.useCase.deleteReview(reviewId: deleted)
                self?.pinTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data: ReviewEntity = datasource[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! ReviewCell
        
        // 셀 재사용을 위한 찌꺼기 제거 절차
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        
        cell.configure(date: data.date.koreanDateString(), desc: data.description)
        return cell
        
    }
    
    
}


#Preview {
    PinDetailViewController(PinEntity.sampleData[1], isPin: true)
}
