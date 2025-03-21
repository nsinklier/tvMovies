//
//  PosterView.swift
//  Movies
//
//  Created by Nick Sinklier on 3/7/25.
//

import SwiftUI

struct PosterView: View {
    let movie: Movie
    
    @State private var isShowingDetails = false
    
    var body: some View {
        Button {
            isShowingDetails.toggle()
        } label: {
            AsyncImage(url: movie.imageURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(0.67, contentMode: .fill)
                    Text(movie.title)
                        .lineLimit(2, reservesSpace: true)
                }
            }
        }
        .buttonStyle(.borderless)
        .sheet(isPresented: $isShowingDetails) {
            MovieDetailsView(movie: movie)
        }
    }
}

#Preview {
    PosterView(movie: .mock)
}
