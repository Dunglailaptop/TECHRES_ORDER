//
//  Gift.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 09/03/2023.
//

import UIKit
import ObjectMapper

struct Gift: Mappable {
    var id = 0
    var expire_at = ""
    var name = ""
    var restaurant_gift_image_url = ""
    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        id                                                                  <- map["id"]
        expire_at                                                           <- map["expire_at"]
        name                                                                <- map["name"]
        restaurant_gift_image_url                                           <- map["restaurant_gift_image_url"]
    }
}
