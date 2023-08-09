//
//  TestBodyOperation.swift
//  Network
//
//  Created by Vladislav Gushin on 08.12.2022.
//

import Foundation

struct TestBodyOperation: ApiOperationWithBody {
    typealias Response = Test1

    var body: Test2 {
        .init(test: "test test")
    }

    var encoder: JSONEncoder { JSONEncoder() }

    var path: String = "/test"

    var method: HTTPMethod { .post }

    var params: [String : String] = [:]

    var token: String?


    struct Test1: Decodable {
        let test: String
    }

    struct Test2: Encodable {
        let test: String
    }
}
