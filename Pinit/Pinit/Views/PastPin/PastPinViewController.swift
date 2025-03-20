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
    let pinData = PinEntity.sampleData
    private let usecase: UseCase
    
    //MARK: - calendar
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
        view.backgroundColor = .secondarySystemBackground
        SetUI()
        setupAdapter()
        calendarUI()
    }
    
    //MARK: - init
    init(usecase: UseCase) {
        self.usecase = usecase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUI
    private func SetUI() {
        PinCalendar.delegate = self
        PinCalendar.dataSource = self
        
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
    
    private func calendarUI(){
        PinCalendar.backgroundColor = .white
        PinCalendar.layer.cornerRadius = 10
        PinCalendar.locale = Locale.init(identifier: "ko_KR")
        PinCalendar.firstWeekday = 1
        PinCalendar.appearance.headerDateFormat = "YYYY년 MM월"
        PinCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        PinCalendar.placeholderType = .none
        
        //년월 폰트
        PinCalendar.appearance.headerTitleFont = DesignSystemFont.Pretendard_Bold20.value
        PinCalendar.appearance.headerTitleColor = .black
        //요일 폰트
        PinCalendar.appearance.weekdayFont = DesignSystemFont.Pretendard_Bold12.value
        PinCalendar.appearance.weekdayTextColor = .black
        //날짜 폰트
        PinCalendar.appearance.titleFont = DesignSystemFont.Pretendard_Medium12.value
        //오늘
        PinCalendar.appearance.todayColor = .systemGray3
        //오늘 아님
        PinCalendar.appearance.selectionColor = .systemBlue
    }
}

//MARK: - FsCalendar Extension

extension PastPinViewController : FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        usecase.fetchPinsByDate(date: date) { items in
            self.adapter?.data = items
            self.PinCollectionView.reloadData()
        }
        
    }
    
    //해당 pinEntity안에 데이터의 유무에 따라 해당 날짜에 dot이 노출댑니당>.<
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return pinData.contains { Calendar.current.isDate($0.date, inSameDayAs: date) } ? 1 : 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        
        if Calendar.current.shortWeekdaySymbols[day] == "Sun" || Calendar.current.shortWeekdaySymbols[day] == "일" {
            return .systemRed //일요일 색
        } else if Calendar.current.shortWeekdaySymbols[day] == "Sat" || Calendar.current.shortWeekdaySymbols[day] == "토" {
            return .systemBlue //토요일 색
        } else {
            return .label //기본색
        }
    }
}

//MARK: - extension
extension PastPinViewController : PinCollectionViewAdapterDelegate {
    
    func selectedItem(selected: PinEntity) { //화면 이동
        print("selectedItem")
    }
    
    func deletedItem(deleted: PinEntity?) { //아이템 삭제 클릭시
        print("deletedItem")
    }
    
}


#Preview {
    PastPinViewController(usecase: DIContainer.usecase)
}

