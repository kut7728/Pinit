//
//  ProductEntity.swift
//  Pinit
//
//  Created by InTak Han on 3/17/25.
//
import UIKit

struct ProducerEntity {
    //이름, 위,경도(지역), 생일, 각자사진, 소개, 문구, 기분(날씨)
    let name: String
    let latitude: Double
    let longitude: Double
    let date: Date
    let mediaPath: String
    let description: String?
    let weather: String
    
    static let sampleData: [ProducerEntity] = [
        //데이터 부분들
        
        ProducerEntity(
            name: "JustHm",
            latitude: 37.401848,
            longitude: 126.922736, //본인 지역의 의,경도
            date: Date(), //생년월일
            mediaPath: "JustHmImg",
            description: "나는 누구 입니다1",
            weather: "구름"),
        
        ProducerEntity(
            name: "Ikhwan0204",
            latitude: 37.502058,
            longitude: 126.672010, //본인 지역의 의,경도
            date: Date(), //생년월일
            mediaPath: "Ikhwan0204Img",
            description: "나는 누구 입니다2",
            weather: "흐림"),
        
        ProducerEntity(
            name: "IntakHan304",
            latitude: 37.557385,
            longitude: 126.956276, //본인 지역의 의,경도
            date: Date(), //생년월일
            mediaPath: "IntakHan304Img",
            description: "나는 누구 입니다3",
            weather: "비"),
        
        ProducerEntity(
            name: "HISEHOONAN",
            latitude: 38.078549,
            longitude: 128.616008, //본인 지역의 의,경도
            date: Date(), //생년월일
            mediaPath: "HISEHOONANImg" ,
            description: "나는 누구 입니다4",
            weather: "눈"),
        
        ProducerEntity(
            name: "kut7728",
            latitude: 37.484679,
            longitude: 126.897968, //본인 지역의 의,경도
            date: Date(), //생년월일
            mediaPath: "kut7728Img" ,
            description: "나는 누구 입니다5",
            weather: "맑음")
    ]
}
