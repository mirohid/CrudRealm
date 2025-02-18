import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    private var realm: Realm?
    @Published var items: [Item] = []
    
    init() {
        setupRealm()
    }
    
    private func setupRealm() {
        do {
            realm = try Realm()
            loadItems()
        } catch {
            print("Error initializing Realm: \(error)")
        }
    }
    
    func loadItems() {
        guard let realm = realm else { return }
        
        let realmItems = realm.objects(Item.self)
        items = Array(realmItems)
    }
    
    
    //Add:-----------------------------------------------
    func addItem(name: String, email: String) {
        guard let realm = realm else { return }
        let item = Item(name: name, email: email)
        do {
            try realm.write {
                realm.add(item)
            }
            loadItems()
        } catch {
            print("Error adding item: \(error)")
        }
    }
    
    
    //Update:-----------------------------------------------
    func updateItem(id: ObjectId, name: String, email: String) {
        guard let realm = realm else { return }
        do {
            if let item = realm.object(ofType: Item.self, forPrimaryKey: id) {
                try realm.write {
                    
                    //------------------//
                    item.name = name  //
                    item.email = email //
                    //-------------------//
                }
                loadItems()
            }
        } catch {
            print("Error updating item: \(error)")
        }
    }
    
    
    //Delete:-----------------------------------------------
    func deleteItem(id: ObjectId) {
        guard let realm = realm else { return }
        do {
            if let item = realm.object(ofType: Item.self, forPrimaryKey: id) {
                try realm.write {
                    realm.delete(item)
                }
                loadItems()
            }
        } catch {
            print("Error deleting item: \(error)")
        }
    }
}

// End of file. No additional code.
