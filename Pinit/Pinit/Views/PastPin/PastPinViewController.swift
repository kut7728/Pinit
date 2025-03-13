//
//  PastPinViewController.swift
//  Pinit
//
//  Created by 안정흠 on 3/12/25.
//

import UIKit
import FSCalendar
import SnapKit

final class PastPinViewController: UIViewController {
    
    //MARK: - calendar
    private let PinCalendar : FSCalendar = {
        let calendar = FSCalendar()
        calendar.appearance.selectionColor = .systemBlue
        calendar.backgroundColor = .white
        calendar.layer.cornerRadius = 10
        return calendar
    }()
    
    
    private let bar : UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()

    //MARK: - collectionview
    
    private var adapter: PinCollectionViewAdapter?
    
    private let PinCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        return view
    }()
    
    private func setupAdapter() {
        adapter = PinCollectionViewAdapter(
            collectionView: PinCollectionView,
            width: view.frame.width
        )
        adapter?.delegate = self
        adapter?.data = PinEntity.sampleData
    }
    
    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        SeUI()
        setupAdapter()
        
    }
    
    //MARK: - setui
    
    private func SeUI() {
        view.addSubviews(PinCalendar,bar,PinCollectionView)
        
        PinCalendar.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(370)
        }
        bar.snp.makeConstraints{
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.centerX.equalTo(PinCalendar)
            $0.top.equalTo(PinCalendar.snp.bottom)
        }
        PinCollectionView.snp.makeConstraints{
            $0.top.equalTo(bar.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - extension

extension PastPinViewController : PinCollectionViewAdapterDelegate{
    
    func selectedItem(selected: PinEntity) { //화면 이동
        print("selectedItem")
    }
    
    func deletedItem(deleted: PinEntity?) { //아이템 삭제 클릭시
        print("deletedItem")
    }
}


#Preview {
    PastPinViewController()
}

