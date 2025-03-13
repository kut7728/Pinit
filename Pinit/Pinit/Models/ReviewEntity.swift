//
//  ReviewEntity.swift
//  Pinit
//
//  Created by 안정흠 on 3/13/25.
//
import Foundation

struct ReviewEntity: Codable {
    let id: UUID
    let pinID: UUID
    let data: Date
    let weather: String
    let mediaPath: String?
    let description: String?
}
