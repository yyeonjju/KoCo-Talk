//
//  BaseRealmManager.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/9/25.
//

import Foundation
import RealmSwift

protocol RealmManagerType {
//    associatedtype Item = Object
    
    var realm : Realm { get }

    func checkFileURL()
    func checkSchemaVersion()
    func createItem<M : Object>(_ data : M)
    func getAllObjects<M : Object>(tableModel : M.Type) -> Results<M>?
    func removeItem<M : Object>(_ data : M)
    func editItem<M : Object>(_ data : M.Type, at id : ObjectId ,editKey : String, to editValue : Any)
}


class BaseRealmManager : RealmManagerType {
    var realm = try! Realm()
    
    func checkFileURL() {
        print("🔥 fileURL -> ", realm.configuration.fileURL!)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func checkSchemaVersion() {
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("🔥 version -> ",version)
        }catch {
            print(error)
        }
    }
    
    
    //아이템 추가 Create
    func createItem<M : Object>(_ data : M) {
        do {
            try realm.write{
                realm.add(data)
                print("Realm Create Succeed -> ", getAllObjects(tableModel: M.self)?.last)
            }
        } catch {
            print(error)
        }
    }
    
    //전체 리스트 Read
    func getAllObjects<M : Object>(tableModel : M.Type) -> Results<M>? {
        
        let value =  realm.objects(M.self)
        return value
    }
    
    //아이템 삭제 Delete
    func removeItem<M : Object>(_ data : M) {
        print("❤️removeItem")
        do {
            try realm.write {
                realm.delete(data)
            }
        }catch {
            print(error)
        }
    }
    
    //아이템 수정 Update
    func editItem<M : Object>(_ data : M.Type, at id : ObjectId ,editKey : String, to editValue : Any) {
        do {
            try realm.write{
                realm.create(
                    M.self,
                    value: [
                        "id" : id, //수정할 컬럼
                        editKey : editValue
                    ],
                    update: .modified
                )
            }
        }catch {
            print(error)
        }
        
    }
}


