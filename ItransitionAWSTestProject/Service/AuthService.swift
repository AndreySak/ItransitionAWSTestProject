//
//  AuthService.swift
//  ItransitionAWSTestProject
//
//  Created by Zbranevich, Andrey on 4/29/17.
//  Copyright © 2017 Sak, Andrey2. All rights reserved.
//

import Foundation
import AWSCognitoUserPoolsSignIn

class AuthService: NSObject {
    static let sharedInstance = AuthService()

    fileprivate var username: String = ""
    fileprivate var password: String = ""

    public func configure(with username: String, andPassword password: String) {
        self.username = username
        self.password = password
    }

}

extension AuthService: AWSCognitoIdentityInteractiveAuthenticationDelegate {

    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        return self
    }

}

extension AuthService: AWSCognitoIdentityPasswordAuthentication {

    func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {

        passwordAuthenticationCompletionSource.set(result: AWSCognitoIdentityPasswordAuthenticationDetails(username: username, password: password))

    }

    func handleUserPoolSignInFlowStart() {
        
    }

    func didCompleteStepWithError(_ error: Error?) {
        print(error ?? "ok")
    }
}

extension AuthService: AWSSignInDelegate {

    func onLogin(signInProvider: AWSSignInProvider, result: Any?, authState: AWSIdentityManagerAuthState, error: Error?) {
        print(error ?? "ok")
    }
}

