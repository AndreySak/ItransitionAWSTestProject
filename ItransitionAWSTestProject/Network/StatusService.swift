//
//  StatusService.swift
//  ItransitionAWSTestProject
//
//  Created by Zbranevich, Andrey on 5/3/17.
//  Copyright © 2017 Sak, Andrey2. All rights reserved.
//

import Foundation

class StatusService {
    private let networkClient: NetworkClient

    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    public func getStatus(success: @escaping success<String>, failure: @escaping failure<Error>) {
        networkClient.get(urlString: "/api/devices", success: success, failure: failure)
    }

}
