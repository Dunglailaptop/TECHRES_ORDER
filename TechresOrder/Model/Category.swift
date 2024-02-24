//
//  Category.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import ObjectMapper

struct Category: Mappable {
    var id = 0
    var name = ""
    var code = ""
    var description = ""
    var status = 0
    var category_type = 0
    
    init?(map: Map) {
   }
   init?() {
   }

   mutating func mapping(map: Map) {
       id                                  <- map["id"]
       name                                <- map["name"]
       code                                <- map["code"]
       description                         <- map["description"]
       status                              <- map["status"]
       category_type                       <- map["category_type"]
    }
}
