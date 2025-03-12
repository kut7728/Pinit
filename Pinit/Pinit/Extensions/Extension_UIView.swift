//
//  Extension_UIView.swift
//  Pinit
//
//  Created by 안세훈 on 3/12/25.
//

import Foundation
import UIKit

//MARK: - 뷰 갯수 많이 한번에 칰칰칰~

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
