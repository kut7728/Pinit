//
//  ProductEntity.swift
//  Pinit
//
//  Created by InTak Han on 3/17/25.
//
import UIKit

struct ProducerEntity {
    //이름, 위,경도(지역), 생일, 각자사진, 소개, 문구, 기분(날씨)
    let title: String
    let latitude: Double
    let longitude: Double
    let date: String
    let mediaPath: UIImage
    let description: String?
    let weather: String
    
    
    static let sampleData: [ProducerEntity] = [
        //데이터 부분들
        
        ProducerEntity(
            title: "JustHm",
            latitude: 37.9244577,
            longitude: 128.800009, //본인 지역의 의,경도
            date: "1998-05-01", //생년월일
            mediaPath: UIImage(named: "JustHMImg")!,
            description: "안녕하세요 ! 감자 개발자 안정흠입니다!",//istj
            weather: "구름"),
        
        ProducerEntity(
            title: "Ikhwan0204",
            latitude: 37.506610,
            longitude: 126.885332, //본인 지역의 의,경도
            date: "2002-04-12", //생년월일
            mediaPath: UIImage(named: "Ikhwan0204Img")!,
            description: "개발개바발 개발자 이규현입니다.ㅎㅎㅎ", //enfj
            weather: "흐림"),
        
        ProducerEntity(
            title: "IntakHan304",
            latitude: 37.434981,
            longitude: 126.902328, //본인 지역의 의,경도
            date: "1991-03-04", //생년월일
            mediaPath: UIImage(named: "IntakHan304Img")!,
            description: "나는 누구 입니다3",
            weather: "비"),
        
        ProducerEntity(
            title: "HISEHOONAN",
            latitude: 37.508645,
            longitude: 126.703513, //본인 지역의 의,경도
            date: "1998.06.17", //생년월일
            mediaPath: UIImage(named: "HISEHOONImg")! ,
            description: "안녕하세요 ! 개발새발 개발자 안세훈입니다 !",//infp
            weather: "눈"),
        
        ProducerEntity(
            title: "kut7728",
            latitude: 37.554267,
            longitude: 126.953922, //본인 지역의 의,경도
            date: "1998.03.02", //생년월일
            mediaPath: UIImage(named: "kut7728Img")! ,
            description: "네이티브 앱, 애플, 테크기기에 관심이 많은 앱 개발자(지망)입니다.", //infj
            weather: "맑음")
    ]
}
