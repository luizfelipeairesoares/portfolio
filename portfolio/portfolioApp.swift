//
//  portfolioApp.swift
//  portfolio
//
//

import SwiftUI

@main
struct portfolioApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel())
        }
    }
}
