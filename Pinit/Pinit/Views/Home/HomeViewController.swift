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
    private var bottomSheetHeightConstraint: Constraint!

    
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
        // 높이 조절을 위한 제약 설정
        bottomSheet.snp.makeConstraints {
            let initialHeight = view.frame.height / 6
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            bottomSheetHeightConstraint = $0.height.equalTo(initialHeight).constraint
        }
        // 높이 변경
        bottomSheetHeightConstraint.update(offset: 500)
        
        // 패닝 제스처
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))
//        bottomSheet.grabber.addGestureRecognizer(panGesture)
        bottomSheet.addGestureRecognizer(panGesture)
    }
}

extension HomeViewController {
    @objc private func panGestureHandler(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        // 기본값 설정
        var newHeight = view.frame.height / 6
        if let height = bottomSheetHeightConstraint.layoutConstraints.first(
            where: { $0.firstAttribute == .height && $0.secondAttribute == .height })?.constant
        {
            newHeight = height - translation.y
            gesture.setTranslation(.zero, in: view)
        }
        
        if gesture.state == .ended {
            // 높이 조정 pretend?
            if newHeight > (view.frame.height / 2) {
                newHeight = view.frame.height * 0.8
            }
            else {
                newHeight = view.frame.height / 6
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.bottomSheetHeightConstraint.update(offset: newHeight)
            self.bottomSheet.layoutIfNeeded()
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
