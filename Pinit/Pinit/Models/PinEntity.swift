//
//  PinEntity.swift
//  Pinit
//
//  Created by 안정흠 on 3/12/25.
//

import UIKit

struct OldPinEntity {
    let pin_id: UUID
    let latitude: Double
    let longitude: Double
    let address: String
    let date: String
    let weather: String
    let mediaPath: String?
    let description: String?
    
    
}

struct PinEntity {
    let pin_id: UUID
    let title: String
    let latitude: Double
    let longitude: Double
    let address: String
    let date: String
    let weather: String
    let description: String
    let mediaPath: UIImage?
    
    static let sampleData: [PinEntity] = [
            PinEntity(pin_id: UUID(uuidString: "b44a6eaf-a5f8-426c-8200-0cf93a18c2ca")!,
                      title: "샘플 핀 1",
                      latitude: 37.56100504013702,
                      longitude: 126.97628375547349,
                      address: "서울특별시 도로명주소 24번지",
                      date: "2024-12-11T16:21:14.472293",
                      weather: "비",
                      description: "샘플 설명 83",
                      mediaPath: nil),  // 이미지 없음
            
            PinEntity(pin_id: UUID(uuidString: "d2c3ae95-5261-47e1-ab6f-ad71c00aadf7")!,
                      title: "샘플 핀 2",
                      latitude: 37.56765588123195,
                      longitude: 126.98134546666795,
                      address: "서울특별시 도로명주소 51번지",
                      date: "2024-06-28T16:21:14.472520",
                      weather: "눈",
                      description: "샘플 설명 67",
                      mediaPath: nil),  // 이미지 변환
            
            PinEntity(pin_id: UUID(uuidString: "44eaec4e-a87a-4947-9670-fa350124bd12")!,
                      title: "샘플 핀 3",
                      latitude: 37.568960833887765,
                      longitude: 126.97047797779446,
                      address: "서울특별시 도로명주소 1번지",
                      date: "2025-03-01T16:21:14.472791",
                      weather: "비",
                      description: "샘플 설명 36",
                      mediaPath: nil)  // 이미지 없음
        ]
}
