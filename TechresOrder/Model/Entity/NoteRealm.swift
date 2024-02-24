//
//  NoteRealm.swift
//  TECHRES-ORDER
//
//  Created by Kelvin on 19/09/2023.
//

import RealmSwift

final class NoteRealm: Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var note_id : Int = 0
    @Persisted var content = String()
    @Persisted var note  = String()
 
}
