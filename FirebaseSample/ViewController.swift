//
//  ViewController.swift
//  FirebaseSample
//
//  Created by ShuichiNagao on 2018/07/09.
//  Copyright © 2018 Shuichi Nagao. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in
            print("push permission finished")
        }
    }

}

