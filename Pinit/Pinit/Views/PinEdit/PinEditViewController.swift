//
//  PinEditViewController.swift
//  Pinit
//
//  Created by 안정흠 on 3/12/25.
//


import UIKit
import FSCalendar
import SnapKit

final class PinEditViewController: UIViewController {
    
    private let PinCalendar : FSCalendar = {
        let calendar = FSCalendar()
        calendar.appearance.selectionColor = .systemBlue
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SeUI()
    }
    
    private func SeUI() {
        view.addSubviews(PinCalendar)
        
        PinCalendar.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(370)
        }
    }
    
    
}

#Preview {
    PinEditViewController()
}
