//
//  Vat.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit
import ObjectMapper

struct VatResponse: Mappable {
    var vat: Vat?
    
    init?(map: Map) {
    }

   
    
    mutating func mapping(map: Map) {
        vat <- map["data"]
    }
}

struct Vat: Mappable {
    var id = 0
    var vat_config_id = 0
    var vat_config_name = ""
    var restaurant_id = 0
    var percent = 0.0
    var admin_percent = 0.0
    var created_at = ""
    var updated_at = ""
    var is_updated = 0
    var is_actived = 0
    
    init?(map: Map) {
   }
   init?() {
   }

   mutating func mapping(map: Map) {
        id                                      <- map["id"]
        vat_config_id                                    <- map["vat_config_id"]
        vat_config_name                             <- map["vat_config_name"]
        restaurant_id                           <- map["restaurant_id"]
        percent                                  <- map["percent"]
        admin_percent                               <- map["admin_percent"]
        created_at                              <- map["created_at"]
        updated_at                              <- map["updated_at"]
        is_updated <- map["is_updated"]
        is_actived <- map["is_actived"]
    }
    
}
