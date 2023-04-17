//
//  UserCredsInterceptor.swift
//  W1D1
//
//  Created by Алексей Лысенко on 27.05.2022.
//

import Foundation
import Apollo

fileprivate struct UserSharedData: Codable {
    let id: String
    let token: String
}

final class UserCredsInterceptor: ApolloInterceptor {
    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation : GraphQLOperation {
        let storage = FilePlistStorage.widgetGroup
        
        // FIXME: Нужно подложить реальные данные
        let _ : UserSharedData? = try? storage.get(fromFileNamed: "sharedData")
        
        request.addHeader(name: "id", value: "a3542326-e295-4ab0-acdb-596928f15015")
        request.addHeader(name: "authorization", value: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJhMzU0MjMyNi1lMjk1LTRhYjAtYWNkYi01OTY5MjhmMTUwMTUifQ.IpBFC6qaEXFaRs6cFk30nzBkjr2f54ipb6Ch7azXTCs")

        chain.proceedAsync(request: request, response: response, completion: completion)
    }
}
