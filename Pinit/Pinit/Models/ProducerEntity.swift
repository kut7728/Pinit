//
//  ProductEntity.swift
//  Pinit
//
//  Created by InTak Han on 3/17/25.
//
import UIKit

struct ProducerEntity {
    //위,경도(지역) 생일 각자사진 소개 문구 기분(날씨)
    let latitude: Double
    let longitude: Double
    let date: Date
    let mediaPath: UIImage?
    let description: String?
    let weather: String
    
    static let sampleData: [ProducerEntity] = [
        //데이터 부분들
        ProducerEntity(
            latitude: 37.4191559,
            longitude: 126.9112128, //본인 지역의 의,경도
            date: Date(), //생년월일
            mediaPath: nil,// 이미지 없음
            description: "나는 누구 입니다",
            weather: "구름"),
    ]
}
