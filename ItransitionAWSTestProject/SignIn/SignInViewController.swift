//
//  SignInViewController.swift
//  ItransitionAWSTestProject
//
//  Created by Sak, Andrey2 on 4/29/17.
//  Copyright © 2017 Sak, Andrey2. All rights reserved.
//

import UIKit
import AWSCognitoUserPoolsSignIn

class SignInViewController: UIViewController {

    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AnyObject>?

    override func viewDidLoad() {
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "us-east-1_oAXrga09j")
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration

        AWSCognitoUserPoolsSignInProvider.sharedInstance().setInteractiveAuthDelegate(AuthService(username: "tester", password: "12345678"))

        super.viewDidLoad()
    }

    @IBAction func logInAction() {
        if AWSSignInManager.sharedInstance().isLoggedIn {
            AWSSignInManager.sharedInstance().logout(completionHandler: { _, _, _ in
                print("LOGOUT")

                AWSSignInManager.sharedInstance().login(signInProviderKey: AWSCognitoUserPoolsSignInProvider.sharedInstance().identityProviderName, completionHandler: {(result: Any?, authState: AWSIdentityManagerAuthState, error: Error?) in
                    print("result = \(result), error = \(error)")
                })
            })
        } else {
            AWSSignInManager.sharedInstance().login(signInProviderKey: AWSCognitoUserPoolsSignInProvider.sharedInstance().identityProviderName, completionHandler: {(result: Any?, authState: AWSIdentityManagerAuthState, error: Error?) in
                print("result = \(result), error = \(error)")
            })
        }

    }

}
