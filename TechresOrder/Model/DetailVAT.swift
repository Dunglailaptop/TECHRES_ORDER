//
//  DetailVAT.swift
//  Techres - Order
//
//  Created by kelvin on 15/04/2022.
//  Copyright © 2022 vn.techres.sale. All rights reserved.
//

import UIKit
import ObjectMapper

class DetailVAT: Mappable {
    var id = 0
    var name = ""
    var price = 0.0
    var quantity = 0.0
    var vat_percent = 0.0
    var vat_amount = 0.0
    var discount_percent = 0.0
    var discount_amount = 0.0
    
    init() {}
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        price <- map["price"]
        quantity <- map["quantity"]
        vat_percent <- map["vat_percent"]
        vat_amount <- map["vat_amount"]
        
        discount_percent <- map["discount_percent"]
        discount_amount <- map["discount_amount"]
    }
}

class VATOrder: Mappable {
    var vat_percent = 0.0
    var vat_amount = 0.0
    var order_details = [DetailVAT]()
    
    init() {}
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        vat_percent <- map["vat_percent"]
        vat_amount <- map["vat_amount"]
        order_details <- map["order_details"]
    }
}
