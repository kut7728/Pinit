//
//  DBRepository.swift
//  Pinit
//
//  Created by 안정흠 on 3/17/25.
//

import UIKit
import CoreData

protocol DBRepository {
    @discardableResult func addPin(pin: PinEntity) -> Bool
    @discardableResult func deletePin(id: UUID) -> Bool
    @discardableResult func updatePin(pin: PinEntity) -> Bool
    
    func fetchPinsAll() -> [PinEntity]
    func fetchPinsByDate(date: Date) -> [PinEntity]
    
    
    @discardableResult func addReview(review: ReviewEntity) -> Bool
    @discardableResult func deleteReview(id: UUID) -> Bool
    @discardableResult func updateReview(review: ReviewEntity) -> Bool
    func fetchReviewsByPinId(pinID: UUID) -> [ReviewEntity]
}
#warning("add 관련 기능 저장하고서 저장이 성공했는지에 따른 return 필요할듯?")
final class DBRepositoryImpl: DBRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addPin(pin: PinEntity) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "PinDTO", in: context)
        else { return false }
        
        let pinDTO = NSManagedObject(entity: entity, insertInto: context)
        
        pinDTO.setValue(pin.pin_id, forKey: "pin_id")
        pinDTO.setValue(pin.title, forKey: "title")
        pinDTO.setValue(pin.latitude, forKey: "latitude")
        pinDTO.setValue(pin.longitude, forKey: "longitude")
        pinDTO.setValue(pin.date, forKey: "date")
        pinDTO.setValue(pin.description, forKey: "content")
        pinDTO.setValue(pin.address, forKey: "address")
        pinDTO.setValue(pin.weather, forKey: "weather")
        if let image = pin.mediaPath,
           let filePath = saveImageToDocuments(image: image, fileName: pin.pin_id.uuidString) {
            pinDTO.setValue(filePath, forKey: "mediaPath")
        }
        saveContext()
        return true
    }
    
    func deletePin(id: UUID) -> Bool {
        let request: NSFetchRequest<PinDTO> = PinDTO.fetchRequest()
        request.predicate = NSPredicate(format: "pin_id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            
            if let objectToDelete = results.first {
                context.delete(objectToDelete)
                saveContext()
                return true
            }
            else {
                print("삭제할 객체가 존재하지 않음")
            }
        } catch {
            print("\(error.localizedDescription)")
        }
        return false
    }
    
    func updatePin(pin: PinEntity) -> Bool {
        let request = PinDTO.fetchRequest()
        request.predicate = NSPredicate(format: "pin_id == %@", pin.pin_id as CVarArg) // UUID로 해당 데이터 찾기
        
        do {
            let fetchResult = try context.fetch(request)
            
            guard let pinDTO = fetchResult.first else {
                print("업데이트할 데이터가 존재하지 않음")
                return false
            }
            
            pinDTO.setValue(pin.title, forKey: "title")
            pinDTO.setValue(pin.latitude, forKey: "latitude")
            pinDTO.setValue(pin.longitude, forKey: "longitude")
            pinDTO.setValue(pin.date, forKey: "date")
            pinDTO.setValue(pin.description, forKey: "content")
            pinDTO.setValue(pin.address, forKey: "address")
            pinDTO.setValue(pin.weather, forKey: "weather")
            
            // 이미지 업데이트 (기존 이미지 삭제 후 새로 저장)
            if let newImage = pin.mediaPath,
               let filePath = saveImageToDocuments(image: newImage, fileName: pin.pin_id.uuidString) {
                
                pinDTO.setValue(filePath, forKey: "mediaPath")
            }
            else { // 이미지가 삭제되었다면 그냥 path nil로 만들기
                pinDTO.setValue(nil, forKey: "mediaPath")
            }
            
            // 변경사항 저장
            saveContext()
            return true
            
        } catch {
            print("업데이트 실패: \(error.localizedDescription)")
            return false
        }
    }
    
    func fetchPinsAll() -> [PinEntity] {
        do {
            let fetchResult = try context.fetch(PinDTO.fetchRequest())
            return fetchResult.compactMap { dto -> PinEntity? in
                return dto.toPinEntity()
            }
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchPinsByDate(date: Date) -> [PinEntity] {
        // date로 저장하면 시간도 같이 저장되기 때문에 00~24시 까지를 가져옴
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date) // 당일 00:00
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)! // 익일 00:00 (당일 23:59까지 포함)
        
        let request = PinDTO.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        do {
            let fetchResult = try context.fetch(request)
            return fetchResult.compactMap { dto -> PinEntity? in
                return dto.toPinEntity()
            }
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func addReview(review: ReviewEntity) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "ReviewDTO", in: context)
        else { return false }
        
        let reviewDTO = NSManagedObject(entity: entity, insertInto: context)
        reviewDTO.setValue(review.id, forKey: "id")
        reviewDTO.setValue(review.pinID, forKey: "pinID")
        reviewDTO.setValue(review.date, forKey: "date")
        reviewDTO.setValue(review.description, forKey: "content")
        
        saveContext()
        return true
    }
    
    func deleteReview(id: UUID) -> Bool {
        let request = ReviewDTO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            
            if let objectToDelete = results.first {
                context.delete(objectToDelete)
                saveContext()
                return true
            }
            else {
                print("삭제할 객체가 존재하지 않음")
                
            }
        } catch {
            print("\(error.localizedDescription)")
        }
        return false
    }
    
    func updateReview(review: ReviewEntity) -> Bool {
        let request = ReviewDTO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", review.id as CVarArg) // UUID로 해당 데이터 찾기
        
        do {
            let fetchResult = try context.fetch(request)
            
            guard let pinDTO = fetchResult.first else {
                print("업데이트할 데이터가 존재하지 않음")
                return false
            }
            
            pinDTO.setValue(review.description, forKey: "content")
            pinDTO.setValue(review.date, forKey: "date")
            
            // 변경사항 저장
            saveContext()
            return true
            
        } catch {
            print("업데이트 실패: \(error.localizedDescription)")
            return false
        }
    }
    
    func fetchReviewsByPinId(pinID: UUID) -> [ReviewEntity] {
        let request = ReviewDTO.fetchRequest()
        request.predicate = NSPredicate(format: "pinID == %@", pinID as CVarArg)
        do {
            let fetchResult = try context.fetch(request)
            return fetchResult.compactMap { dto -> ReviewEntity? in
                return dto.toReviewEntity()
            }
        }
        catch {
            print(error.localizedDescription)
            return []
        }
    }
    private func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension DBRepositoryImpl {
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
