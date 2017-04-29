//
//  AppDelegate.swift
//  ItransitionAWSTestProject
//
//  Created by Sak, Andrey2 on 4/28/17.
//  Copyright © 2017 Sak, Andrey2. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return AWSMobileClient.sharedInstance.didFinishLaunching(application, withOptions: launchOptions)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return AWSMobileClient.sharedInstance.withApplication(application, withURL: url, withSourceApplication: sourceApplication, withAnnotation: annotation)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AWSMobileClient.sharedInstance.applicationDidBecomeActive(application)
    }

}
