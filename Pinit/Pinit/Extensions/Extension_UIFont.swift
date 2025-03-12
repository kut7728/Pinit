//
//  Extension_UIFont.swift
//  Pinit
//
//  Created by 안세훈 on 3/12/25.
//

import Foundation
import UIKit

//MARK: - 폰트 조절
extension UIFont {
    
    enum Pretendard {
        case bold
        case extraBold
        case medium
        case semiBold
        case regular
        
        var value: String {
            switch self {
            case .bold:
                return "Pretendard-Bold"
            case .medium:
                return "Pretendard-Medium"
            case .semiBold:
                return "Pretendard-SemiBold"
            case .extraBold:
                return "Pretendard-ExtraBold"
            case .regular:
                return "Pretendard-Regular"
            }
        }
    }
    
    static func pretendard(_ type: Pretendard, size: CGFloat) -> UIFont {
        return UIFont(name: type.value, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

