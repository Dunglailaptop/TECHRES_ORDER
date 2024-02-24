//
//  Kitchen.swift
//  TechresOrder
//
//  Created by Kelvin on 17/01/2023.
//

import UIKit
import ObjectMapper

struct Kitchen: Mappable {

    var id = 0
    var name = ""
    var description = ""
    var restaurant_id = 0
    var branch_id = 0
    var restaurant_brand_id = 0
    var status = 0
    var branch_name = ""
    var type = 0
    var printer_name = ""
    var printer_ip_address = ""
    var printer_port = ""
    var printer_paper_size = 1
    var is_have_printer = 0
    var created_at = ""
    var updated_at = ""
    var is_print_each_food:Int = 0
    var print_type:Int = 0
    var print_number:Int = 1
    
    init?(map: Map) {
   }
   init?() {
   }

   mutating func mapping(map: Map) {
        id                                      <- map["id"]
        name                                    <- map["name"]
        description                             <- map["description"]
        restaurant_id                           <- map["restaurant_id"]
        status                                  <- map["status"]
        branch_id                               <- map["branch_id"]
        branch_name                             <- map["branch_name"]
        created_at                              <- map["created_at"]
        updated_at                              <- map["updated_at"]
        printer_name                              <- map["printer_name"]
        printer_ip_address                              <- map["printer_ip_address"]
        printer_port                              <- map["printer_port"]
        printer_paper_size                              <- map["printer_paper_size"]
        print_number                         <- map["print_number"]
        is_have_printer                              <- map["is_have_printer"]
        is_print_each_food                       <- map["is_print_each_food"]
        type                       <- map["type"]
        print_type                       <- map["print_type"]
    }
}
