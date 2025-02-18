//
//  ContentView.swift
//  CrudRealm
//
//  Created by MacMini6 on 18/02/25.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @StateObject private var realmManager = RealmManager()
    @State private var showAlert = false
    @State private var name = ""
    @State private var email = ""
    @State private var editingItem: Item?
    @State private var isEditing = false
    
    var body: some View {
        NavigationStack {
            List(realmManager.items) { item in
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    Text(item.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }.swipeActions {
                    Button(role: .destructive) {
                        realmManager.deleteItem(id: item.id)
                    } label: {
                        Text("Delete")
                    }
                    
                    Button {
                        editingItem = item
                        name = item.name
                        email = item.email
                        isEditing = true
                        showAlert = true
                    } label: {
                        Text("Edit")
                    }.tint(.indigo)
                }
            }
            .navigationTitle("Add Details")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        name = ""
                        email = ""
                        isEditing = false
                        showAlert = true
                    } label: {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.title2)
                    }
                }
            }
            .overlay(
                withAnimation(){
                    showAlert ? CustomAlertView(
                        showAlert: $showAlert,
                        name: $name,
                        email: $email,
                        onSave: {
                            if isEditing {
                                if let item = editingItem {
                                    realmManager.updateItem(id: item.id, name: name, email: email)
                                }
                            } else {
                                realmManager.addItem(name: name, email: email)
                            }
                            name = ""
                            email = ""
                            editingItem = nil
                        }
                
                    ): nil
                   
                }
                
              
            )
        }
    }
}
struct CustomAlertView: View {
    @Binding var showAlert: Bool
    @Binding var name: String
    @Binding var email: String
    var onSave: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Enter Details")
                .font(.headline)
                .padding(.top)
            
            TextField("Enter Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField("Enter Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            HStack {
                Button("Cancel") {
                    showAlert = false
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                
                Button("Save") {
                    onSave()
                    showAlert = false
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .frame(width: 330, height: 300)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .transition(.scale)
    }
}

#Preview {
    ContentView()
}
