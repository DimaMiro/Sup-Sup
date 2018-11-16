//
//  Extensions.swift
//  Sup-Sup
//
//  Created by Dima Miro on 06/11/2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCache(withUrlString urlString : String) {
        
        //Set a placeholder as a default image
//        self.image = UIImage(named: "profilePicPlaceholder")
        
        //Check cache for image first
        if let chacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = chacheImage
            return
        }
        
        //Otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let dowloadedImage = UIImage(data: data!) {
                    imageCache.setObject(dowloadedImage, forKey: urlString as AnyObject)
                    self.image = dowloadedImage
                }
            }
            }.resume()
    }
}
