//
//  RegistrationOperation.swift
//  Network
//
//  Created by Vladislav Gushin on 08.12.2022.
//

import Foundation

struct RegistrationOperation: ApiOperation {
    typealias Response = UserInfo.Tokens

    let phoneNumber: String

    var path: String = "/api/v1/testing/tutorials/not-viewed/"
    var method: HTTPMethod { .get }
    var params: [String : String] = [:]
    var token: String?
}
