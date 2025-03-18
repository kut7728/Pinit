//
//  UseCase.swift
//  Pinit
//
//  Created by 안정흠 on 3/12/25.
//

import UIKit
import Moya

private let provider = MoyaProvider<Router>()

protocol UseCase {
    func addPin(pin: PinEntity) -> Bool
    func updatePin(pin: PinEntity) -> Bool
    func deletePin(pinID: UUID) -> Bool
    func fetchAllPins() -> [PinEntity]
    func fetchPinsByDate(date: Date) -> [PinEntity]
    
    func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping ([WeatherResponse]) -> Void)
    
    func fetchCurrentWeatherIcon(icon : String) -> UIImage?
    
    func addReview(review: ReviewEntity) -> Bool
    func updateReview(review: ReviewEntity) -> Bool
    func deleteReview(reviewId: UUID) -> Bool
    func fetchAllReviewsByPinID(pinID: UUID) -> [ReviewEntity]
}

final class UseCaseImpl: UseCase {
    
    let dbRepository: DBRepository
    let imageStore: ImageStoreRepository
    
    init(dbRepository: DBRepository, imageStore: ImageStoreRepository) {
        //        DBRepositoryImpl(context: NSManagedObjectContext)
        self.dbRepository = dbRepository
        self.imageStore = imageStore
    }
    
    func addPin(pin: PinEntity) -> Bool {
        let filePath = imageStore.saveImageToDocuments(image: pin.mediaPath, fileName: pin.pin_id.uuidString)
        return dbRepository.addPin(pin: pin, filePath: filePath)
    }
    
    func updatePin(pin: PinEntity) -> Bool {
        let filePath = imageStore.saveImageToDocuments(image: pin.mediaPath, fileName: pin.pin_id.uuidString)
        return dbRepository.updatePin(pin: pin, filePath: filePath)
    }
    
    func deletePin(pinID: UUID) -> Bool {
        return dbRepository.deletePin(id: pinID)
    }
    
    func fetchAllPins() -> [PinEntity] {
        return dbRepository.fetchPinsAll()
            .compactMap { item -> PinEntity? in
                guard let id = item.pin_id else { return nil }
                let image = imageStore.fetchImageFromDocuments(fileName: id.uuidString)
                return item.toPinEntity(image: image)
            }
    }
    //세훈
    func fetchPinsByDate(date: Date) -> [PinEntity] {
        return dbRepository.fetchPinsByDate(date: date)
            .compactMap { item -> PinEntity? in
                guard let id = item.pin_id else { return nil }
                let image = imageStore.fetchImageFromDocuments(fileName: id.uuidString)
                return item.toPinEntity(image: image)
            }
    }
    
    //MARK: - 날씨 정보 받아오기.
    func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping ([WeatherResponse]) -> Void) {
        provider.request(.getWeather(lat: latitude, lon: longitude, lang: "kr")) { result in
            switch result {
            case .success(let response):
                do {
                    let weatherData = try JSONDecoder().decode([WeatherResponse].self, from: response.data)
                    //fetchCurrentWeatherIcon(icon: String)
                    completion(weatherData)
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    completion([])
                }
            case .failure(let error):
                print("Network error: \(error.localizedDescription)")
                completion([])
            }
        }
    }
    
    //MARK: - 날씨 정보에서 나온 iCON을 이용해 이미지를 받습니다.
    func fetchCurrentWeatherIcon(icon: String) -> UIImage? {
        
        return nil
    }
    
    func addReview(review: ReviewEntity) -> Bool {
        return dbRepository.addReview(review: review)
    }
    
    func updateReview(review: ReviewEntity) -> Bool {
        return dbRepository.updateReview(review: review)
    }
    
    func deleteReview(reviewId: UUID) -> Bool {
        return dbRepository.deleteReview(id: reviewId)
    }
    
    func fetchAllReviewsByPinID(pinID: UUID) -> [ReviewEntity] {
        return dbRepository.fetchReviewsByPinId(pinID: pinID)
            .compactMap { item -> ReviewEntity? in
                return item.toReviewEntity()
            }
    }
}
