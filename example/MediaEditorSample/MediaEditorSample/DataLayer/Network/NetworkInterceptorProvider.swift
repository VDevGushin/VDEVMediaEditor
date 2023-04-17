//
//  NetworkInterceptorProvider.swift
//  W1D1
//
//  Created by Алексей Лысенко on 12.05.2022.
//

import Foundation
import Apollo

final class NetworkInterceptorProvider: InterceptorProvider {
    private let store: ApolloStore
    private let client: URLSessionClient
    
    init(store: ApolloStore,
         client: URLSessionClient) {
        self.store = store
        self.client = client
    }
    
    func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation : GraphQLOperation {
        [
            MaxRetryInterceptor(),
            CacheReadInterceptor(store: store),
            AppVersionInterceptor(),
            UserCredsInterceptor(),
            NetworkFetchInterceptor(client: client),
            ResponseCodeInterceptor(),
            JSONResponseParsingInterceptor(cacheKeyForObject: store.cacheKeyForObject),
            CacheWriteInterceptor(store: store)
        ]
    }
}
