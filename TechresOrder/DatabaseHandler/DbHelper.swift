//
//  DbHelper.swift
//  TECHRES-ORDER
//
//  Created by Kelvin on 20/09/2023.
//

import UIKit
import RealmSwift

public class DbHelper {
    
    private init() {}
    
    static let sharedDbHelper = DbHelper()
    
  
            
                   
           
    lazy var realmObj:Realm = {
        return try! Realm()
    }()
    
    
//    var realmObj = try! Realm()
    
    /**
     Generic function to create Object in the DB
     */
    func save <T: Object> (_ obj : T){
        
        do {
            try realmObj.write {
                realmObj.add(obj)
            }
            
        }catch{
            print("DbHelperException","Create",error)
        }
        
    }
    
    
    /**
     Generic function to update Object in the DB
     */
    func update <T: Object> (_ obj : T, with dictionary: [String : Any?]){
        do{
            try realmObj.write {
                
                for (key,value) in dictionary{
                    obj.setValue(value, forKey: key)
                }
                
            }
        }catch {
            print("DbHelperException","Update",error)
        }
        
        
    }
    
    /**
     Generic function to delete Object in the DB
     */
    func delete <T: Object> (_ obj : T){
        do {
            try realmObj.write {
                realmObj.delete(obj)
            }
        }catch {
            print("DbHelperException","Delete",error)
        }
        
    }
    /**
     Generic function to delete all Object in the DB
     */
    func deleteAll(){
        do {
            try realmObj.write {
                realmObj.deleteAll()
            }
        }catch {
            print("DbHelperException","Delete",error)
        }
        
    }
    
    /**
     Function to manage the error and post it
     */
    func postDbError(_ error : Error)  {
        
        NotificationCenter.default.post(name: NSNotification.Name(""), object: error)
    }
    
    /**
     Function to observe the error and post it
     */
    func observeDbErrors(in Vc: UIViewController, completion: @escaping  (Error?) -> Void) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(""), object: nil, queue: nil) { (notification) in
            completion(notification.object as? Error)
        }
    }
    
    
    /**
     Function to remove observer of the error
     */
    func stopDbErrorObserver (in Vc: UIViewController ){
        
        NotificationCenter.default.removeObserver(Vc, name: Notification.Name(""), object: nil)
    }
    
    
    func saveObject<T:Object>(object: T) {
           let realm = try! Realm()
           try! realm.write {
               realm.add(object)
        
           }
       }
   func getObjects<T:FoodRealm>()->[T] {
           let realm = try! Realm()
       let realmResults = realm.objects(T.self)
           return Array(realmResults)

       }
    func getObjects<T:Object>(filter:String)->[T] {
           let realm = try! Realm()
           let realmResults = realm.objects(T.self).filter(filter)
           return Array(realmResults)

       }
    
}

