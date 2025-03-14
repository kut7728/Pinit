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
    
    // BottomSheet 동적 높이를 저장하기위한 변수
    private lazy var bottomSheetHeightConstraint: CGFloat = view.frame.height / 14
    private let circleButtonSize: CGFloat = 44
    
    private var adapter: PinCollectionViewAdapter?
    private let bottomSheet = CustomBottomSheet()
    private lazy var addPinButton: UIButton = {
        let button = UIButton()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        setupAdapter()
        setupLayout()
    }
    
    private func setupProperties() {
        view.backgroundColor = .gray
        
        // 바텀시트 패닝 제스처 추가
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))
        bottomSheet.addGestureRecognizer(panGesture)
        // 버튼 액션 추가
        addPinButton.addTarget(self, action: #selector(moveToAddPin), for: .touchUpInside)
        currentLocationButton.addTarget(self, action: #selector(moveToUserLocation), for: .touchUpInside)
        
        view.addSubviews(addPinButton, currentLocationButton, bottomSheet)
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
        bottomSheet.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(bottomSheetHeightConstraint)
        }
        addPinButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(bottomSheetHeightConstraint * 2.5)
            $0.size.equalTo(circleButtonSize)
        }
        currentLocationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(addPinButton.snp.top).offset(-10)
            $0.size.equalTo(circleButtonSize)
        }
    }
}

// MARK: PinCollectionViewAdapterDelegate
extension HomeViewController: PinCollectionViewAdapterDelegate {
    func selectedItem(selected: PinEntity) {
        print("Selected: \(selected)")
        // 여기서 화면 이동
    }
    
    func deletedItem(deleted: PinEntity?) {
        print("Deleted: \(deleted)")
        // 여기서 CoreData 업데이트
    }
}

// MARK: @objc event callback function
extension HomeViewController {
    @objc private func moveToAddPin() {
        print("기록하기 화면으로 이동")
    }
    
    @objc private func moveToUserLocation() {
        print("CLLocation에서 유저 화면으로 이동")
    }
    
    @objc private func panGestureHandler(_ gesture: UIPanGestureRecognizer) {
        // Pretend 크기 설정
        let small = view.frame.height / 14
        let medium = view.frame.height * 0.4
        let large = view.frame.height * 0.8
        // 제스처 시작
        let translation = gesture.translation(in: view)
        let newHeight = bottomSheetHeightConstraint - translation.y
        // 제스처 (드래그) 위치에 따라 업데이트
        if newHeight >= small && newHeight <= large {
            bottomSheetHeightConstraint = newHeight
            gesture.setTranslation(.zero, in: view)
        }
        // 제스터 (드래그 끝났을때) 위치에 따라 최종 높이 업데이트
        if gesture.state == .ended {
            // 높이 조정 pretend?
            if newHeight > (view.frame.height * 0.6) {
                bottomSheetHeightConstraint = large
            }
            else if newHeight > (view.frame.height * 0.3) {
                bottomSheetHeightConstraint = medium
            }
            else {
                bottomSheetHeightConstraint = small
            }
        }
        bottomSheet.snp.updateConstraints {
            $0.height.equalTo(self.bottomSheetHeightConstraint)
        }
        // Constraint 업데이트 + Animation
        UIView.animate(withDuration: 0.07) {
            self.view.layoutIfNeeded()
        }
    }
}



#Preview{
    HomeViewController()
}
