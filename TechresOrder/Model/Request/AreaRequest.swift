//
//  AreaRequest.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import ObjectMapper

struct AreaRequest: Mappable {
    var id = 0
    var status = 0
    var name = ""
    var branch_id = 0
    var employee_manager_id = 0
  
    init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        status                                    <- map["status"]
        name                                  <- map["name"]
        branch_id                                    <- map["branch_id"]
        employee_manager_id                                   <- map["employee_manager_id"]
       
    }
    
}
