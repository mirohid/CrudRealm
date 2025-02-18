//
//  CrudRealmApp.swift
//  CrudRealm
//
//  Created by MacMini6 on 18/02/25.
//

import SwiftUI

@main
struct CrudRealmApp: App {
    var body: some Scene {
        WindowGroup {
            let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
            ContentView()
        }
    }
}
