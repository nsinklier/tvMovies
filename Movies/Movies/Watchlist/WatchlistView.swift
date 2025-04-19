//
//  WatchlistView.swift
//  Movies
//
//  Created by Nick Sinklier on 4/17/25.
//

import SwiftUI
import SwiftUIMasonry

struct WatchlistView: View {
    @EnvironmentObject private var repository: WatchlistRepository
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer(minLength: 80)
                HStack {
                    Spacer(minLength: 30)
                    Masonry(.vertical, lines: 5, spacing: 30) {
                        ForEach(repository.moviesSortedMostRecentlyAdded) { watchlistItem in
                            PosterView(movie: watchlistItem.movie)
                        }
                    }
                    Spacer(minLength: 30)
                }
                Spacer(minLength: 200)
            }
        }
        .ignoresSafeArea(.all)
        .padding(.top, 10)
        .background {
            AsyncImage(url: repository.movies.first?.movie.backdropImageURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .blur(radius: 80, opaque: false)
                }
            }
        }
    }
}

#Preview {
    WatchlistView()
}

private extension WatchlistRepository {
    var moviesSortedMostRecentlyAdded: [WatchlistMovie] {
        Array(self.movies).sorted { $0.timestamp > $1.timestamp }
    }
}
