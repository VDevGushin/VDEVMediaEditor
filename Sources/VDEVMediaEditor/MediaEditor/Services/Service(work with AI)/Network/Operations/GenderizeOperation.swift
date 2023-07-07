//
//  GenderizeOperation.swift
//  Network
//
//  Created by Vladislav Gushin on 08.12.2022.
//

import Foundation

struct GenderizeOperation: ApiOperation {
    typealias Response = Genderize

    var path: String = ""
    var method: HTTPMethod = .get
    var params: [String : String] = ["name": "luc"]
    
    var token: String?

    struct Genderize: Decodable {
        let count: Int
        let gender, name: String
        let probability: Double
    }
}
