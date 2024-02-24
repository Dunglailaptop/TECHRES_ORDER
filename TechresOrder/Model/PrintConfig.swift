//
//  PrintConfig.swift
//  TechresOrder
//
//  Created by Kelvin on 14/01/2023.
//

import UIKit
import ObjectMapper

struct PrintConfig: Mappable {

    var id = 0
    var printer_ip_address = ""
    var printer_name = ""
    var printer_port = ""
    var restaurant_kitchen_place_id = 0
    var branch_id = 0
    var printer_paper_size = 0
    var is_have_printer = 0
    var printer_selected = 0
    var is_print_bill = 0
    var chef_bar_method = 0
    init?(map: Map) {
   }
   init?() {
   }

   mutating func mapping(map: Map) {
       id                                                          <- map["id"]
       printer_ip_address                                          <- map["printer_ip_address"]
       printer_name                                                <- map["printer_name"]
       printer_port                                                <- map["printer_port"]
       restaurant_kitchen_place_id                                 <- map["restaurant_kitchen_place_id"]
       printer_paper_size                                          <- map["printer_paper_size"]
       branch_id                                                   <- map["branch_id"]
       is_have_printer                                             <- map["is_have_printer"]
       printer_selected                                            <- map["printer_selected"]
       is_print_bill                                               <- map["is_print_bill"]
   }
}
