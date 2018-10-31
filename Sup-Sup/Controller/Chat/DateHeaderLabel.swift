//
//  DateHeaderLabel.swift
//  Sup-Sup
//
//  Created by Dima Miro on 31/10/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

class DateHeaderLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
        textColor = .white
        textAlignment = .center
        font = UIFont.boldSystemFont(ofSize: 13)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        
        let originalContentSize = super.intrinsicContentSize
        
        let height = originalContentSize.height + 16
        layer.cornerRadius = height / 2
        layer.masksToBounds = true
        
        return CGSize(width: originalContentSize.width + 16, height: height)
        
    }
    
}
