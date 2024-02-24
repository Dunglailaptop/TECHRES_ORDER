//
//  Setting.swift
//  TechresOrder
//
//  Created by Kelvin on 14/01/2023.
//

import UIKit
import ObjectMapper

struct SettingResponse: Mappable {
    var setting: Setting?
    
    init?(map: Map) {
    }

   
    
    mutating func mapping(map: Map) {
        setting <- map["data"]
    }
}

struct Setting: Mappable {
    var is_working_offline: Int = 0
    var branch_type: Int = 0
    var branch_type_name: String = ""
    var open_time: String?
    var close_Time: String = ""
    var hour_to_take_report: Int = 3
    var api_prefix_path_for_branch_type: String = ""

    var is_enable_tms: Int = 0
    var is_enable_membership_card = 0
    var is_allow_print_temporary_bill: Int = 0
    var is_print_bill_on_mobile_app: Int = 0
    var is_print_kichen_bill_on_mobile_app: Int = 0
    var is_hide_total_amount_before_complete_bill: Int = 0
    var is_open_table_and_create_order_without_add_food = 0
    var is_require_update_customer_slot_in_order = 0
    var branch_type_option = 0
    var vat: Int = 0
    var branch_info = Branch ()
    var service_restaurant_level_id = 0
    
    init?(map: Map) {
   }
   init?() {
   }

   mutating func mapping(map: Map) {
       is_working_offline              <- map["is_working_offline"]
       branch_type       <- map["branch_type"]
       branch_type_name       <- map["branch_type_name"]
       open_time       <- map["open_time"]
       close_Time              <- map["close_Time"]
       hour_to_take_report              <- map["hour_to_take_report"]
       api_prefix_path_for_branch_type       <- map["api_prefix_path_for_branch_type"]
       
       is_enable_tms              <- map["is_enable_tms"]
       is_enable_membership_card <- map["is_enable_membership_card"]
       is_allow_print_temporary_bill              <- map["is_allow_print_temporary_bill"]
       is_hide_total_amount_before_complete_bill              <- map["is_hide_total_amount_before_complete_bill"]
       vat              <- map["vat"]
       is_print_bill_on_mobile_app              <- map["is_print_bill_on_mobile_app"]
       
       is_print_kichen_bill_on_mobile_app <- map["is_print_kichen_bill_on_mobile_app"]
       is_open_table_and_create_order_without_add_food <- map["is_open_table_and_create_order_without_add_food"]
       branch_type_option  <- map["branch_type_option"]
       is_require_update_customer_slot_in_order  <- map["is_require_update_customer_slot_in_order"]
       branch_info  <- map["branch_info"]
       service_restaurant_level_id <- map["service_restaurant_level_id"]
       
   }
    
}
