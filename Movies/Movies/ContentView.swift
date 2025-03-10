//
//  ContentView.swift
//  Movies
//
//  Created by Nick Sinklier on 3/5/25.
//

import SwiftUI

enum MovieTab: String, Hashable, Identifiable {
    case home = "Home"
    case search = "Search"
    case settings = "Settings"
    
    var id: Self { self }
}

struct ContentView: View {
    @State private var selectedTab: MovieTab = .home
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house", value: .home) {
                HomeFactory.makeView()
            }
            Tab("Search", systemImage: "magnifyingglass", value: .search) {
                Text("Search will go here!")
            }
            Tab("Settings", systemImage: "gearshape", value: .settings) {
                Text("Settings go here!")
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
}
