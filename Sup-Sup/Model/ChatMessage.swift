//
//  ChatMessage.swift
//  Sup-Sup
//
//  Created by Dima Miro on 31/10/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit
import Firebase

class ChatMessage: NSObject {
    
    var fromID: String?
    var toID: String?
    
    var text: String?
    var imageUrl: String?
    var timestamp: Int?
    
    
    init(dictionary: [String : Any]) {
        self.fromID = dictionary["fromID"] as? String
        self.toID = dictionary["toID"] as? String
        self.text = dictionary["text"] as? String
        self.imageUrl = dictionary["imageUrl"] as? String
        self.timestamp = dictionary["timestamp"] as? Int
    }
    
    func chatPartnerID() -> String? {
        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
    }
}
