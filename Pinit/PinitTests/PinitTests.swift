//
//  PinitTests.swift
//  PinitTests
//
//  Created by 안정흠 on 3/18/25.
//

import XCTest
import CoreData
import Moya
import Kingfisher
@testable import Pinit

final class PinitTests: XCTestCase {
    var service: Service!
    var context: NSManagedObjectContext!
    var imageStore: ImageStoreRepository!
    var moya: MoyaProvider<Router>!
    
    override func setUpWithError() throws {
        let container = NSPersistentContainer(name: "Pinit")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType // 임시 메모리에 저장되게함.
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { storeDescription, error in
            XCTAssertNil(error, "CoreData In-Memory Store 생성 실패")
        }
        context = container.newBackgroundContext()
        
        let tempDIR = URL(fileURLWithPath: NSTemporaryDirectory())
        imageStore = ImageStoreRepositoryImpl(fileManagerURL: tempDIR) // 임시 메모리에 사진 저장되게함.
        
        moya = MoyaProvider<Router>()
        
        service = ServiceImpl(
            dbRepository: DBRepositoryImpl(context: context),
            imageStore: imageStore,
            moyaProvider: moya
        )
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        context = nil
        service = nil
    }
    
    func test_샘플데이터로_핀추가_확인() throws {
        // Given
        let pins = PinEntity.sampleData
        // When
        for pin in pins {
            // Then
            XCTAssertTrue(service.addPin(pin: pin), "Pin 추가 실패")
        }
        do {
            let request = PinDTO.fetchRequest()
            let fetchResult = try context.fetch(request)
            XCTAssertEqual(fetchResult.count, PinEntity.sampleData.count, "추가된 Pin 개수 다름")
        }
        catch {
            XCTFail("Fetch 실패: \(error.localizedDescription)")
        }
    }
    
    func test_핀_전부가져오기() {
        // Given
        for sample in PinEntity.sampleData {
            XCTAssertTrue(service.addPin(pin: sample), "Pin 추가 실패")
        }
        
        // When
        var pins: [PinEntity] = []
        service.fetchAllPins { items in
            pins = items
            
            // Then
            XCTAssertEqual(pins.count, PinEntity.sampleData.count, "Pin 개수 다름")
            for i in 0..<pins.count { //저장 순서 보장 되나봄
                XCTAssertEqual(pins[i], PinEntity.sampleData[i], "Pin 데이터가 다름!!")
            }
        }
    }
    
    func test_날씨정보_가져오기() {
        let latitude = PinEntity.sampleData[1].latitude
        let longitude = PinEntity.sampleData[1].longitude
        
        // 비동기 expectation 생성
        let expectation = XCTestExpectation(description: "날씨 정보를 성공적으로 가져와야함.")
        
        // 네트워크 레이어 호출
        service.fetchCurrentWeather(latitude: latitude, longitude: longitude) { weatherData in
            
            XCTAssertNotNil(weatherData, "날씨 데이터가 nil이면 실패")
            
            if let weatherData = weatherData {
                print(#file,#function,#line,weatherData)
            }
            
            expectation.fulfill() // 비동기 작업이 완료되었음을 알림
        }
        //5초 안에 expectation 실행
        wait(for: [expectation], timeout: 5.0)
    }
    
}


// 테스트용 equatable
extension PinEntity: Equatable {
    public static func == (lhs: PinEntity, rhs: PinEntity) -> Bool {
        return (
            lhs.pin_id == rhs.pin_id &&
            lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude &&
            lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.mediaPath == rhs.mediaPath &&
            lhs.date == rhs.date &&
            lhs.address == rhs.address &&
            lhs.weather == rhs.weather
        )
    }
    
    
}
