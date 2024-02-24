//
//  General+Extensions.swift
//  ALOLINE
//
//  Created by Macbook Pro M1 Techres - BE65F182D41C on 11/10/2022.
//  Copyright © 2022 Android developer. All rights reserved.
//


import Foundation
import UIKit

extension UIStoryboard{
    func loadViewController<T>() -> T{
        return self.instantiateViewController(withIdentifier: "\(T.self)") as! T
    }
}

extension CGRect {
    
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
