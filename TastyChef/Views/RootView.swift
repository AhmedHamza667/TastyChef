//
//  RootView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var vm = RootViewModel()
    
    var body: some View {
        Group {
            if vm.isAuthenticated {
                TabBarView()
            } else {
                LandingPage()
            }
        }
        .onAppear {
            vm.checkAuthState()
        }
    }
}
#Preview {
    RootView()
}
