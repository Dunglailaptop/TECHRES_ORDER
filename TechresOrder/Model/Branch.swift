//
//  Branch.swift
//  TechresOrder
//
//  Created by Kelvin on 14/01/2023.
//

import UIKit
import ObjectMapper

struct Branch: Mappable {
    var id = 0
    var name = ""
    var phone = ""
    var address = ""
    var status = 0
    var is_use_fingerprint = 0
    var enable_checkin = 0
    var qr_code_checkin = ""
    var avatar = ""
    var is_office = 0
    var image_logo = ""
    var banner = ""
    var city_id = 0
    var city_name = ""
    var district_id = 0
    var district_name = ""
    var ward_id = 0
    var ward_name = ""
    var street_name = ""
    var address_full_text = ""
    
    // value update branches
    var country_name = ""
    var lng = ""
    var image_logo_url = ""
    var address_note = "Ghi chú"
    var banner_image_url = ""
    var lat = ""
   
    
    
    init() {}
     init?(map: Map) {
    }
    

    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        name                                    <- map["name"]
        phone                                   <- map["phone"]
        address                                 <- map["address"]
        status                                  <- map["status"]
        avatar                                  <- map["avatar"]
        is_use_fingerprint                      <- map["is_use_fingerprint"]
        enable_checkin                          <- map["enable_checkin"]
        qr_code_checkin                         <- map["qr_code_checkin"]
        is_office                               <- map["is_office"]
        image_logo <- map["image_logo"]
         banner <- map["banner"]
         city_id <- map["city_id"]
         city_name <- map["city_name"]
         district_id <- map["district_id"]
         district_name <- map["district_name"]
         ward_id <- map["ward_id"]
         ward_name <- map["ward_name"]
         street_name <- map["street_name"]
         address_full_text <- map["address_full_text"]
         country_name <- map["country_name"]
         lng <- map["lng"]
         image_logo_url <- map["image_logo_url"]
         address_note <- map["address_note"]
         banner_image_url <- map["address_note"]
         lat <- map["lat"]
    }
}
