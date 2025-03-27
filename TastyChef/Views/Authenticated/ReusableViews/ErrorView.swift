//
//  ErrorView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.red)
            
            Text("Oops! Something went wrong")
                .font(.headline)
            
            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Button(action: retryAction) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                }
                .foregroundColor(.white)
                .padding()
                .background(Color("colorPrimary"))
                .cornerRadius(10)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ErrorView(error: WebServiceError.invalidURL, retryAction: { })
}
