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
    
    private var adapter: PinCollectionViewAdapter?
    
    private let bottomSheet = CustomBottomSheet()
    private let Label : UILabel = {
        let label = UILabel()
        label.text = "한글 123 #%^#$"
        label.font = DesignSystemFont.Pretendard_Bold70.value
        return label
    }()
    // BottomSheet 동적 높이를 저장하기위한 변수
    private var bottomSheetHeightConstraint: CGFloat = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        view.addSubviews(Label, bottomSheet)
        
        adapter = PinCollectionViewAdapter(
            collectionView: bottomSheet.collectionView,
            width: view.frame.width
        )
        adapter?.delegate = self
        
        Label.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        setupBottomSheet()
    }
    
    func setupBottomSheet() {
        bottomSheet.snp.makeConstraints {
            bottomSheetHeightConstraint = view.frame.height / 14
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(bottomSheetHeightConstraint)
        }
        
        // 패닝 제스처
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))
        bottomSheet.addGestureRecognizer(panGesture)
    }
}

extension HomeViewController {
    @objc private func panGestureHandler(_ gesture: UIPanGestureRecognizer) {
        // Pretend 크기 설정
        let small = view.frame.height / 14
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
            if newHeight > (view.frame.height / 2) {
                bottomSheetHeightConstraint = large
            }
            else {
                bottomSheetHeightConstraint = small
            }
        }
        // Constraint 업데이트 + Animation
        UIView.animate(withDuration: 0.2) {
            self.bottomSheet.snp.updateConstraints {
                $0.height.equalTo(self.bottomSheetHeightConstraint)
            }
            self.view.layoutIfNeeded()
        }
    }
}

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


#Preview{
    HomeViewController()
}
