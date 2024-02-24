//
//  BranchRequest.swift
//  TECHRES-ORDER
//
//  Created by macmini_techres_01 on 14/09/2023.
//

import UIKit
import ObjectMapper

struct BranchRequest{
    var id = 0;
    var name = ""
    var phone_number = "";
    var street_name = "";
    var country_id = 0;
    var city_id = 0;
    var district_id = 0;
    var ward_id = 0;
    var image_logo_url = "";
    var banner_image_url = "";
 
    init(){}
    init?(map:Map){
        
    }
    
    mutating func mapping(map: Map){
        id                    <- map["id"]
        name                  <- map["name"]
        phone_number          <- map["phone_number"]
        street_name           <- map["street_name"]
        country_id            <- map["country_id"]
        city_id               <- map["city_id"]
        district_id           <- map["district_id"]
        ward_id               <- map["ward_id"]
        image_logo_url        <- map["image_logo_url"]
        banner_image_url      <- map["banner_image_url"]
        
    }

}
