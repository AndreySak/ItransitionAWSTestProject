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
    private var httpHeaders: [String: Any]

    init() {
        let defaultServiceManager: AWSServiceManager = AWSServiceManager.default()

        let userPoolServiceConfiguration: AWSServiceConfiguration = AWSServiceConfiguration(region: .USEast1,
                                                                                            credentialsProvider: nil)
        let userIdentityPoolConfiguration: AWSCognitoIdentityUserPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: AWSCognitoUserPoolAppClientId,
                                                                                                                             clientSecret: AWSCognitoUserPoolClientSecret,
                                                                                                                             poolId: AWSCognitoUserPoolId)
        AWSCognitoIdentityUserPool.register(with: userPoolServiceConfiguration,
                                            userPoolConfiguration: userIdentityPoolConfiguration,
                                            forKey: AWSCognitoUserPoolId)
        let userPool: AWSCognitoIdentityUserPool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolId)

        let credentialsProvider: AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSCognitoUserPoolRegion,
                                                                                               identityPoolId: "eu-central-1:a29cf6c7-82a8-47f2-aeff-64d43380b2ae",
                                                                                               identityProviderManager: userPool)
        let serviceConfiguration: AWSServiceConfiguration = AWSServiceConfiguration(region: .USEast1,
                                                                                    endpoint: AWSEndpoint(urlString: "https://7ucv6txl1a.execute-api.eu-central-1.amazonaws.com/dev"),
                                                                                    credentialsProvider: credentialsProvider)

        TESTPROD1NewsClient.registerClient(withConfiguration: serviceConfiguration, forKey: AWSCloudLogicDefaultConfigurationKey)

        manager = TESTPROD1NewsClient.client(forKey: AWSCloudLogicDefaultConfigurationKey)


        httpHeaders = [
            "Content-Type222": "application/json",
            "Accept": "application/json"
        ]
    }

    func request(urlString: String, method: HTTPMethod, parameters: [String: String]) -> AWSTask<AWSAPIGatewayResponse> {

        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: method.rawValue,
                                              urlString: urlString,
                                              queryParameters: ["api-version":"2.2"],
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
