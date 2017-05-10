//
//  SignInViewController.swift
//  ItransitionAWSTestProject
//
//  Created by Sak, Andrey2 on 4/29/17.
//  Copyright © 2017 Sak, Andrey2. All rights reserved.
//

import UIKit
import AWSCognitoUserPoolsSignIn
import AWSAPIGateway

class SignInViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var helloLabel: UILabel!

    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AnyObject>?

    override func viewDidLoad() {
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

        defaultServiceManager.defaultServiceConfiguration = serviceConfiguration

        AWSCognitoUserPoolsSignInProvider.sharedInstance().setInteractiveAuthDelegate(AuthService.sharedInstance)

        super.viewDidLoad()

        reloadHelloLabel()
    }

    private func reloadHelloLabel() {
        let identityManager = AWSIdentityManager.default()

        if let identityUserName = identityManager.identityProfile?.userName {
            helloLabel.text = "Hello, \(identityUserName)"
        } else {
            helloLabel.text = "Hello, guest"
        }

    }

    @IBAction func logInAction() {
        AuthService.sharedInstance.configure(with: "tester", andPassword: "12345678")
        
        AWSSignInManager.sharedInstance().login(signInProviderKey: AWSCognitoUserPoolsSignInProvider.sharedInstance().identityProviderName, completionHandler: { [weak self] (result: Any?, authState: AWSIdentityManagerAuthState, error: Error?) in

            self?.reloadHelloLabel()
        })
    }

    @IBAction func logout() {
        AWSSignInManager.sharedInstance().logout { [weak self] (any, state, error) in
            print(state)
            AWSCognitoUserPoolsSignInProvider.sharedInstance().getUserPool().clearAll()
            self?.reloadHelloLabel()
        }
    }

    @IBAction func signUpAction() {
        guard let email = AWSCognitoIdentityUserAttributeType() else {
            return
        }

        email.name = "email"
        email.value = "wow@wow.by"

        AWSCognitoIdentityUserPool.default().signUp("wow", password: "123456", userAttributes: [email], validationData: nil).continueWith { [weak self] (task: AWSTask<AWSCognitoIdentityUserPoolSignUpResponse>) -> AnyObject? in

            self?.reloadHelloLabel()

            return nil
        }
    }

    @IBAction func apiAction() {
        let statusService = StatusService(networkClient: NetworkClient())

        statusService.getStatus(success: { [weak self] status in
            DispatchQueue.main.async {
                self?.helloLabel.text = "Status: \(status)"
            }
        }, failure: { [weak self] error in
            DispatchQueue.main.async {
                self?.helloLabel.text = "Error: \(error)"
            }
        })
    }
}
