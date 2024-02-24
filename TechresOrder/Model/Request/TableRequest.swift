//
//  TableRequest.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import ObjectMapper

struct TableRequest: Mappable {
    var table_id = 0
    var branch_id = 0
    var table_name = ""
    var area_id = 0
    var total_slot = 0
  
    
    init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        table_id                                      <- map["table_id"]
        branch_id                                    <- map["branch_id"]
        table_name                                  <- map["table_name"]
        area_id                                    <- map["area_id"]
        total_slot                                   <- map["total_slot"]
       
    }
    
}
