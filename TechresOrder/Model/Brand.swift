//
//  Brand.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import ObjectMapper

struct Brand: Mappable {
    var id = 0
    var status = 0
    var restaurant_id = 0
    var customer_partner_id = 0
    var name = ""
    var address = ""
    var logo_url = ""
    var banner = ""
    var qr_code_checkin = ""
    var description = ""
    var setting = Setting()
    var restaurant_brand_business_types = ""
    var total_branches = 0
    var created_at = ""
    var updated_at = ""
    var service_restaurant_level_id = 0
    var service_restaurant_level_type = 0
    var service_restaurant_level_price = 0
    var is_office = 0

    init() {}
     init?(map: Map) {
    }
    
   
 

    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        status                                    <- map["status"]
        restaurant_id                                   <- map["restaurant_id"]
        customer_partner_id                                 <- map["customer_partner_id"]
        name                                  <- map["name"]
        address                                  <- map["address"]
        logo_url                      <- map["logo_url"]
        banner                          <- map["banner"]
        qr_code_checkin                         <- map["qr_code_checkin"]
        description                               <- map["description"]
        
        setting                               <- map["setting"]
        restaurant_brand_business_types                               <- map["restaurant_brand_business_types"]
        total_branches                               <- map["total_branches"]
        created_at                               <- map["created_at"]
        updated_at                               <- map["updated_at"]
        service_restaurant_level_id                               <- map["service_restaurant_level_id"]
        service_restaurant_level_type                               <- map["service_restaurant_level_type"]
        service_restaurant_level_price                               <- map["service_restaurant_level_price"]
        
        setting                               <- map["setting"]
        is_office                               <- map["is_office"]
        
    }
}
struct RestaurantBrandBusinessType: Mappable {
    var id = 0
    var name = ""
    var description = ""
    var created_at = ""
    var updated_at = ""
    var is_hidden = 0
    
    
    init?(map: Map) {
    }
    init?() {
    }
    
    mutating func mapping(map: Map) {
        id                               <- map["id"]
        name                               <- map["name"]
        description                               <- map["description"]
        created_at                               <- map["created_at"]
        updated_at                               <- map["updated_at"]
        is_hidden                               <- map["is_hidden"]
    }
}
