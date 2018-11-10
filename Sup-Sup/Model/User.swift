//
//  User.swift
//  Sup-Sup
//
//  Created by Dima Miro on 03/11/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

class User: NSObject {
    var id : String?
    var name : String?
    var email : String?
    var profileImageUrl : String?
    
    init(dictionary: [String : Any]) {
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}
