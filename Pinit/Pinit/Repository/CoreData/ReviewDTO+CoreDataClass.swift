//
//  ReviewDTO+CoreDataClass.swift
//  Pinit
//
//  Created by 안정흠 on 3/18/25.
//
//

import Foundation
import CoreData

@objc(ReviewDTO)
public class ReviewDTO: NSManagedObject {
    func toReviewEntity() -> ReviewEntity? {
        guard let id = id,
              let pinID = pinID,
              let date = date,
              let desc = desc else { return nil }
        
        return ReviewEntity(id: id,
                            pinID: pinID,
                            date: date,
                            description: desc
        )
    }
}
