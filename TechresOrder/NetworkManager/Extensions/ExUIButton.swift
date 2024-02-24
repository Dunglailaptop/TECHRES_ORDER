//
//  ExUIButton.swift
//  ORDER
//
//  Created by Pham Khanh Huy on 19/06/2023.
//

import UIKit

extension UIButton {
    func addShadow(shadowOffset: CGSize, shadowOpacity:Float, shadowRadius:Int, color:UIColor){
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = CGFloat(shadowRadius)
        self.layer.masksToBounds = false
    }
}
