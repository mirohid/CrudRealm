//import Foundation
//import RealmSwift
//
//class RealmManager: ObservableObject {
//    private var realm: Realm?
//    @Published var items: [Item] = []
//    
//    init() {
//        setupRealm()
//    }
//    
//    private func setupRealm() {
//        do {
//            realm = try Realm()
//            loadItems()
//        } catch {
//            print("Error initializing Realm: \(error)")
//        }
//    }
//    
//    func loadItems() {
//        guard let realm = realm else { return }
//        
//        let realmItems = realm.objects(Item.self)
//        items = Array(realmItems)
//    }
//    
//    //Add:-----------------------------------------------
//    func addItem(name: String, email: String) {
//        guard let realm = realm else { return }
//        let item = Item(name: name, email: email)
//        do {
//            try realm.write {
//                realm.add(item)
//            }
//            loadItems()
//        } catch {
//            print("Error adding item: \(error)")
//        }
//    }
//    
//    
//    //Update:-----------------------------------------------
//    func updateItem(id: ObjectId, name: String, email: String) {
//        guard let realm = realm else { return }
//        do {
//            if let item = realm.object(ofType: Item.self, forPrimaryKey: id) {
//                try realm.write {
//                   
//                    //------------------//
//                    item.name = name  //
//                    item.email = email //
//                    //-------------------//
//                }
//                loadItems()
//            }
//        } catch {
//            print("Error updating item: \(error)")
//        }
//    }
//    
//    
//    //Delete:-----------------------------------------------
//    func deleteItem(id: ObjectId) {
//        guard let realm = realm else { return }
//        do {
//            if let item = realm.object(ofType: Item.self, forPrimaryKey: id) {
//                try realm.write {
//                    realm.delete(item)
//                }
//                loadItems()
//            }
//        } catch {
//            print("Error deleting item: \(error)")
//        }
//    }
//}
//
//// End of file. No additional code.





import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    private var realm: Realm?
    @Published var items: [Item] = []
    
    init() {
        setupRealm()
    }
    
    private func setupRealm() {
        let config = Realm.Configuration(
            schemaVersion: 1, // Increment this when your schema changes
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // For each Item object, initialize createdAt if it's a new property
                    migration.enumerateObjects(ofType: Item.className()) { oldObject, newObject in
                        newObject?["createdAt"] = Date()
                    }
                }
            }
        )
        
        // Tell Realm to use this new configuration
        Realm.Configuration.defaultConfiguration = config
        
        do {
            realm = try Realm()
            loadItems()
            print("Realm file location: \(realm?.configuration.fileURL?.path ?? "Not found")")
        } catch {
            print("Error initializing Realm: \(error)")
        }
    }
    
    func loadItems() {
        guard let realm = realm else { return }
        let realmItems = realm.objects(Item.self)
        items = Array(realmItems)
        print("Loaded items count: \(items.count)")
    }
    
    func addItem(name: String, email: String) {
        guard let realm = realm,
              !name.isEmpty && !email.isEmpty else {
            print("Name or email is empty")
            return
        }
        
        let item = Item()
        item.name = name
        item.email = email
        item.createdAt = Date()
        
        do {
            try realm.write {
                realm.add(item)
                print("Item added successfully")
            }
            loadItems()
        } catch {
            print("Error adding item: \(error)")
        }
    }
    
    func updateItem(id: ObjectId, name: String, email: String) {
        guard let realm = realm,
              !name.isEmpty && !email.isEmpty else { return }
        
        if let item = realm.object(ofType: Item.self, forPrimaryKey: id) {
            do {
                try realm.write {
                    item.name = name
                    item.email = email
                    print("Item updated successfully")
                }
                loadItems()
            } catch {
                print("Error updating item: \(error)")
            }
        }
    }
    
    func deleteItem(id: ObjectId) {
        guard let realm = realm else { return }
        
        if let item = realm.object(ofType: Item.self, forPrimaryKey: id) {
            do {
                try realm.write {
                    realm.delete(item)
                    print("Item deleted successfully")
                }
                loadItems()
            } catch {
                print("Error deleting item: \(error)")
            }
        }
    }
}

// End of file. No additional code.
