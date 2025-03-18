//
//  UseCase.swift
//  Pinit
//
//  Created by 안정흠 on 3/12/25.
//

import UIKit

protocol UseCase {
    func addPin(pin: PinEntity) -> Bool
    func updatePin(pin: PinEntity) -> Bool
    func deletePin(pinID: UUID) -> Bool
    func fetchAllPins() -> [PinEntity]
    func fetchPinsByDate(date: Date) -> [PinEntity]
    
    func fetchCurrentWeather(latitude: Double, longitude: Double) -> UIImage?
    
    func addReview(review: ReviewEntity) -> Bool
    func updateReview(review: ReviewEntity) -> Bool
    func deleteReview(reviewId: UUID) -> Bool
    func fetchAllReviewsByPinID(pinID: UUID) -> [ReviewEntity]
}

final class UseCaseImpl: UseCase {
    let dbRepository: DBRepository
    
    init(dbRepository: DBRepository) {
//        DBRepositoryImpl(context: NSManagedObjectContext)
        self.dbRepository = dbRepository
    }
    
    func addPin(pin: PinEntity) -> Bool {
//        pin.mediaPath
        return dbRepository.addPin(pin: pin)
    }
    
    func updatePin(pin: PinEntity) -> Bool {
        <#code#>
    }
    
    func deletePin(pinID: UUID) -> Bool {
        <#code#>
    }
    
    func fetchAllPins() -> [PinEntity] {
        <#code#>
    }
    
    func fetchPinsByDate(date: Date) -> [PinEntity] {
        <#code#>
    }
    
    func fetchCurrentWeather(latitude: Double, longitude: Double) -> UIImage? {
        <#code#>
    }
    
    func addReview(review: ReviewEntity) -> Bool {
        <#code#>
    }
    
    func updateReview(review: ReviewEntity) -> Bool {
        <#code#>
    }
    
    func deleteReview(reviewId: UUID) -> Bool {
        <#code#>
    }
    
    func fetchAllReviewsByPinID(pinID: UUID) -> [ReviewEntity] {
        <#code#>
    }
    
    
}
