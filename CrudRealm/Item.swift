import Foundation
import RealmSwift

class Item: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var email: String
    
    convenience init(name: String, email: String) {
        self.init()
        self.name = name
        self.email = email
    }
}

// End of file. No additional code.
