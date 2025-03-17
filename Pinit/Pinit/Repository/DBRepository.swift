//
//  DBRepository.swift
//  Pinit
//
//  Created by 안정흠 on 3/17/25.
//

import UIKit

protocol DBRepository {
    @discardableResult func addPin() -> Bool
    @discardableResult func deletePin() -> Bool
    @discardableResult func updatePin() -> Bool
    
    func fetchPinsAll() -> [PinEntity]
    func fetchPinsByDate() -> [PinEntity]
    
    
    @discardableResult func addReview() -> Bool
    @discardableResult func deleteReview() -> Bool
    @discardableResult func updateReview() -> Bool
    func fetchReviewsByPinId() -> [ReviewEntity]
}

final class DBRepositoryImpl: DBRepository {
    func addPin() -> Bool {
        
    }
    
    func deletePin() -> Bool {
        
    }
    
    func updatePin() -> Bool {
        
    }
    
    func fetchPinsAll() -> [PinEntity] {
        
    }
    
    func fetchPinsByDate() -> [PinEntity] {
            
    }
    
    func addReview() -> Bool {
            
    }
    
    func deleteReview() -> Bool {
            
    }
    
    func updateReview() -> Bool {
            
    }
    
    func fetchReviewsByPinId() -> [ReviewEntity] {
            
    }
}

extension DBRepository {
    private func saveImageToDocuments(image: UIImage, fileName: String) -> String? {
        if let data = image.jpegData(compressionQuality: 1.0) {
            let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
            do {
                try data.write(to: filePath)
                return filePath.path
            } catch {
                print("Failed to save image to documents: \(error)")
            }
        }
        return nil
    }
    // 로컬 디렉토리에서 이미지 로드
    private func fetchImageFromDocuments(fileName: String) -> UIImage? {
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName).path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)
        }
        return nil
    }

    // Documents 디렉토리 경로 가져오기
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
