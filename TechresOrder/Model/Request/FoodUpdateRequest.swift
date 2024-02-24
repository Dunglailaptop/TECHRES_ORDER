//
//  FoodUpdateRequest.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import ObjectMapper

struct FoodUpdateRequest: Mappable {
    var order_detail_id = 0
    var quantity: Float = 0
    var note = ""
   
    init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        order_detail_id <- map["order_detail_id"]
        quantity <- map["quantity"]
        note <- map["note"]
    }
}
