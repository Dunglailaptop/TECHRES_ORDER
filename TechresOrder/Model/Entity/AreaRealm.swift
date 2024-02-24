//
//  AreaRealm.swift
//  TECHRES-ORDER
//
//  Created by Kelvin on 20/09/2023.
//

import RealmSwift

final class AreaRealm: Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var area_id : Int = 0
    @Persisted var name = String()
    @Persisted var status  : Int = 0
    @Persisted var branch_id  : Int = 0
    @Persisted var is_select : Int = 0
    
 
}
