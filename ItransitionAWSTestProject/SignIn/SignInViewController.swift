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


    

}
