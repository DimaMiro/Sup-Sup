//
//  CustomTextField.swift
//  Sup-Sup
//
//  Created by Dima Miro on 02/11/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupTextField()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    func setIcon(image: UIImage, withColor color: UIColor) {
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = color
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    func setupTextField () {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.CustomColor.lightGray.cgColor
        self.layer.borderWidth = 1
        
    }
    
    
}

