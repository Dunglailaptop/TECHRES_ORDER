//
//  Ward.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 04/02/2023.
//

import UIKit
import ObjectMapper

struct Ward: Mappable{
    var id  = 0
    var name = ""
    var isSelected = 0
    init() {}
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        isSelected <- map["isSelected"]
    }
    
}

struct WardResponse:Mappable{
    var limit: Int?
    var data = [Ward]()
    var total_record:Int?
      
    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        limit <- map["limit"]
        data <- map["list"]
        total_record <- map["total_record"]
    }
}
