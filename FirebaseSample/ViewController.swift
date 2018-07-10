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

    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in
            print("push permission finished")
        }
        
        User.anonymousLogin() { user in
            self.user = user
            if let user = user {
                user.fcmToken = UserDefaults.standard.string(forKey: "FCM_TOKEN")
                user.update()
            }
        }
        
        setButton()
    }
    
    private func setButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height / 6))
        button.backgroundColor = .black
        button.setTitle("Add Book", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(addBook), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func addBook(_ sender: UIButton){
        let book = Book()
        book.name = "Alice in Wonderland"
        user?.books.insert(book)
        user?.update()
    }
}
