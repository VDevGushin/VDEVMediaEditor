//
//  Apollo+async.swift
//  W1D1
//
//  Created by Алексей Лысенко on 14.04.2022.
//

import Foundation
import Apollo

extension ApolloClient {
    func fetch<Query: GraphQLQuery>(query: Query,
                                    cachePolicy: CachePolicy = .default,
                                    contextIdentifier: UUID? = nil,
                                    queue: DispatchQueue = .main) async throws -> GraphQLResult<Query.Data> {
        return try await withCheckedThrowingContinuation { c in
            fetch(query: query, cachePolicy: cachePolicy, contextIdentifier: contextIdentifier, queue: queue) { res in
                c.resume(with: res)
            }
        }
    }
}
