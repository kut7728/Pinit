//
//  Extension_UIViewController.swift
//  Pinit
//
//  Created by 안정흠 on 3/18/25.
//

import Foundation
import UIKit
import SnapKit

extension UIViewController {
    func showAlertAboutLocation() {
        let alert = UIAlertController(title: "위치 서비스 권한 필요",
                                      message: "위치 서비스를 허용해야지 사용할 수 있는 앱입니다.\n설정에서 위치권한을 켜주세요",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "설정", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }

    func showToast(message: String) {
        // 최상단 window를 가져오기 (앱 전체에서 최상위 window에 토스트 표시)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }

        // 상호작용 차단을 위한 투명한 배경 뷰
        let blockingView = UIView()
        blockingView.backgroundColor = UIColor.clear
        keyWindow.addSubview(blockingView)

        // Container view for the toast
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        containerView.layer.cornerRadius = 4
        containerView.clipsToBounds = true
        blockingView.addSubview(containerView)

        // Toast message label
        let toastLabel = UILabel()
        toastLabel.textColor = UIColor.white
        toastLabel.font = DesignSystemFont.Pretendard_Medium14.value
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        containerView.addSubview(toastLabel)

        blockingView.snp.makeConstraints {
            $0.edges.equalToSuperview() // 화면 전체를 덮음
        }

        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        toastLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }

        //MARK: - 사라지는거 설정ㅇㅇ
        UIView.animate(withDuration: 1.3, delay: 0.8, options: .curveEaseOut, animations: {
            containerView.alpha = 0.0
        }, completion: { _ in
            blockingView.removeFromSuperview() // 상호작용을 차단한 뷰 및 토스트를 제거
        })
    }
}
