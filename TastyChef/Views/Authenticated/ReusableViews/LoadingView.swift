//
//  LoadingView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
                .tint(Color("colorPrimary"))
            Text("Loading recipes...")
                .foregroundColor(.gray)
                .padding(.top)
        }
        .frame(maxWidth: .infinity)
    }
}
#Preview {
    LoadingView()
}
