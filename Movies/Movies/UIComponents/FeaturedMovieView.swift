//
//  FeaturedMovieView.swift
//  Movies
//
//  Created by Nick Sinklier on 3/5/25.
//

import SwiftUI

struct FeaturedMovieView: View {
    let movie: Movie
    @State var isDisplayingDetails = false
    
    var body: some View {
        ZStack {
            backdropImage
            VStack(alignment: .leading, spacing: 30) {
                title
                
                Spacer()
                
                HStack {
                    detailsButton
                        .padding(.trailing, 100)
                    overview
                        .frame(alignment: .center)
                    Spacer(minLength: 150)
                }
                .padding(.bottom, 130)
            }
            .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var backdropImage: some View {
        AsyncImage(url: movie.backdropImageURL) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            }
        }
    }
    
    var title: some View {
        Text(movie.title)
            .font(.largeTitle)
            .bold()
            .padding(200)
    }
    
    var detailsButton: some View {
        Button("Details") {
            isDisplayingDetails.toggle()
        }
        .fullScreenCover(isPresented: $isDisplayingDetails) { MovieDetailsView(movie: movie) }
        .cornerRadius(80)
        .padding(.leading, 200)
    }
    
    var overview: some View {
        Text(movie.overview)
            .multilineTextAlignment(.leading)
            .lineLimit(5)
            .frame(width: 800, height: 200, alignment: .center)
    }
}

#Preview {
    FeaturedMovieView(movie: .mock)
}
