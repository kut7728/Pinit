//
//  Router.swift
//  Pinit
//
//  Created by 안세훈 on 3/14/25.
//

import UIKit
import Moya

var BASEURL : String = "https://api.openweathermap.org/data/2.5"

enum Router {
    case getWeather(lat: Double, lon: Double, lang: String)
}

extension Router : TargetType {
    var baseURL: URL { URL(string: BASEURL)!}
    
    var path: String {
        switch self {
        case .getWeather: return "/weather"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getWeather(let lat, let lon, let lang):
            return .requestParameters(parameters: [
                "lat": lat,
                "lon": lon,
                "appid": Bundle.main.WeaterKey,
                "lang" : lang,
            ], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
