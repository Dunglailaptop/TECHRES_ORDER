//
//  Food.swift
//  TechresOrder
//
//  Created by Kelvin on 16/01/2023.
//

import UIKit
import ObjectMapper

struct Food : Mappable {
    var description =  ""
    var status =  0
    var name =  ""
    var code =  ""
    var note =  ""
    var prefix =  ""
    var  price =  0
    var price_with_temporary = 0
    var unit =  ""
    var unit_type =  ""
    var quantity:Float = 0.0
    var quantity_refun:Float = 0
    var printed_quantity:Float = 0
    var id =  0
    var restaurant_id =  0
    var restaurant_brand_id =  0
    var branch_id =  0
    var category_id =  0
    var avatar =  ""
    var avatar_thump =  ""
    var food_status =  0
    var normalize_name =  ""
    var original_price =  0
    var temporary_price =  0
    var temporary_percent =  0
    var temporary_price_from_date = ""
    var temporary_price_to_date = ""
    var point_to_purchase =  0
    var is_addition =  0
    var is_addition_like_food =  0
    var time_to_completed =  0
    var is_sell_by_weight =  0
    var is_allow_review =  0
    var is_allow_print =  0
    var is_allow_purchase_by_point =  0
    var is_take_away =  0
    var is_best_seller =  0
    var is_allow_employee_gift =  0
    var is_combo =  0
    var is_bbq =  0
    var is_special_gift =  0
    var is_goods =  0
    var is_deleted =  0
    var category_type =  0
    var restaurant_vat_config_id =  0
    var food_addition_ids = [String]()
    var food_in_combo = [FoodInCombo]()
    var addition_foods = [FoodInCombo]()
    var food_notes = [Note]()
    var food_list_in_promotion_buy_one_get_one = [FoodInCombo]()

    var restaurant_kitchen_place_id = 0
    var is_out_stock = 0
    var is_selected = 0
    init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        description                                      <- map["description"]
        status                                      <- map["status"]
        name                                      <- map["name"]
        code                                      <- map["code"]
        note                                      <- map["note"]
        prefix                                      <- map["prefix"]
        price                                      <- map["price"]
        price_with_temporary                       <- map["price_with_temporary"]
        unit                                      <- map["unit"]
        unit_type                                      <- map["unit_type"]
        quantity                                      <- map["quantity"]
        quantity_refun                                      <- map["quantity_refun"]
        printed_quantity                                      <- map["printed_quantity"]
        id                                      <- map["id"]
        restaurant_id                                      <- map["restaurant_id"]
        restaurant_brand_id                                      <- map["restaurant_brand_id"]
        branch_id                                      <- map["branch_id"]
        category_id                                      <- map["category_id"]
        avatar                                      <- map["avatar"]
        avatar_thump                                      <- map["avatar_thump"]
        food_status                                      <- map["food_status"]
        normalize_name                                      <- map["normalize_name"]
        original_price                                      <- map["original_price"]
        temporary_price                                      <- map["temporary_price"]
        temporary_percent                                      <- map["temporary_percent"]
        temporary_price_to_date                                      <- map["temporary_price_to_date"]
        temporary_price_from_date                                      <- map["temporary_price_from_date"]
        point_to_purchase                                      <- map["point_to_purchase"]
        is_addition                                      <- map["is_addition"]
        
        is_addition_like_food                                      <- map["is_addition_like_food"]
        time_to_completed                                      <- map["time_to_completed"]
        is_sell_by_weight                                      <- map["is_sell_by_weight"]
        is_allow_review                                      <- map["is_allow_review"]
        is_allow_print                                      <- map["is_allow_print"]
        is_allow_purchase_by_point                                      <- map["is_allow_purchase_by_point"]
        is_take_away                                      <- map["is_take_away"]
        is_best_seller                                      <- map["is_best_seller"]
        is_combo                                      <- map["is_combo"]
        is_special_gift                                      <- map["is_special_gift"]
        is_goods                                      <- map["is_goods"]
        
        is_deleted                                      <- map["is_deleted"]
        category_type                                     <- map["category_type"]
        restaurant_vat_config_id                          <- map["restaurant_vat_config_id"]
        food_addition_ids                                 <- map["food_addition_ids"]
        food_in_combo                                     <- map["food_in_combo"]
        addition_foods                                     <- map["addition_foods"]
        food_notes                                     <- map["food_notes"]
        restaurant_kitchen_place_id                       <- map["restaurant_kitchen_place_id"]
        is_out_stock                                      <- map["is_out_stock"]
        is_selected                                      <- map["is_selected"]
        is_allow_employee_gift                           <- map["is_allow_employee_gift"]
        
    }
}
struct FoodInCombo : Mappable {
   
    var id = 0
    var name = ""
    var price:Float = 0
    var avatar = ""
    var is_cook_on_table = 0
    var quantity = 0
    var combo_quantity = 0
    var weight:Float = 0
    var checkTypeFood = 0
    var is_selected = 0
    var is_out_stock = 0
     init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        avatar                                  <- map["avatar"]
        name                                    <- map["name"]
        price                                   <- map["price"]
        is_cook_on_table                        <- map["is_cook_on_table"]
        quantity                                <- map["quantity"]
        combo_quantity                          <- map["combo_quantity"]
        is_selected                                <- map["is_selected"]
        is_out_stock                                      <- map["is_out_stock"]
    }
}

