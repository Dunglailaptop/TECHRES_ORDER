//
//  UIImageView+Extension.swift
//  ALOLINE
//
//  Created by Macbook Pro M1 Techres - BE65F182D41C on 11/10/2022.
//  Copyright © 2022 Android developer. All rights reserved.
//


import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func setKingfisherImageView(image: String?, placeholder: String = "") {
        var path = ""
        if let url = image {
            path = url
        }
                
        if placeholder.isEmpty {
            self.kf.indicatorType = .activity
            let indicator = self.kf.indicator?.view as? UIActivityIndicatorView
            //indicator?.style = .whiteLarge
            indicator?.color = ColorUtils.main_color()
        }
        
        self.kf.setImage(
            with: URL(string: path),
            placeholder: UIImage(named: placeholder),
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}
