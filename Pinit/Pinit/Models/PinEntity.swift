//
//  PinEntity.swift
//  Pinit
//
//  Created by 안정흠 on 3/12/25.
//

import Foundation

struct PinEntity: Codable {
    let pin_id: UUID
    let latitude: Double
    let longitude: Double
    let address: String
    let date: String
    let weather: String
    let mediaPath: String?
    let description: String?
}


