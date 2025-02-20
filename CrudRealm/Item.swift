



import Foundation
import RealmSwift

class Item: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var email: String
    @Persisted var createdAt: Date
    
    override init() {
        super.init()
        self.createdAt = Date()
    }
    
    convenience init(name: String, email: String) {
        self.init()
        self.name = name
        self.email = email
    }
}

