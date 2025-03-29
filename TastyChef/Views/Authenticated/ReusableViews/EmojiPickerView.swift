//
//  EmojiPickerView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/29/25.
//


import SwiftUI

struct EmojiPickerView: View {
    @Binding var selectedEmoji: String
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = SettingsViewModel(authManager: AuthenticationManager())
    let onSave: () -> Void
    
    let columns = [
        GridItem(.adaptive(minimum: 60))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(vm.emojiOptions, id: \.self) { emoji in
                        Button {
                            selectedEmoji = emoji
                            onSave()
                        } label: {
                            Text(emoji)
                                .font(.system(size: 40))
                                .padding(10)
                                .background(
                                    Circle()
                                        .fill(selectedEmoji == emoji ? Color.green.opacity(0.2) : Color.clear)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(selectedEmoji == emoji ? Color.green : Color.clear, lineWidth: 2)
                                )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Profile Emoji")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}