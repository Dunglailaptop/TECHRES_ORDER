//
//  Order.swift
//  TechresOrder
//
//  Created by Kelvin on 13/01/2023.
//

import UIKit
import ObjectMapper

struct OrderData: Mappable {
    var orders: [Order]?
    
    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        orders <- map["list"]
    }
}
struct OrderResponse:Mappable{
    var limit: Int?
    var data = [OrderData]()
    var total_record:Int?
      
    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        limit <- map["limit"]
        data <- map["data"]
        total_record <- map["total_record"]
    }
    
}

struct Order: Mappable {
    var using_time_minutes = 0
    var using_time_minutes_string = ""
    var table_name = ""
    var table_id = 0
    var table_merged_names = [String]()
    var using_slot = 0
    var order_status = 0
    var created_at = ""
    var payment_date = ""
    var id = 0
    var customer_id = 0
    var total_amount:Float = 0
    var deposit_amount:Float = 0
    var is_share_point = 0
    var total_order_detail_customer_request = 0
    var note = ""
    var booking_infor_id = 0
    var is_allow_request_payment = 0
    var booking_status = 0
    var employee = Account()
    
    // Thêm trường employee_id
    var employee_id = 0
    
    
     init?(map: Map) {
    }
    init?() {
    }

    mutating func mapping(map: Map) {
        using_time_minutes                  <- map["using_time_minutes"]
        using_time_minutes_string           <- map["using_time_minutes_string"]
        using_slot                          <- map["using_slot"]
        table_name                          <- map["table_name"]
        table_id                            <- map["table_id"]
        table_merged_names                  <- map["table_merged_names"]
        order_status                        <- map["order_status"]
        created_at                          <- map["created_at"]
        payment_date <- map["payment_date"]
        id                                  <- map["id"]
        customer_id <- map["customer_id"]
        total_amount                        <- map["total_amount"]
        is_share_point                      <- map["is_share_point"]
        total_order_detail_customer_request <- map["total_order_detail_customer_request"]
        note <- map["note"]
        booking_infor_id <- map["booking_infor_id"]
        is_allow_request_payment <- map["is_allow_request_payment"]
        booking_status <- map["booking_status"]
        employee <- map["employee"]
        deposit_amount <- map["deposit_amount"]
        employee_id <- map["employee_id"] // map employee_id
    }
}
