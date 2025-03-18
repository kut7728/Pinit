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
    let imageStore: ImageStoreRepository
    init(dbRepository: DBRepository, imageStore: ImageStoreRepository) {
//        DBRepositoryImpl(context: NSManagedObjectContext)
        self.dbRepository = dbRepository
        self.imageStore = imageStore
    }
    
    func addPin(pin: PinEntity) -> Bool {
        imageStore.saveImageToDocuments(image: pin.mediaPath, fileName: pin.pin_id)
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
    
    // 로컬 디렉토리에서 이미지 로드
    private func fetchImageFromDocuments(fileName: String) -> UIImage? {
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName).path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)
        }
        return nil
    }
    
    // 이미지 저장
    private func saveImageToDocuments(image: UIImage, fileName: String) -> String? {
        if let data = image.jpegData(compressionQuality: 1.0) {
            let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
            do {
                try data.write(to: filePath)
                return filePath.path
            } catch {
                print("Failed to save image to documents: \(error)")
            }
        }
        return nil
    }
    
}
