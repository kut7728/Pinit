//
//  PinDetailViewController.swift
//  Pinit
//
//  Created by 안정흠 on 3/12/25.
//


import UIKit
import SnapKit
import MapKit

// MARK: - Pin Detail Main View Controller
final class PinDetailViewController: UIViewController {
    
    // 더미 리뷰 데이터
    private lazy var datasource: [ReviewEntity] = [
        ReviewEntity(id: UUID(), pinID: UUID(), date: Date(), description: "리뷰1"),
        ReviewEntity(id: UUID(), pinID: UUID(), date: Date(), description: "리뷰2"),
        ReviewEntity(id: UUID(), pinID: UUID(), date: Date(), description: "리뷰3")
    ]
    
    public var pinTableView: UITableView!
    
    // MARK: - VIewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupReviewTable()
        addComponents()
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
    
    // 리뷰 테이블뷰 설정
    private func setupReviewTable() {
        pinTableView = UITableView()
        pinTableView.estimatedRowHeight = UITableView.automaticDimension
        pinTableView.dataSource = self
        pinTableView.delegate = self
        pinTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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

// MARK: - Delegate
extension PinDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // swipeAction
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completion in
            if let deleted = self?.datasource.remove(at: indexPath.row).id {
                //                self?.coreData.deleteContent(id: deleted)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let label = UILabel(frame: cell.contentView.bounds)
        label.text = datasource[indexPath.row].description
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8)
        ])
        
        return cell
        
    }
    
    // viewForHeaderInSection
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return PinDetailHeader()
    }
    
    // estimatedHeightForHeaderInSection
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 1000
    }
    
    // heightForHeaderInSection
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


#Preview {
    PinDetailViewController()
}
