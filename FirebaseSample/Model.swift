//
//  Model.swift
//  FirebaseSample
//
//  Created by ShuichiNagao on 2018/07/10.
//  Copyright © 2018 Shuichi Nagao. All rights reserved.
//

import Foundation
import FirebaseAuth
import Pring

@objcMembers
class User: Object {
    dynamic var name: String?
    dynamic var fcmToken: String?
    dynamic var books: NestedCollection<Book> = []
    
    static func anonymousLogin(_ completionHandler: @escaping ((User?) -> Void)) {
        Auth.auth().signInAnonymously { (auth, error) in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(nil)
                return
            }
            
            guard let currentUser = Auth.auth().currentUser else {
                completionHandler(nil)
                return
            }

            User.get(currentUser.uid) { (user, _) in
                if let user = user {
                    print("Success login of an existing user")
                    completionHandler(user)
                } else {
                    let u = User(id: auth!.user.uid)
                    u.name = "Alice"
                    u.save() { ref, error in
                        print("Success login of a new user")
                        completionHandler(u)
                    }
                }
            }
        }
    }
}

@objcMembers
class Book: Object {
    dynamic var name: String?
}
