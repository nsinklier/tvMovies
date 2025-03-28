//
//  PosterView.swift
//  Movies
//
//  Created by Nick Sinklier on 3/7/25.
//

import SwiftUI

/// This View shows the movie poster image and navigates to a details View when tapped.
/// - Parameter movie: This movie is used to populate this View as well as the details View it navigates to.
struct PosterView: View {
    let movie: Movie
    
    @State private var isShowingDetails = false
    
    var body: some View {
        Button {
            isShowingDetails.toggle()
        } label: {
            AsyncImage(url: movie.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(0.67, contentMode: .fill)
            } placeholder: {}
        }
        .buttonStyle(.borderless)
        .sheet(isPresented: $isShowingDetails) {
            MovieDetailsView(movie: movie)
        }
    }
}

#Preview {
    PosterView(movie: .mock)
        .frame(width: 400)
}
