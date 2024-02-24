//
//  ManageCacheObject.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//


import UIKit
import ObjectMapper

class ManageCacheObject {
    
    // MARK: - setConfig
    static func setConfig(_ config: Config){
        UserDefaults.standard.set(Mapper<Config>().toJSON(config), forKey:Constants.KEY_DEFAULT_STORAGE.KEY_CONFIG)
    }
    
    static func getConfig() -> Config{
        if let config  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_CONFIG){
            return Mapper<Config>().map(JSONObject: config)!
        }else{
            return Config.init()!
        }
    }
    
    // MARK: - setSetting
    static func setSetting(_ setting: Setting){
        UserDefaults.standard.set(Mapper<Setting>().toJSON(setting), forKey:Constants.KEY_DEFAULT_STORAGE.KEY_SETTING)
    }
    
    static func getSetting() -> Setting{
        if let setting  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_SETTING){
            return Mapper<Setting>().map(JSONObject: setting)!
        }else{
            return Setting.init()!
        }
    }
    
    
    //Mark - check setting biometris
    
    static func setBiometric(_ biometric:String){
        UserDefaults.standard.set(biometric, forKey: Constants.KEY_DEFAULT_STORAGE.KEY_BIOMETRIC)
    }
    
    static func getBiometric()->String{
         if let biometric  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_BIOMETRIC){
           
            return String(biometric as! String)
         }else{
            return ""
         }
 
    }
    
    
    static func saveCurrentUser(_ user : Account) {
        UserDefaults.standard.set(Mapper<Account>().toJSON(user), forKey:Constants.KEY_DEFAULT_STORAGE.KEY_ACCOUNT)
        UserDefaults.standard.synchronize()
    }
    
    static func getCurrentUser() -> Account {
        if let user  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_ACCOUNT){
            return Mapper<Account>().map(JSONObject: user)!
        }else{
            return Account.init()
        }
        
        
        
        
    }
    
    // MARK: - ACCESS_TOKEN
    static func setAccessToken(_ access_token:String){
        UserDefaults.standard.set(access_token, forKey: Constants.KEY_DEFAULT_STORAGE.KEY_TOKEN)
    }
    
    static func getAccessToken()->String{
        if let access_token : String = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_TOKEN) as? String{
            return access_token
        }else{
            return ""
        }
    }
    
    
    
    // MARK: - Username
    static func setRestaurantName(_ restaurant_name:String){
       UserDefaults.standard.set(restaurant_name, forKey: Constants.KEY_DEFAULT_STORAGE.KEY_RESTAURANT_NAME)
    }

    static func getRestaurantName()->String{
        if let restaurant_name  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_RESTAURANT_NAME){
           return String(restaurant_name as! String)
        }else{
           return ""
        }

    }
    
    
    
    
    // MARK: - Username
    static func setUsername(_ username:String){
       UserDefaults.standard.set(username, forKey: Constants.KEY_DEFAULT_STORAGE.KEY_PHONE)
    }

    static func getUsername()->String{
        if let username  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_PHONE){
           
           return String(username as! String)
        }else{
           return ""
        }

    }
    
    // MARK: - Password
    static func setPassword(_ password:String){
        UserDefaults.standard.set(password, forKey:Constants.KEY_DEFAULT_STORAGE.KEY_PASSWORD)
    }

    static func getPassword()->String{
        if let password  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_PASSWORD){
           return String(password as! String)
        }else{return ""}
    }
    
    // MARK: - Set chef-bar Config
    static func setChefBarConfigs(_ chefBarConfigs: [Kitchen], cache_key:String){
        UserDefaults.standard.set(Mapper<Kitchen>().toJSONArray(chefBarConfigs), forKey:cache_key)
    }
    // MARK: -  Get Printer Config
    static func getChefBarConfigs(cache_key:String) -> [Kitchen]{
        if let chefBarConfigs  = UserDefaults.standard.object(forKey: cache_key){
            return Mapper<Kitchen>().mapArray(JSONArray: chefBarConfigs as! [[String : Any]])
        }else{
            return [Kitchen]()
        }
    }
    
    static func savePrinterBill(_ printer : Kitchen, cache_key:String) {
        UserDefaults.standard.set(Mapper<Kitchen>().toJSON(printer), forKey:cache_key)
    }
    
    static func getPrinterBill(cache_key:String) -> Kitchen {
        if let printer  = UserDefaults.standard.object(forKey: cache_key){
            return Mapper<Kitchen>().map(JSONObject: printer)!
        }else{
            return Kitchen.init()!
        }
        
    }
    
    
    
    // MARK: - PUSH_TOKEN
    static func setPushToken(_ push_token:String){
        UserDefaults.standard.set(push_token, forKey: Constants.KEY_DEFAULT_STORAGE.KEY_PUSH_TOKEN)
    }
    
    static func getPushToken()->String{
        if let push_token : String = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_PUSH_TOKEN) as? String{
            return push_token
        }else{
            return ""
        }
    }
    
    
    static func saveCurrentPoint(_ currentPoint : NextPoint) {
        UserDefaults.standard.set(Mapper<NextPoint>().toJSON(currentPoint), forKey:Constants.KEY_DEFAULT_STORAGE.KEY_CURRENT_POINT)
        
    }
    
    static func getCurrentPoint() -> NextPoint {
        if let currentPoint  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_CURRENT_POINT){
            return Mapper<NextPoint>().map(JSONObject: currentPoint)!
        }else{
            return NextPoint.init()!
        }
        
        
        
        
    }
    
    
    
    static func isLogin()->Bool{
        let account = ManageCacheObject.getCurrentUser()
        if(account.id == 0){
            return false
        }
        return true
    }
    
    
    static func saveCurrentBranch(_ branch : Branch) {
        UserDefaults.standard.set(Mapper<Branch>().toJSON(branch), forKey:Constants.KEY_DEFAULT_STORAGE.KEY_BRANCH)
        
    }
    
    static func getCurrentBranch() -> Branch {
        if let branch  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_BRANCH){
            return Mapper<Branch>().map(JSONObject: branch)!
        }else{
            return Branch.init()
        }
    }
        
    static func saveCurrentBrand(_ brand : Brand) {
        UserDefaults.standard.set(Mapper<Brand>().toJSON(brand), forKey:Constants.KEY_DEFAULT_STORAGE.KEY_BRAND)
        
    }
    
    static func getCurrentBrand() -> Brand {
        if let brand  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_BRAND){
            return Mapper<Brand>().map(JSONObject: brand)!
        }else{
            return Brand.init()
        }
    }
 
    
   
    
    
}
