//
//  OrderDetail.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 14/01/2023.
//

import ObjectMapper

struct OrderDetailData: Mappable {
    var discount_amount = 0
    var area_id = 0
    var table_id = 0
    var id = 0
    var status = 0
    var amount = 0
    var total_point = 0
    var discount_percent = 0
    var vat_percent = 0
    var vat_amount = 0
    var total_amount = 0
    var total_final_amount = 0
    var is_allow_request_payment = 0
    var order_details = [OrderDetail]()
    var object_data = [OrderDetail]()
    var table_name:String = ""
    var created_at:String = ""
    var employee_name:String = ""
    var customer_slot_number = 0
    var is_share_point = 0
    var total_order_detail_customer_request = 0
    var is_apply_vat = 0
    var is_allow_review = 0
    var booking_status = 0
    var branch_address:String = ""
    var discount_type = -100
    var discount_type_name = ""

    var customer_name = ""
    var customer_phone = ""
   
    // lấy điểm số trong view payment
    var order_customer_beer_inventory_quantity = 0
    var membership_point_used = 0
    var membership_accumulate_point_used = 0
    var membership_promotion_point_used = 0
    var membership_alo_point_used = 0
    var membership_point_used_amount = 0
    var membership_accumulate_point_used_amount = 0
    var membership_promotion_point_used_amount = 0
    var membership_alo_point_used_amount = 0
    
    init?(map: Map) {
   }
   init?() {
   }

    mutating func mapping(map: Map) {
        id              <- map["id"]
        area_id         <- map["area_id"]
        table_id         <- map["table_id"]
        status       <- map["status"]
        is_apply_vat       <- map["is_apply_vat"]
        is_allow_review       <- map["is_allow_review"]
        amount           <- map["amount"]
        total_point           <- map["total_point"]
        discount_amount            <- map["discount_amount"]
        discount_percent  <- map["discount_percent"]
        total_amount            <- map["total_amount"]
        total_final_amount            <- map["total_final_amount"]
        is_allow_request_payment            <- map["is_allow_request_payment"]
        order_details            <- map["order_details"]
        object_data            <- map["object_data"]
        table_name            <- map["table_name"]
        vat_amount            <- map["vat_amount"]
         vat_percent            <- map["vat"]
         created_at            <- map["created_at"]
         employee_name            <- map["employee_name"]
        table_name            <- map["table_name"]
        customer_slot_number    <- map["customer_slot_number"]
        is_share_point          <- map["is_share_point"]
        branch_address          <- map["branch_address"]
        total_order_detail_customer_request          <- map["total_order_detail_customer_request"]
        customer_name <- map["customer_name"]
        customer_phone <- map["customer_phone"]
        booking_status <- map["booking_status"]
        discount_type <- map["discount_type"]
        discount_type_name <- map["discount_type_name"]
        
        
        order_customer_beer_inventory_quantity <- map["order_customer_beer_inventory_quantity"]
        membership_point_used <- map["membership_point_used"]
        membership_accumulate_point_used <- map["membership_accumulate_point_used"]
        membership_promotion_point_used <- map["membership_promotion_point_used"]
        membership_alo_point_used <- map["membership_alo_point_used"]
        membership_point_used_amount <- map["membership_point_used_amount"]
        membership_accumulate_point_used_amount <- map["membership_accumulate_point_used_amount"]
        membership_promotion_point_used_amount <- map["membership_promotion_point_used_amount"]
        membership_alo_point_used_amount <- map["membership_alo_point_used_amount"]
        
        
        
    }
}

struct OrderDetail: Mappable {
    var id = 0
    var food_id = 0
    var name = ""
    var price = 0
    var quantity:Float = 0
    var return_quantity_for_drink:Float = 0
    var printed_quantity:Float = 0

