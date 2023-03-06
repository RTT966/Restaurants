//
//  storageManager.swift
//  tableViewApp
//
//  Created by Рустам Т on 2/10/23.
//

import RealmSwift

let realm = try! Realm()


class Storage{
    
    static func addNewPlace (_ place: Place){
        try! realm.write{
            realm.add(place)
        }
    }
}
