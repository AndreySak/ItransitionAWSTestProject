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

    @IBAction func signUpAction() {
        guard let email = AWSCognitoIdentityUserAttributeType() else {
            return
        }

        email.name = "email"
        email.value = "wow@wow.by"

        AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey).signUp("wow", password: "123456", userAttributes: [email], validationData: nil).continueWith { [weak self] (task: AWSTask<AWSCognitoIdentityUserPoolSignUpResponse>) -> AnyObject? in

            self?.reloadHelloLabel()

            return nil
        }
    }

    @IBAction func apiAction() {
        let httpMethodName = "POST"
        let URLString = "/status"
        let queryStringParameters = ["key1":"value1"]
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        let httpBody = "{ \n  \"key1\":\"value1\", \n  \"key2\":\"value2\", \n  \"key3\":\"value3\"\n}"

        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName,
                                              urlString: URLString,
                                              queryParameters: queryStringParameters,
                                              headerParameters: headerParameters,
                                              httpBody: httpBody)

        // Fetch the Cloud Logic client to be used for invocation
        // Change the `AWSAPI_XE21FG_MyCloudLogicClient` class name to the client class for your generated SDK
        let serviceConfiguration = AWSServiceConfiguration(region: AWSCloudLogicDefaultRegion, credentialsProvider: AWSIdentityManager.default().credentialsProvider)

        AWSAPI_XLR0MEGJXL_StatusMobileHubClient.register(with: serviceConfiguration!, forKey: AWSCloudLogicDefaultConfigurationKey)

        let invocationClient = AWSAPI_XLR0MEGJXL_StatusMobileHubClient(forKey: AWSCloudLogicDefaultConfigurationKey)

        invocationClient.invoke(apiRequest).continueWith { (task: AWSTask<AWSAPIGatewayResponse>) -> Any? in

            if let error = task.error {
                print("Error occurred: \(error)")
                // Handle error here
                return nil
            }

            // Handle successful result here
            let result = task.result!
            let responseString = String(data: result.responseData!, encoding: .utf8)

            print(responseString)
            print(result.statusCode)
            
            return nil
        }
    }

    

}
