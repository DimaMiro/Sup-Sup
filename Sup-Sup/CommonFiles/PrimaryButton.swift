//
//  PrimaryButton.swift
//  Sup-Sup
//
//  Created by Dima Miro on 01/11/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = 5
    }
}
