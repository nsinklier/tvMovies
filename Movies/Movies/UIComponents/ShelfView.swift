//
//  ShelfView.swift
//  Movies
//
//  Created by Nick Sinklier on 3/7/25.
//

import SwiftUI

struct ShelfView: View {
    let title: String
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading) {
            Section(title) {
                scrollingMovies
            }
            .scrollTargetLayout()
        }
    }
    
    var scrollingMovies: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 40) {
                ForEach(movies) { movie in
                    PosterView(movie: movie)
                        .containerRelativeFrame(.horizontal, count: 6, spacing: 40)
                }
            }
        }
        .scrollClipDisabled()
    }
}

#Preview {
    ShelfView(title: "Great Movies", movies: Movie.mockArray)
}
