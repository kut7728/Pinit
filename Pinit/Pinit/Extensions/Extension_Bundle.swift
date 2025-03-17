//
//  Extension_Bundle.swift
//  Pinit
//
//  Created by 안세훈 on 3/14/25.
//

import Foundation

extension Bundle {

    var WeaterKey: String {
        guard let file = Bundle.main.path(forResource: "API_KEY", ofType: "plist") else {
            fatalError("API_KEY not found")
        }
        
        guard let resource = NSDictionary(contentsOfFile: file) else {
            fatalError("Failed to load API_KEY.plist")
        }
        
        guard let key = resource["KEY"] as? String else {
            fatalError("KEY not found in API_KEY")
        }
        
        return key
    }
}
