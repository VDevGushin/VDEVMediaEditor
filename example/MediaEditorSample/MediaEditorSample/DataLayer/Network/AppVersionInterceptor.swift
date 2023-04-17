//
//  AppVersionInterceptor.swift
//  W1D1
//
//  Created by Алексей Лысенко on 12.05.2022.
//

import Foundation
import Apollo

final class AppVersionInterceptor: ApolloInterceptor {
    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation : GraphQLOperation {
        request.addHeader(name: "x-w1d1-version", value: Bundle.main.shortVersion)
        chain.proceedAsync(request: request, response: response, completion: completion)
    }
}

extension Bundle {
    // CFBundleVersion
    var version: String {
        Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }

    // CFBundleShortVersionString
    var shortVersion: String {
        Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
}
