//
//  HomeView.swift
//  Movies
//
//  Created by Nick Sinklier on 3/5/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        switch viewModel.state {
        case .loading:
            Text("Loading...")
                .task {
                    viewModel.populate()
                }
        case .loaded(let model):
            content(model)
        case .error(let error):
            Text("Error: \(error)")
        }
    }
    
    func content(_ model: HomeModel) -> some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                FeaturedMovieView(movie: model.featuredMovie)
                blend
                shelves(model)
                    .padding(.top, -150)
            }
        }
        .background {
            AsyncImage(url: model.backgroundImageURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                        .blur(radius: 80, opaque: false)
                }
            }
        }
        .ignoresSafeArea()
    }
    
    var blend: some View {
        Color.black
            .frame(height: 120)
            .blur(radius: 40, opaque: false)
            .padding([.top, .bottom], -90)
    }
    
    func shelves(_ model: HomeModel) -> some View {
        VStack(alignment: .leading, spacing: 30) {
            ShelfView(title: "Most Popular", movies: model.mostPopularMovies)
            ShelfView(title: "Coming Soon", movies: model.comingSoonMovies)
            ShelfView(title: "Top Rated", movies: model.highestRatedMovies)
        }
        .padding(10)
    }
}

#Preview {
    HomeFactory.makeMockView()
}
