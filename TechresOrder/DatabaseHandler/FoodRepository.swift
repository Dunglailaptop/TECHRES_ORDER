//
//  FoodRepository.swift
//  TECHRES-ORDER
//
//  Created by Kelvin on 19/09/2023.
//

import RealmSwift
import QRealmManager

class FoodRepository: DatabaseConfigurable {

    var realmMemoryType: RealmMemoryType {
           return .inStorage
        }

        var schemaName: String? {
            return "FoodSchema"
        }

        var schemaVersion: UInt64? {
            0
        }

        var objectTypes: [Object.Type]? {
            return [FoodRealm.self]
        }

        var embeddedObjectTypes: [EmbeddedObject.Type]? {
            return nil
        }

        var migrationBlock: MigrationBlock? {
            return nil
        }
    
}
