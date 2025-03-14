//
//  SettingViewController.swift
//  Pinit
//
//  Created by 안정흠 on 3/12/25.
//


import UIKit

final class SettingViewController: UIViewController {
    private let resetButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        resetButton.setTitle("전체 기록 삭제", for: .normal)
        resetButton.addTarget(self, action: #selector(resetAlert), for: .touchUpInside)
        resetButton.backgroundColor = .lightGray
        
        view.addSubview(resetButton)
        
        resetButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.height.equalTo(50)
            make.leading.equalTo(20)
        }
    }
    
    @objc func resetAlert() {
        let alert = UIAlertController(title: "전체 기록 삭제", message: "모든 핀이 삭제됩니다.\n 진행하시겠습니까?", preferredStyle: .alert)

        let addAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                //저장된 내용이 지워지는 내용
                
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
}
#Preview {
    SettingViewController()
}
