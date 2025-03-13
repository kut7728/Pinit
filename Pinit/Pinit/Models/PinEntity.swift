//
//  PinEntity.swift
//  Pinit
//
//  Created by 안정흠 on 3/12/25.
//

import UIKit

struct PinEntity {
    let pin_id: UUID
    let latitude: Double
    let longitude: Double
    let address: String
    let date: String
    let weather: String
    let mediaPath: String?
    let description: String?
    
    // JSON 데이터를 배열로 변환
    static let sampleData: [PinEntity] = [
        PinEntity(pin_id: UUID(uuidString: "b44a6eaf-a5f8-426c-8200-0cf93a18c2ca")!,
                  latitude: 37.56100504013702,
                  longitude: 126.97628375547349,
                  address: "서울특별시 도로명주소 24번지",
                  date: "2024-12-11T16:21:14.472293",
                  weather: "비",
                  mediaPath: nil,
                  description: "샘플 설명 83"),
        
        PinEntity(pin_id: UUID(uuidString: "68dd4f80-95ea-46a5-a632-9a4a069e1b7a")!,
                  latitude: 37.56877952814179,
                  longitude: 126.98456754049919,
                  address: "서울특별시 도로명주소 30번지",
                  date: "2024-12-15T16:21:14.472468",
                  weather: "비",
                  mediaPath: nil,
                  description: "샘플 설명 93"),
        
        PinEntity(pin_id: UUID(uuidString: "d2c3ae95-5261-47e1-ab6f-ad71c00aadf7")!,
                  latitude: 37.56765588123195,
                  longitude: 126.98134546666795,
                  address: "서울특별시 도로명주소 51번지",
                  date: "2024-06-28T16:21:14.472520",
                  weather: "눈",
                  mediaPath: "/media/e8d7fc54-d9ec-4d74-8926-7f634356c6f0.jpg",
                  description: "샘플 설명 67"),
        
        PinEntity(pin_id: UUID(uuidString: "433c8bd9-94bd-4871-a33c-33764591ee8d")!,
                  latitude: 37.561084133506085,
                  longitude: 126.97772615998592,
                  address: "서울특별시 도로명주소 12번지",
                  date: "2024-06-09T16:21:14.472578",
                  weather: "비",
                  mediaPath: "/media/a4d505b5-b868-4eb8-b5a4-8ddb8eb7cde1.jpg",
                  description: "샘플 설명 72"),
        
        PinEntity(pin_id: UUID(uuidString: "5170db8b-7e0d-4f1f-b01c-9c3e2403c4a6")!,
                  latitude: 37.56141240706244,
                  longitude: 126.97405621468289,
                  address: "서울특별시 도로명주소 7번지",
                  date: "2024-05-01T16:21:14.472636",
                  weather: "눈",
                  mediaPath: "/media/0ab04e6d-7ad2-4653-9b1e-8ac696a7497b.jpg",
                  description: "샘플 설명 87"),
        
        PinEntity(pin_id: UUID(uuidString: "44eaec4e-a87a-4947-9670-fa350124bd12")!,
                  latitude: 37.568960833887765,
                  longitude: 126.97047797779446,
                  address: "서울특별시 도로명주소 1번지",
                  date: "2025-03-01T16:21:14.472791",
                  weather: "비",
                  mediaPath: nil,
                  description: "샘플 설명 36")
    ]
}

struct renewalPinEntity {
    let pin_id: UUID
    let title: String
    let latitude: Double
    let longitude: Double
    let address: String
    let date: String
    let weather: String
    let description: String
    let mediaPath: UIImage?
}
