//
//  NutritionLabelView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/27/25.
//

import SwiftUI
import WebKit

struct NutritionLabelView: UIViewRepresentable {
    let recipeID: Int
    @ObservedObject var viewModel: RecipeDetailViewModel
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false 

        let config = webView.configuration
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        
        Task {
            await viewModel.getRecipeNutritionLabel(recipeId: recipeID)
            if let html = viewModel.nutritionLabelHTML {
                // Add viewport meta tag for proper scaling
                let wrappedHtml = """
                    <html>
                    <head>
                        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'>
                        <style>
                            body { 
                                margin: 0; 
                                padding: 0; 
                                background-color: transparent;
                            }
                        </style>
                    </head>
                    <body>
                        \(html)
                    </body>
                    </html>
                    """
                webView.loadHTMLString(wrappedHtml, baseURL: nil)
            }
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let html = viewModel.nutritionLabelHTML {
            let wrappedHtml = """
                <html>
                <head>
                    <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'>
                    <style>
                        body { 
                            margin: 0; 
                            padding: 0; 
                            background-color: transparent;
                        }
                    </style>
                </head>
                <body>
                    \(html)
                </body>
                </html>
                """
            uiView.loadHTMLString(wrappedHtml, baseURL: nil)
        }
    }
}

#Preview {
    NutritionLabelView(recipeID: 641166, viewModel: RecipeDetailViewModel(networkManager: NetworkManager()))
}
