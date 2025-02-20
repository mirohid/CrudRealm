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
    @State private var searchText = ""
    
    // Convert to regular array to avoid Realm threading issues
    private var filteredItems: [Item] {
        let items = Array(realmManager.items)
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText) ||
                item.email.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchText)
                
                if filteredItems.isEmpty {
                    ContentUnavailableView("No Contacts",
                        systemImage: "person.crop.circle.badge.exclamationmark",
                        description: Text("Add contacts using the + button"))
                } else {
                    List(filteredItems) { item in
                        ItemRowView(item: item, onEdit: {
                            editingItem = item
                            name = item.name
                            email = item.email
                            isEditing = true
                            showAlert = true
                        }, onDelete: {
                            realmManager.deleteItem(id: item.id)
                        })
                    }
                }
            }
            .navigationTitle("Contacts")
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
                            .foregroundColor(.blue)
                    }
                }
            }
            .alert("Invalid Input", isPresented: .constant(false)) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter both name and email")
            }
            .overlay {
                if showAlert {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .transition(.opacity)
                    
                    CustomAlertView(
                        showAlert: $showAlert,
                        name: $name,
                        email: $email,
                        onSave: {
                            guard !name.isEmpty && !email.isEmpty else { return }
                            
                            if isEditing {
                                if let item = editingItem {
                                    realmManager.updateItem(id: item.id, name: name, email: email)
                                }
                            } else {
                                realmManager.addItem(name: name, email: email)
                                realmManager.loadItems() // Refresh the list
                            }
                            name = ""
                            email = ""
                            editingItem = nil
                            showAlert = false
                        }
                    )
                    .transition(.scale)
                }
            }
        }
    }
}
    // Add this new view
    struct SearchBar: View {
        @Binding var text: String
        
        var body: some View {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }

    // Add this new view
    struct ItemRowView: View {
        let item: Item
        let onEdit: () -> Void
        let onDelete: () -> Void
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(item.name)
                    .font(.headline)
                
                Text(item.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(item.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
            .swipeActions {
                Button(role: .destructive, action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
                
                Button(action: onEdit) {
                    Label("Edit", systemImage: "pencil")
                }
                .tint(.indigo)
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
