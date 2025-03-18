//
//  ImageStoreRepository.swift
//  Pinit
//
//  Created by 안정흠 on 3/12/25.
//

import UIKit

protocol ImageStoreRepository {
    func fetchImageFromDocuments(fileName: String) -> UIImage?
    func saveImageToDocuments(image: UIImage, fileName: String) -> String?
}

final class ImageStoreRepositoryImpl {
    private lazy var fileManager = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    // 로컬 디렉토리에서 이미지 로드
    func fetchImageFromDocuments(fileName: String) -> UIImage? {
        let filePath = fileManager.appendingPathComponent(fileName).path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)
        }
        return nil
    }
    
    // 이미지 저장
    func saveImageToDocuments(image: UIImage?, fileName: String) -> String? {
        if let data = image?.jpegData(compressionQuality: 1.0) {
            let filePath = fileManager.appendingPathComponent(fileName)
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
