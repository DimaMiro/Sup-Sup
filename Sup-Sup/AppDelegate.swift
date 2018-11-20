//
//  AppDelegate.swift
//  Sup-Sup
//
//  Created by Dima Miro on 15/10/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        return true
    }


}

