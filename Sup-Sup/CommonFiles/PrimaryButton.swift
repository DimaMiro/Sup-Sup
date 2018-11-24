//
//  PrimaryButton.swift
//  Sup-Sup
//
//  Created by Dima Miro on 01/11/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {

    let loadingIndicator = UIActivityIndicatorView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 5
        setupLoadingIndicator()
    }
    
    func setupLoadingIndicator() {
        
        loadingIndicator.style = UIActivityIndicatorView.Style.white
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(loadingIndicator)
        
        //Constraints
        loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        loadingIndicator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        loadingIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        loadingIndicator.heightAnchor.constraint(equalTo: loadingIndicator.widthAnchor).isActive = true
    }
    
    func loadingIndicatorSwitcher(isShow show: Bool) {
        if show {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
}
