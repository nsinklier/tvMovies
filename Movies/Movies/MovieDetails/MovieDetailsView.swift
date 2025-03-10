//
//  MovieDetailsView.swift
//  Movies
//
//  Created by Nick Sinklier on 3/6/25.
//

import SwiftUI

struct MovieDetailsView: View {
    let movie: Movie
    
    var body: some View {
        ZStack {
            moviePoster
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    Text(movie.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text(movie.overview)
                        .multilineTextAlignment(.leading)
                }
                .padding(30)
                .background { Color.black.opacity(0.5) }
                .cornerRadius(20)
                
            }
            .padding([.horizontal], 200)
            .padding(.bottom, 50)
        }
    }
    
    var moviePoster: some View {
        AsyncImage(url: movie.backdropImageURL) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    MovieDetailsView(movie: .mock)
}
