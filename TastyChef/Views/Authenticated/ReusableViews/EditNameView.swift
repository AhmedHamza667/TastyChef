//
//  EditNameView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/29/25.
//


import SwiftUI

struct EditNameView: View {
    @Binding var displayName: String
    @State private var newName: String = ""
    @Environment(\.dismiss) private var dismiss
    let onSave: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter New Name")) {
                    TextField("Display Name", text: $newName)
                        .autocorrectionDisabled()
                        .onAppear {
                            newName = displayName
                        }
                }
            }
            .navigationTitle("Update Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        displayName = newName
                        onSave()
                    }
                    .disabled(newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}