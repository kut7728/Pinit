//
//  Extension_Date.swift
//  Pinit
//
//  Created by nelime on 3/18/25.
//
import Foundation

extension Date {
    func koreanDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 (E)"
        dateFormatter.locale = Locale(identifier: "ko-KR")
        return dateFormatter.string(from: self)
    }
    
    func snakeCaseDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd (E)"
        dateFormatter.locale = Locale(identifier: "ko-KR")
        return dateFormatter.string(from: self)
    }
}
