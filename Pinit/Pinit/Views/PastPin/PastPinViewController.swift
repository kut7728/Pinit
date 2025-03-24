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
    
    //MARK: - 모든 PinEntity를 가져옵니다.
    var pinData: [PinEntity] = []
    
    private let service: Service
    
    //MARK: - properties
    private let PinCalendar : FSCalendar = {
        let calendar = FSCalendar()
        return calendar
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
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .secondarySystemBackground
        SetUI()
        setupAdapter()
        calendarUI()
        service.fetchPinsByDate(date: Date()) { items in
            self.adapter?.data = items
            self.PinCollectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        service.fetchPinsByDate(date: Date()) { items in
            self.adapter?.data = items
            self.PinCollectionView.reloadData()
        }
    }
    
    //MARK: - init
    init(service: Service) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUI
    private func SetUI() {
        view.addSubviews(PinCalendar,PinCollectionView)
        
        PinCalendar.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(300)
        }
        PinCollectionView.snp.makeConstraints{
            $0.top.equalTo(PinCalendar.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: - 캘린더 세팅ㅇㅇ

    private func calendarUI(){
        PinCalendar.delegate = self
        PinCalendar.dataSource = self
        
        PinCalendar.backgroundColor = .white
        PinCalendar.layer.cornerRadius = 10
        PinCalendar.layer.borderColor = DesignSystemColor.Lavender10.value.cgColor
        PinCalendar.layer.borderWidth = 2
        PinCalendar.locale = Locale.init(identifier: "ko_KR")
        PinCalendar.firstWeekday = 1
        PinCalendar.appearance.headerDateFormat = "YYYY년 MM월"
        PinCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        PinCalendar.placeholderType = .none
        
        //년월 폰트
        PinCalendar.appearance.headerTitleFont = DesignSystemFont.Pretendard_Bold20.value
        PinCalendar.appearance.headerTitleColor = DesignSystemColor.Purple.value
        //요일 폰트
        PinCalendar.appearance.weekdayFont = DesignSystemFont.Pretendard_Medium16.value
        PinCalendar.appearance.weekdayTextColor = .black
        //날짜 폰트
        PinCalendar.appearance.titleFont = DesignSystemFont.Pretendard_Medium14.value
        //오늘
        PinCalendar.appearance.todayColor = DesignSystemColor.Lavender10.value
        PinCalendar.appearance.todaySelectionColor = DesignSystemColor.Purple50.value

        //오늘 아님
        PinCalendar.appearance.selectionColor = DesignSystemColor.Purple50.value
    }
}

//MARK: - FsCalendar Extension

extension PastPinViewController : FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        service.fetchPinsByDate(date: date) { items in
            self.adapter?.data = items
            self.PinCollectionView.reloadData()
        }
        
    }
    
//    //해당 pinEntity안에 데이터의 유무에 따라 해당 날짜에 dot이 노출댑니당>.<
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        return pinData.contains { Calendar.current.isDate($0.date, inSameDayAs: date) } ? 1 : 0
//    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        
        if Calendar.current.shortWeekdaySymbols[day] == "Sun" || Calendar.current.shortWeekdaySymbols[day] == "일" {
            return .systemRed //일요일 색
        } else if Calendar.current.shortWeekdaySymbols[day] == "Sat" || Calendar.current.shortWeekdaySymbols[day] == "토" {
            return DesignSystemColor.Purple.value //토요일 색
        } else {
            return .label //기본색
        }
    }
}

//MARK: - extension
extension PastPinViewController : PinCollectionViewAdapterDelegate {
    
    func selectedItem(selected: PinEntity, indexPath: IndexPath) { //화면 이동
        let vc = PinDetailViewController(selected, isPin: true)
        vc.deletePinNoti = { pin in
            self.adapter?.data.remove(at: indexPath.row)
            self.PinCollectionView.reloadData()
        }
        vc.updatePinNoti = { before, after in
            self.adapter?.data[indexPath.row] = after
            self.PinCollectionView.reloadData()
        }
        present(vc, animated: true)
    }
    
    func deletedItem(deleted: PinEntity?, indexPath: IndexPath) { //아이템 삭제 클릭시
        guard let deleted = deleted else { return }
        service.deletePin(pinID: deleted.pin_id)
        self.pinData = pinData.filter{ $0.pin_id != deleted.pin_id }
    }
    
}


#Preview {
    PastPinViewController(service: DIContainer.service)
}

