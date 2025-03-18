//
//  PinDTO+CoreDataClass.swift
//  Pinit
//
//  Created by 안정흠 on 3/18/25.
//
//

import UIKit
import CoreData

@objc(PinDTO)
public class PinDTO: NSManagedObject {
    func toPinEntity() -> PinEntity? {
        guard let pin_id = pin_id,
              let title = title,
              let address = address,
              let date = date,
              let weather = weather,
              let desc = desc
        else { return nil }
        
        var image: UIImage?
        if let mediaPath = mediaPath {
            image = fetchImageFromDocuments(fileName: pin_id.uuidString)
        }
        
        return PinEntity(
            pin_id: pin_id,
            title: title,
            latitude: latitude,
            longitude: longitude,
            address: address,
            date: date,
            weather: weather,
            description: desc,
            mediaPath: image
        )
    }
    
    // 로컬 디렉토리에서 이미지 로드
    private func fetchImageFromDocuments(fileName: String) -> UIImage? {
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName).path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)
        }
        return nil
    }
}
