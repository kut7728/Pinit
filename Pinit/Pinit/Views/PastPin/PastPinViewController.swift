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
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.firstWeekday = 1
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
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
        //        APItest()
    }
    
    //MARK: - setui
    
    private func SetUI() {
        PinCalendar.delegate = self
        PinCalendar.dataSource = self
        
        view.addSubviews(PinCalendar,PinCollectionView)
        
        PinCalendar.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(370)
        }
        PinCollectionView.snp.makeConstraints{
            $0.top.equalTo(PinCalendar.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: - TEST
    //    private let provider = MoyaProvider<Router>()
    //
    //    func APItest() {
    //        provider.request(.getWeather(lat: 37.56, lon: 126.98, lang: "kr")) { result in
    //            switch result {
    //            case let .success(response):
    //                do {
    //                    let data = try JSONDecoder().decode(WeatherResponse.self, from: response.data)
    //                    print(data)
    //                } catch {
    //                    print("JSON Parsing Error: \(error)")
    //                }
    //            case let .failure(error):
    //                print("Network Request Failed: \(error.localizedDescription)")
    //            }
    //        }
    //    }
}

//MARK: - FsCalendar Extension

extension PastPinViewController : FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("didSelect date: \(date)")
    }
    //    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
    //        return UIImage(systemName: "scribble")
    //    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        
        if Calendar.current.shortWeekdaySymbols[day] == "Sun" || Calendar.current.shortWeekdaySymbols[day] == "일" {
            return .systemRed
        } else if Calendar.current.shortWeekdaySymbols[day] == "Sat" || Calendar.current.shortWeekdaySymbols[day] == "토" {
            return .systemBlue
        } else {
            return .label
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

