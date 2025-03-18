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
              let content = content
        else { return nil }
        
        var image: UIImage? = nil // 혹시몰라서 명시
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
            description: content,
            mediaPath: image
        )
    }
    
    
}