    var total_price_inlcude_addition_foods:Float = 0
    var total_price:Float = 0
    var status = 0
    var category_type = 0
    var category_type_name = ""
    var is_gift = 0
    var is_cook_on_table = 0
    var status_text = ""
    var enable_return_beer = 0
    var note = ""
    var new_note = ""
    var is_bbq = 0
    var select = false
    var is_swipe = 0
    var is_extra_Charge = 0
    var food_quantity:Float = 0
    var isChange:Float = 0
    var is_allow_review = 0
    var is_allow_print = 0
    var is_sell_by_weight = 0
    var review_score = 0
    var move_from_list_table_name = [String]()
    var moveFromTableName = ""
    var order_detail_additions = [OrderDetailAddition]()
    var order_detail_combo = [OrderDetailAddition]()
    var order_detail_restaurant_pc_foods = [OrderDetailAddition]()
    var rateInfo = ReviewFoodData()
    var food_notes = [FoodNote]()
    var total_price_include_addition_foods: Float = 0
    var is_combo = 0
    var food_in_combo_wait_print_quantity = 0
    var cancel_reason = ""
    var food_avatar = ""

    
    init?(map: Map) {
   }
   init?() {
   }

    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        food_id                                 <- map["food_id"]
        name                                    <- map["name"]
        price                                   <- map["price"]
        quantity                                <- map["quantity"]
        return_quantity_for_drink               <- map["return_quantity_for_drink"]
        printed_quantity                        <- map["printed_quantity"]
        total_price                             <- map["total_price"]
        status                                  <- map["status"]
        category_type                           <- map["category_type"]
        category_type_name                      <- map["category_type_name"]
        is_gift                                 <- map["is_gift"]
        is_cook_on_table                        <- map["is_cook_on_table"]
        status_text                             <- map["status_text"]
        enable_return_beer                      <- map["enable_return_beer"]
        note                                    <- map["note"]
        is_bbq                                  <- map["is_bbq"]
        is_extra_Charge                        <- map["is_extra_charge"]
        is_allow_review                         <- map["is_allow_review"]
        is_allow_print <- map["is_allow_print"]
        isChange                                <- map["isChange"]
        moveFromTableName <- map["moveFromTableName"]
        move_from_list_table_name               <- map["move_from_list_table_name"]
        moveFromTableName               <- map["moveFromTableName"]
        is_sell_by_weight                       <- map["is_sell_by_weight"]
        review_score                            <- map["review_score"]
        order_detail_additions                  <- map["order_detail_additions"]
        order_detail_combo                  <- map["order_detail_combo"]
        total_price_inlcude_addition_foods      <- map["total_price_inlcude_addition_foods"]
        food_notes <- map["food_notes"]
        total_price_include_addition_foods <- map["total_price_include_addition_foods"]
        order_detail_restaurant_pc_foods <- map["order_detail_restaurant_pc_foods"]
        is_combo <- map["is_combo"]
        food_in_combo_wait_print_quantity <- map["food_in_combo_wait_print_quantity"]
        cancel_reason <- map["cancel_reason"]
        food_avatar <- map["food_avatar"]
   }
    
}

struct OrderDetailAddition: Mappable {
    var id = 0
    var name = ""
    var price = 0
    var totalPrice:Float = 0
    var quantity:Float = 0
    var status = 0
    var note = ""
    var isNotAllowRequestPayment = 0
    var category_type = 0
    var category_type_name = ""
    var is_gift = 0
    var is_cook_on_table = 0
    var status_text = ""
    var enable_return_beer = 0
    var printed_quantity = 0
    var new_note = ""
    var is_bbq = 0
    var select = false
    var is_swipe = 0
    var food_quantity:Float = 0
    var isChange:Float = 0
    var is_allow_review = 0
    var is_sell_by_weight = 0
    var review_score = 0
    var move_from_list_table_name = [String]()
    var moveFromTableName = ""
    
    var rateInfo = ReviewFoodData()
    
    init?(map: Map) {
   }
   init?() {
   }

    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        name                                    <- map["name"]
        price                                   <- map["price"]
        totalPrice                              <- map["total_price"]
        quantity                                <- map["quantity"]
        food_quantity                           <- map["food_quantity"]
        status                                  <- map["status"]
        note                                    <- map["note"]
        isNotAllowRequestPayment                <- map["isNotAllowRequestPayment"]
        category_type                           <- map["category_type"]
        category_type_name                      <- map["category_type_name"]
        is_gift                                 <- map["is_gift"]
        is_cook_on_table                        <- map["is_cook_on_table"]
        status_text                             <- map["status_text"]
        enable_return_beer                      <- map["enable_return_beer"]
        is_bbq                                  <- map["is_bbq"]
        is_allow_review                         <- map["is_allow_review"]
        isChange                                <- map["isChange"]
        move_from_list_table_name               <- map["move_from_list_table_name"]
        is_sell_by_weight                       <- map["is_sell_by_weight"]
        review_score                            <- map["review_score"]
        moveFromTableName                       <- map["moveFromTableName"]
        printed_quantity                        <- map["printed_quantity"]
    }

}

struct ReviewFoodData: Mappable {
    
    var order_detail_id = 0
    var score = 0
    var note = ""
    
    init?(map: Map) {
   }
   init?() {
   }

    mutating func mapping(map: Map) {
        order_detail_id                 <- map["order_detail_id"]
        score                           <- map["score"]
        note                            <- map["note"]
    }
}


struct FoodNote: Mappable {
    var food_note = ""
    var food_note_id = 0
    
    init?(map: Map) {
   }
   init?() {
   }
    mutating func mapping(map: Map) {
        food_note_id                                                         <- map["food_note_id"]
        food_note                                                       <- map["food_note"]
    }
}

