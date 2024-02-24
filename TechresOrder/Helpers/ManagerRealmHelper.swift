//
//  ManagerRealmHelper.swift
//  TECHRES-ORDER
//
//  Created by Kelvin on 19/09/2023.
//

import UIKit
import RSRealmHelper
import RealmSwift

class ManagerRealmHelper: NSObject {

    
    let foodRepository = FoodRepository()
   
    static let SchemeaVersion: UInt64  = 1 // it was 1 previously
    
    
    
    //singleton
    private static var shareManagerRealmHelper: ManagerRealmHelper = {
        let managerRealmHelper = ManagerRealmHelper()
         return managerRealmHelper
    }()
    
    class func shareInstance() -> ManagerRealmHelper {
           return shareManagerRealmHelper
       }
    
    
    func configureRealm(){
          
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 4,
         
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })
         
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
         
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
//        let realm = try! Realm()
        

    }
    
    //MARK: Delete a single element
     func deleteFood(food:[FoodRealm]){
         let realmHelper = RealmHelper(realmInstance: .inMemory)
         
        do {
            try realmHelper.delete(elements: food)
        } catch {
            // handle exception
            
        }
    }

    
    func getFoodLimit(category_type: Int, is_allow_employee_gift:Int, is_out_stock:Int, keyword:String, area_id:Int, offset:Int = 0, limit:Int = 50) -> [Food]{
        
        var filter = area_id != ALL ? String(format: "category_type == %d && area_id == %d", category_type, area_id) : String(format: "category_type == %d", category_type, area_id)
       
        
        if(category_type == ALL){
             filter = area_id != ALL ? String(format:"area_id == %d && is_allow_employee_gift == %d && is_out_stock == %d", area_id, is_allow_employee_gift, is_out_stock) : String(format: "category_type == 1 OR category_type == 2 OR category_type == 3 && is_allow_employee_gift == %d && is_out_stock == %d", is_allow_employee_gift, is_out_stock)
        }else{
             filter = area_id != ALL ? String(format: "category_type == %d && area_id == %d && is_allow_employee_gift == %d && is_out_stock == %d", category_type, area_id, is_allow_employee_gift, is_out_stock) : String(format: "category_type == %d && is_out_stock == %d", category_type, area_id, is_out_stock)
        }
        
        
        if( is_allow_employee_gift == ALL){
            filter = filter.replacingOccurrences(of: String(format: "&& is_allow_employee_gift == %d ", is_allow_employee_gift), with: "")
        }
        
        if( is_out_stock == ALL){
            filter = filter.replacingOccurrences(of: String(format: "&& is_out_stock == %d", is_out_stock), with: "")
        }
//        if( is_out_stock == ACTIVE){
//            filter = filter.replacingOccurrences(of: String(format: "area_id == %d &&", area_id), with: "")
//        }
        
        
        dLog( filter)
        
        var foods = [FoodRealm]()// =  DbHelper.sharedDbHelper.realmObj.objects(FoodRealm.self).filter(filter).get(offset: offset, limit: limit)
//        let all: [FoodRealm] = DbHelper.sharedDbHelper.getObjects(filter: filter)
        
        
        foods = DbHelper.sharedDbHelper.realmObj.objects(FoodRealm.self).filter(filter).get(offset: offset, limit: limit)

        
        dLog(foods)
        var foodsModel = [Food]()
        
        for i in 0..<foods.count {
            var food = Food()
            food.id = foods[i].food_id
            food.code = foods[i].code
            food.prefix = foods[i].prefix
            food.name = foods[i].name
            food.avatar = foods[i].avatar
            food.status = foods[i].status
            food.normalize_name = foods[i].normalize_name
            food.category_id = foods[i].category_id
            food.category_type = foods[i].category_type
            food.price_with_temporary = foods[i].price_with_temporary
            food.is_sell_by_weight = foods[i].is_sell_by_weight
            food.is_combo = foods[i].is_combo
            food.time_to_completed = foods[i].time_to_completed
            food.unit_type = foods[i].unit_type
            food.price = foods[i].price
            food.addition_foods =  getFoodCombo(foodComboList: foods[i].addition_foods)
            food.food_list_in_promotion_buy_one_get_one = getFoodCombo(foodComboList: foods[i].food_list_in_promotion_buy_one_get_one)
            food.is_out_stock = foods[i].is_out_stock
            food.is_allow_print = foods[i].is_allow_print
            food.restaurant_vat_config_id = foods[i].restaurant_vat_config_id
            food.restaurant_kitchen_place_id = foods[i].restaurant_kitchen_place_id
            foodsModel.append(food)
        }
       
       dLog(foodsModel.toJSON())
       
        return foodsModel
        
    }
    
   
    private func getFoodCombo(foodComboList: List<FoodInComboRealm>)->[FoodInCombo]{
        var foodsCombo = [FoodInCombo]()
        for i in 0..<foodComboList.count {
            var foodCombo = FoodInCombo()
            foodCombo.id = foodComboList[i].food_id
            foodCombo.price = foodComboList[i].price
            foodCombo.name = foodComboList[i].name
            foodCombo.avatar = foodComboList[i].avatar
            foodCombo.quantity = foodComboList[i].quantity
            foodCombo.combo_quantity = foodComboList[i].combo_quantity
            foodsCombo.append(foodCombo)
        }
        return foodsCombo
    }
    
    
    
    //MARK: Save all employees on database
    func saveFoods(foods:[Food], area_id:Int = -1){
//        DbHelper.sharedDbHelper.deleteAll()
        dLog(foods.toJSON())
        
        dLog(Realm.Configuration.defaultConfiguration.fileURL!)
        for i in 0..<foods.count {
          
            let foodRealm = FoodRealm()
            foodRealm.food_id = foods[i].id
            foodRealm.area_id = area_id
            foodRealm.name = foods[i].name
            foodRealm.prefix = foods[i].prefix
            foodRealm.avatar = foods[i].avatar
            foodRealm.normalize_name = foods[i].normalize_name
            foodRealm.code = foods[i].code
            foodRealm.price = foods[i].price
            foodRealm.temporary_price = foods[i].temporary_price
            foodRealm.temporary_percent = foods[i].temporary_percent
            foodRealm.temporary_price_from_date = foods[i].temporary_price_from_date
            foodRealm.temporary_price_to_date = foods[i].temporary_price_to_date
            foodRealm.is_allow_print = foods[i].is_allow_print
            foodRealm.restaurant_vat_config_id = foods[i].restaurant_vat_config_id
            foodRealm.restaurant_kitchen_place_id = foods[i].restaurant_kitchen_place_id
            foodRealm.status = foods[i].status
            foodRealm.category_id = foods[i].category_id
            foodRealm.category_type = foods[i].category_type
            foodRealm.price_with_temporary = foods[i].price_with_temporary
            foodRealm.is_sell_by_weight = foods[i].is_sell_by_weight
            foodRealm.is_combo = foods[i].is_combo
            foodRealm.is_out_stock = foods[i].is_out_stock
            foodRealm.is_allow_employee_gift = foods[i].is_allow_employee_gift
            foodRealm.time_to_completed = foods[i].time_to_completed
            foodRealm.unit_type = foods[i].unit_type
            foodRealm.food_in_combo = getFoodCombo(foods: foods[i].food_in_combo)
            foodRealm.addition_foods = getFoodCombo(foods: foods[i].addition_foods)
            foodRealm.food_list_in_promotion_buy_one_get_one = getFoodCombo(foods: foods[i].food_list_in_promotion_buy_one_get_one)
            foodRealm.food_notes = getFoodNotes(notes: foods[i].food_notes)

            DbHelper.sharedDbHelper.saveObject(object: foodRealm)
        }
        
    }
    func getFoodCombo(foods:[FoodInCombo]) -> List<FoodInComboRealm>{
        let foodsCombo = List<FoodInComboRealm>()
        for i in 0..<foods .count {
            let foodCombo = FoodInComboRealm()
            foodCombo.food_id = foods[i].id
            foodCombo.name = foods[i].name
            foodCombo.avatar = foods[i].avatar
//            foodCombo.price = foods[i].price
//            foodCombo.promotion_percent_price = foods[i].promotion_percent_price
//            foodCombo.promotion_percent = foods[i].promotion_percent
//            foodCombo.promotion_from_date = foods[i].promotion_from_date
//            foodCombo.promotion_to_date = foods[i].promotion_to_date
//            foodCombo.promotion_from_hour = foods[i].promotion_from_hour
//            foodCombo.promotion_to_hour = foods[i].promotion_to_hour
//            foodCombo.temporary_price = foods[i].temporary_price
//            foodCombo.temporary_percent = foods[i].temporary_percent
//            foodCombo.temporary_price_from_date = foods[i].temporary_price_from_date
//            foodCombo.temporary_price_to_date = foods[i].temporary_price_to_date
//            foodCombo.is_allow_print = foods[i].is_allow_print
//            foodCombo.is_allow_employee_gift = foods[i].is_allow_employee_gift
//            foodCombo.restaurant_vat_config_id = foods[i].restaurant_vat_config_id
//            foodCombo.restaurant_kitchen_place_id = foods[i].restaurant_kitchen_place_id
//            foodCombo.promotion_day_of_weeks = foods[i].promotion_day_of_weeks
//            foodCombo.is_allow_print_stamp = foods[i].is_allow_print_stamp
//            foodCombo.status = foods[i].status
//            foodCombo.category_id = foods[i].category_id
//            foodCombo.category_type = foods[i].category_type
//            foodCombo.category_name = foods[i].category_name
//            foodCombo.vat_percent = foods[i].vat_percent
//            foodCombo.price_with_temporary = foods[i].price_with_temporary
//            foodCombo.combo_quantity = foods[i].combo_quantity
//            foodCombo.is_sell_by_weight = foods[i].is_sell_by_weight
//            foodCombo.is_combo = foods[i].is_combo
//            foodCombo.time_to_completed = foods[i].time_to_completed
//            foodCombo.unit_type = foods[i].unit_type
//            foodCombo.food_in_combo = getFoodCombo(foods: foods[i].food_in_combo)
//            foodCombo.addition_foods = getFoodCombo(foods: foods[i].addition_foods)
//            foodCombo.food_list_in_promotion_buy_one_get_one = getFoodCombo(foods: foods[i].food_list_in_promotion_buy_one_get_one)
//            foodCombo.food_notes = getFoodNotes(notes: foods[i].food_notes)
            
            foodsCombo.append(foodCombo)
            
        }
        return foodsCombo
    }
    func getFoodNotes(notes:[Note]) -> List<NoteRealm>{
        let notesReals = List<NoteRealm>()
        for i in 0..<notes .count {
            let noteReal = NoteRealm()
            noteReal.note_id = notes[i].id
            noteReal.note_id = notes[i].id
            noteReal.note = notes[i].note
            noteReal.content = notes[i].content
            notesReals.append(noteReal)
            
        }
        return notesReals
    }
    
    // ============== STORE LOCAL DATA AREA =========
    
    //MARK: Save all Area on database
    func saveAreas(areas:[Area]){
        for i in 0..<areas.count {
            let areaRealm = AreaRealm()
            areaRealm.area_id = areas[i].id
            areaRealm.name = areas[i].name
            areaRealm.status = areas[i].status
           
            DbHelper.sharedDbHelper.saveObject(object: areaRealm)
        }
        
    }
}
