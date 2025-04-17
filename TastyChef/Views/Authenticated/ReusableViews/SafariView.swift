//
//  SafariView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 4/17/25.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

#Preview {
    SafariView(url: URL(string: "https://www.google.com")!)
}


//Text("View Original Recipe")
//    .font(.caption)
//    .foregroundStyle(Color("colorPrimary"))
//    .onTapGesture {
//        $showSafari.toggle()
//    }
//    .sheet(isPresented: $showSafari) {
//                SafariView(url: URL(string: "https://www.apple.com")!)
//            }
