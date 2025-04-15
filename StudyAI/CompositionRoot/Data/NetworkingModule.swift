//
//  NetworkingModule.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 15/4/25.
//

import Factory

extension Container {
    var apiDataSource: Factory<APIDataSourceType> {
        self {
            APIDataSource(
                httpClient: Container.shared.urlSessionHTTPClient(),
                requestBuilder: Container.shared.requestBuilder()
            )
        }
        .singleton
    }
    
    var requestBuilder: Factory<RequestBuilder> {
        self {
            RequestBuilder()
        }
        .singleton
    }
}
