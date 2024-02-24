//
//  FoodInComboRealm.swift
//  TECHRES-ORDER
//
//  Created by Kelvin on 19/09/2023.
//

import RealmSwift

final class FoodInComboRealm: Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var food_id: Int = 0
    @Persisted var name = String()
    @Persisted var price = Float()
    @Persisted var avatar = String()
    @Persisted var is_cook_on_table = Int()
    @Persisted var quantity : Int = 0
    @Persisted var combo_quantity : Int = 0
    @Persisted var weight = Float()
    @Persisted var checkTypeFood : Int = 0
    @Persisted var is_selected : Int = 0
    @Persisted var is_out_stock : Int = 0
    
  
}
