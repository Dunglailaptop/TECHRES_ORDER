//
//  Extensions.swift
//  CustomTabBarExample
//
//  Created by kelvin on 18/12/2022.
//

import UIKit
import RealmSwift
import ObjectMapper


extension UILabel {
    func configureWith(_ text: String,
                       color: UIColor,
                       alignment: NSTextAlignment,
                       size: CGFloat,
                       weight: UIFont.Weight = .regular) {
        self.font = .systemFont(ofSize: size, weight: weight)
        
        var title = ""
        if(text == "General"){
            title = "Tổng quan"
        }else if(text == "Order"){
            title = "Đơn hàng"
        }else if(text == "Area"){
            title = "Khu vực"
        }else if(text == "Fee"){
            title = "Chi phí"
        }else if(text == "Utilities"){
            title = "Tiện ích"
        }else if(text == "Báo cáo"){
            title = "Báo cáo"
        }
        dLog(title)
        
        self.text = text
        self.textColor = color
        self.textAlignment = alignment
    }
}

extension UIView {
    func setupCornerRadius(_ cornerRadius: CGFloat = 0, maskedCorners: CACornerMask? = nil) {
        layer.cornerRadius = cornerRadius
        if let corners = maskedCorners {
            layer.maskedCorners = corners
        }
    }
    
    func animateClick(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.15) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.transform = CGAffineTransform.identity
            } completion: { _ in completion() }
        }
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 7
        layer.backgroundColor = ColorUtils.main_color().cgColor
    }
}

extension UIStackView {
    func addArrangedSubviews(_ subviews: [UIView]) {
       
        subviews.forEach { addArrangedSubview($0) }
    }
}


extension Results{

    func get <T:Object> (offset: Int, limit: Int ) -> Array<T>{
        //create variables
        var lim = 0 // how much to take
        var off = 0 // start from
        var l: Array<T> = Array<T>() // results list

        //check indexes
        if off<=offset && offset<self.count{
            off = offset
        }
        if limit > self.count {
            lim = self.count
        }else{
            lim = limit
        }

        //do slicing
        for i in off..<lim{
            let dog = self[i] as! T
            l.append(dog)
        }

        //results
        return l
    }
}
