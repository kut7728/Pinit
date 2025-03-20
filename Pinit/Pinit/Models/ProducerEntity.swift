//
//  ProductEntity.swift
//  Pinit
//
//  Created by InTak Han on 3/17/25.
//
import UIKit

extension PinEntity {
    
    private static func toDate(_ dateString: String)-> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current // 현재 시간대 사용
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국 로캘 설정 (선택사항)
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        }else{
            return Date()
        }
    }
    
    
    static let producerData: [PinEntity] = [
        //데이터 부분들
        
        PinEntity(
            pin_id: UUID(),
            title: "JustHm",
            latitude: 37.9244577,
            longitude: 128.800009,//본인 지역의 의,경도
            address: "",
            date: toDate("1998-05-01"), //생년월일
            weather: "istj",
            description: "안녕하세요 ! 감자 개발자 안정흠입니다!",
            mediaPath: UIImage(named: "JustHMImg")!
        ),
        
        PinEntity(
            pin_id: UUID(),
            title: "Ikhwan0204",
            latitude: 37.506610,
            longitude: 126.885332,
            address: "",
            date: toDate("2002-04-12"),
            weather: "enfj",
            description: "개발개바발 개발자 이규현입니다.ㅎㅎㅎ",
            mediaPath: UIImage(named: "Ikhwan0204Img")!
            ),
        
        PinEntity(
            pin_id: UUID(),
            title: "IntakHan304",
            latitude: 37.434981,
            longitude: 126.902328,
            address: "",
            date: toDate("1991-03-04"),
            weather: "infj" ,
            description: "처음 시작하는 개발자 한인탁 입니다.",
            mediaPath: UIImage(named: "IntakHan304Img")!
            ),
        
        PinEntity(
            pin_id: UUID(),
            title: "HISEHOONAN",
            latitude: 37.508645,
            longitude: 126.703513,
            address: "",
            date: toDate("1999.06.17"),
            weather: "infp",
            description: "안녕하세요 ! 개발새발 개발자 안세훈입니다 ! ",
            mediaPath: UIImage(named: "HISEHOONImg")!
        ),
        
        PinEntity(
            pin_id: UUID(),
            title: "kut7728",
            latitude: 37.554267,
            longitude: 126.953922, //본인 지역의 의,경도
            address: "",
            date: toDate("1998.03.02"), //생년월일
            weather: "intj",
            description: "네이티브 앱, 애플, 테크기기에 관심이 많은 앱 개발자(지망)입니다.", //
            mediaPath: UIImage(named: "kut7728Img")!
        )
    ]
}
