//
//  DesignSystem.swift
//  Pinit
//
//  Created by 안세훈 on 3/12/25.
//

import UIKit

enum DesignSystemColor {
    case Purple
    case Purple50
    case Lavender
    case Lavender10
    case Lavender1
}
extension DesignSystemColor {
    var value: UIColor {
        switch self {
        case .Purple:
            UIColor(hex: "#561CE2")
        case .Purple50:
            UIColor(hex: "#8562D5")
        case .Lavender:
            UIColor(hex: "#6450E2")
        case .Lavender10:
            UIColor(hex: "#C2BFD2")
        case .Lavender1:
            UIColor(hex: "#CECCCF")
            
        }
    }
}

enum DesignSystemFont {
    case Pretendard_Bold8
    case Pretendard_Bold12
    case Pretendard_Bold20
    case Pretendard_Bold14
    case Pretendard_Bold16
    case Pretendard_Bold70
    case Pretendard_SemiBold10
    case Pretendard_SemiBold12
    case Pretendard_SemiBold14
    case Pretendard_SemiBold16
    case Pretendard_Medium12
    case Pretendard_Medium14
    case Pretendard_Medium16
    case Pretendard_Medium18
    case Pretendard_Bold30
    case Pretendard_Bold18
}

extension DesignSystemFont {
    var value: UIFont {
        switch self {
        case .Pretendard_Bold8:
            return UIFont.pretendard(.bold, size: 8)
        case .Pretendard_Bold12:
            return UIFont.pretendard(.bold, size: 12)
        case .Pretendard_Bold20:
            return UIFont.pretendard(.bold, size: 20)
        case .Pretendard_Bold14:
            return UIFont.pretendard(.bold, size: 14)
        case .Pretendard_Bold70:
            return UIFont.pretendard(.bold, size: 70)
        case .Pretendard_SemiBold10:
            return UIFont.pretendard(.semiBold, size: 10)
        case .Pretendard_SemiBold12:
            return UIFont.pretendard(.semiBold, size: 12)
        case . Pretendard_SemiBold16:
            return UIFont.pretendard(.semiBold, size: 16)
        case .Pretendard_Medium12:
            return UIFont.pretendard(.medium, size: 12)
        case .Pretendard_Medium14:
            return UIFont.pretendard(.medium, size: 14)
        case . Pretendard_Medium16:
            return UIFont.pretendard(.medium, size: 16)
        case .Pretendard_Medium18:
            return UIFont.pretendard(.medium, size: 18)
        case .Pretendard_Bold30:
            return UIFont.pretendard(.bold, size: 30)
        case .Pretendard_Bold18:
            return UIFont.pretendard(.bold, size: 18)
        case .Pretendard_Bold16:
            return UIFont.pretendard(.bold, size: 16)
        case .Pretendard_SemiBold14:
            return UIFont.pretendard(.semiBold, size: 14)
        }
    }
    
}


