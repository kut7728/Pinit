//
//  ViewController.swift
//  Pinit
//
//  Created by nelime on 3/10/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let Label : UILabel = {
        let label = UILabel()
        label.text = "한글 123 #%^#$"
        label.font = DesignSystemFont.Pretendard_Bold70.value
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        view.addSubview(Label)
        
        Label.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
}


#Preview{
    ViewController()
}
