//
//  FoodRealm.swift
//  TECHRES-ORDER
//
//  Created by Kelvin on 19/09/2023.
//

import RealmSwift

final class FoodRealm: Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var food_id: Int = 0
    @Persisted var area_id: Int = 0
    @Persisted var name = String()
    @Persisted var status: Int = 0
    @Persisted var code = String()
    @Persisted var note = String()
    @Persisted var prefix = String()
    @Persisted var  price: Int = 0
    @Persisted var price_with_temporary: Int = 0
    @Persisted var unit = String()
    @Persisted var unit_type = String()
    @Persisted var quantity = Float()
    @Persisted var quantity_refun = Float()
    @Persisted var printed_quantity = Float()
    @Persisted var restaurant_id: Int = 0
    @Persisted var restaurant_brand_id: Int = 0
    @Persisted var branch_id: Int = 0
    @Persisted var category_id: Int = 0
    @Persisted var avatar = String()
    @Persisted var avatar_thump = String()
    @Persisted var food_status: Int = 0
    @Persisted var normalize_name = String()
    @Persisted var original_price: Int = 0
    @Persisted var temporary_price: Int = 0
    @Persisted var temporary_percent: Int = 0
    @Persisted var temporary_price_from_date = String()
    @Persisted var temporary_price_to_date = String()
    @Persisted var point_to_purchase: Int = 0
    @Persisted var is_addition: Int = 0
    @Persisted var is_addition_like_food: Int = 0
    @Persisted var time_to_completed: Int = 0
    @Persisted var is_sell_by_weight: Int = 0
    @Persisted var is_allow_review: Int = 0
    @Persisted var is_allow_print: Int = 0
    @Persisted var is_allow_purchase_by_point: Int = 0
    @Persisted var is_take_away: Int = 0
    @Persisted var is_best_seller: Int = 0
    @Persisted var is_combo: Int = 0
    @Persisted var is_bbq: Int = 0
    @Persisted var is_special_gift: Int = 0
    @Persisted var is_goods: Int = 0
    @Persisted var is_deleted: Int = 0
    @Persisted var category_type: Int = 0
    
    @Persisted var promotion_percent_price: Float = 0.0
    @Persisted var promotion_from_hour: String = ""
    @Persisted var promotion_to_hour: String = ""
    @Persisted var is_allow_print_stamp: Int = 0
    
    
    @Persisted var restaurant_vat_config_id: Int = 0
   
    @Persisted var food_addition_ids = List<String>()
    
    @Persisted var food_in_combo = List<FoodInComboRealm>()
    @Persisted  var addition_foods =  List<FoodInComboRealm>()
    @Persisted  var food_notes =  List<NoteRealm>()
    @Persisted var food_list_in_promotion_buy_one_get_one  = List<FoodInComboRealm>()

    @Persisted var restaurant_kitchen_place_id: Int = 0
    @Persisted var is_out_stock: Int = 0

    
    @Persisted var promotion_percent: Int = 0
    @Persisted var promotion_from_date: Int = 0
    @Persisted var promotion_to_date: Int = 0
    @Persisted var is_allow_employee_gift: Int = 0
    
    
        
    @Persisted var category_name: Int = 0

    @Persisted var vat_percent: Int = 0

    @Persisted var combo_quantity: Int = 0



    

}
