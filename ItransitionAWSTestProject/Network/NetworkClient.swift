//
//  NetworkClient.swift
//  ItransitionAWSTestProject
//
//  Created by Zbranevich, Andrey on 5/3/17.
//  Copyright © 2017 Sak, Andrey2. All rights reserved.
//

import Foundation
import AWSAPIGateway
import AWSCognitoUserPoolsSignIn

public enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

typealias success<T> = (_ t: T) -> ()
typealias failure<T> = (_ error: T) -> ()

class NetworkClient {

    private let manager: AWSAPIGatewayClient
    private var httpHeaders: [String: String]

    init() {
        let serviceConfiguration = AWSServiceConfiguration(region: AWSCloudLogicDefaultRegion, credentialsProvider: AWSIdentityManager.default().credentialsProvider)

        AWSAPI_XLR0MEGJXL_StatusMobileHubClient.register(with: serviceConfiguration!, forKey: AWSCloudLogicDefaultConfigurationKey)

        manager = AWSAPI_XLR0MEGJXL_StatusMobileHubClient(forKey: AWSCloudLogicDefaultConfigurationKey)

        httpHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    func request(urlString: String, method: HTTPMethod, parameters: [String: String]) -> AWSTask<AWSAPIGatewayResponse> {

       // let httpBody = "{ \n  \"key1\":\"value1\", \n  \"key2\":\"value2\", \n  \"key3\":\"value3\"\n}"

        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: method.rawValue,
                                              urlString: urlString,
                                              queryParameters: nil,
                                              headerParameters: httpHeaders,
                                              httpBody: nil)

        return manager.invoke(apiRequest)
    }

    func get(urlString: String, success: @escaping success<String>, failure: @escaping failure<Error>) {
        self.request(urlString: urlString, method: .get, parameters: [:]).continueWith { (task: AWSTask<AWSAPIGatewayResponse>) -> Any? in

            if let error = task.error {
                print("Error occurred: \(error)")
                failure(error)
                return nil
            }

            // Handle successful result here
            let result = task.result!
            let responseString = String(data: result.responseData!, encoding: .utf8)

            print(responseString)
            success(String(result.statusCode))
                
            return nil
        }
    }
}
