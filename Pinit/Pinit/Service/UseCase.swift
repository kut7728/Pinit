//
//  UseCase.swift
//  Pinit
//
//  Created by 안정흠 on 3/12/25.
//

import UIKit
import Moya

protocol UseCase {
    
    /*
     Create, Update, Delete는 하나의 entity만 처리하기에 UIBlocking이 없어 그냥 처리했지만,
     Read(fetch)의 경우 많은 데이터가 한번에 올 것을 고려해서 비동기로 처리함
     */
    
    @discardableResult func addPin(pin: PinEntity) -> Bool
    @discardableResult func updatePin(pin: PinEntity) -> Bool
    @discardableResult func deletePin(pinID: UUID) -> Bool
    func fetchAllPins(completion: @escaping ([PinEntity]) -> Void)
    func fetchPinsByDate(date: Date, completion: @escaping ([PinEntity]) -> Void)
    
    func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (WeatherResponse?) -> Void)
    
    @discardableResult func addReview(review: ReviewEntity) -> Bool
    @discardableResult func updateReview(review: ReviewEntity) -> Bool
    @discardableResult func deleteReview(reviewId: UUID) -> Bool
    func fetchAllReviewsByPinID(pinID: UUID, completion: @escaping ([ReviewEntity]) -> Void)
    
}

final class UseCaseImpl: UseCase {
    let provider: MoyaProvider<Router>
    let dbRepository: DBRepository
    let imageStore: ImageStoreRepository
    
    init(dbRepository: DBRepository, imageStore: ImageStoreRepository, moyaProvider: MoyaProvider<Router>) {
        //        DBRepositoryImpl(context: NSManagedObjectContext)
        self.dbRepository = dbRepository
        self.imageStore = imageStore
        self.provider = moyaProvider
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
    
    func fetchAllPins(completion: @escaping ([PinEntity]) -> Void) {
        dbRepository.fetchPinsAll { [weak self] items in
            let pinEntities = items.compactMap { item -> PinEntity? in
                guard let id = item.pin_id else { return nil }
                let image = self?.imageStore.fetchImageFromDocuments(fileName: id.uuidString)
                return item.toPinEntity(image: image)
            }
            DispatchQueue.main.async {
                completion(pinEntities)
            }
        }
    }
    
    func fetchPinsByDate(date: Date, completion: @escaping ([PinEntity]) -> Void) {
        dbRepository.fetchPinsByDate(date: date, completion: { [weak self] items in
            let pinEntities = items.compactMap { item -> PinEntity? in
                guard let id = item.pin_id else { return nil }
                let image = self?.imageStore.fetchImageFromDocuments(fileName: id.uuidString)
                return item.toPinEntity(image: image)
            }
            DispatchQueue.main.async {
                completion(pinEntities)
            }
        })
    }
    
    //MARK: - 날씨 정보 받아오기.
    func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (WeatherResponse?) -> Void) {
        provider.request(.getWeather(lat: latitude, lon: longitude, lang: "kr")) { result in
            switch result {
            case .success(let response):
                do {
                    let weatherData = try JSONDecoder().decode(WeatherResponse.self, from: response.data)
                    completion(weatherData)
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    completion(nil)
                }
            case .failure(let error):
                print("Network error: \(error.localizedDescription)")
                completion(nil)
            }
        }
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
    
    func fetchAllReviewsByPinID(pinID: UUID, completion: @escaping ([ReviewEntity]) -> Void) {
        dbRepository.fetchReviewsByPinId(pinID: pinID) { items in
            let reviewEntites = items.compactMap { $0.toReviewEntity() }
            completion(reviewEntites)
        }
    }
}
