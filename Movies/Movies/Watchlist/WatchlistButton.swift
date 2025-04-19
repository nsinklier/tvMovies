//
//  WatchlistButton.swift
//  Movies
//
//  Created by Nick Sinklier on 4/17/25.
//

import SwiftUI

struct WatchlistButton: View {
    @EnvironmentObject private var repository: WatchlistRepository
    @State private var showAlert: Bool = false
    let movie: Movie
    
    var body: some View {
        Button(action: {
            Task {
                do {
                    if repository.watchlistIDs.contains(movie.id) {
                        try await repository.remove(movie.id)
                    } else {
                        try await repository.add(movie)
                    }
                } catch {
                    showAlert = true
                }
            }
        }, label: {
            repository.watchlistIDs
                .contains(movie.id) ? Image(systemName: "plus.circle.fill") : Image(systemName: "plus.circle")
        })
        .alert("Failed to update watchlist.", isPresented: $showAlert) { Button("OK", role: .cancel) {} }
        .cornerRadius(80)
    }
}

#Preview {
    WatchlistButton(movie: Movie.mock)
        .environmentObject(WatchlistRepository.shared)
}
