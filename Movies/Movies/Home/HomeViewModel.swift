//
//  HomeViewModel.swift
//  Movies
//
//  Created by Nick Sinklier on 3/5/25.
//

import Foundation

enum HomeViewModelState {
    case loading
    case loaded(HomeModel)
    case error(Error)
}

class HomeViewModel: ObservableObject {
    private let serviceWorker: ServiceWorkerProtocol
    private let urlFactory: URLFactoryProtocol
    private var model: HomeModel?
    
    @Published var state: HomeViewModelState = .loading
    
    init(serviceWorker: ServiceWorkerProtocol, urlFactory: URLFactoryProtocol) {
        self.serviceWorker = serviceWorker
        self.urlFactory = urlFactory
    }
    
    func populate() {
        Task { @MainActor in
            do {
                let model = try await makeModel()
                state = .loaded(model)
            } catch {
                state = .error(error)
            }
        }
    }
    
    private func makeModel() async throws -> HomeModel {
        guard let model = await withTaskGroup(of: (name: String, movies: [Movie]?).self, returning: HomeModel?.self, body: { taskGroup in
            taskGroup.addTask { ("popular", try? await self.serviceWorker.fetchMovies(for: self.urlFactory.makePopularMoviesURL())) }
            taskGroup.addTask { ("rated", try? await self.serviceWorker.fetchMovies(for: self.urlFactory.makeTopRatedMoviesURL())) }
            taskGroup.addTask { ("upcoming", try? await self.serviceWorker.fetchMovies(for: self.urlFactory.makeComingSoonMoviesURL())) }
            
            var results = [String: [Movie]]()
            
            for await result in taskGroup {
                results[result.name] = result.movies
            }
            
            guard
                let popularMovies = results["popular"],
                let highestRatedMovies = results["rated"],
                let comingSoonMovies = results["upcoming"],
                let featuredMovie = popularMovies.first
            else {
                return nil
            }
            
            return HomeModel(mostPopularMovies: popularMovies, highestRatedMovies: highestRatedMovies, comingSoonMovies: comingSoonMovies, featuredMovie: featuredMovie)
        })
        else {
            throw URLError(.badServerResponse)
        }
        
        return model
    }
        
}

struct HomeModel: Identifiable {
    let id: String = UUID().uuidString
    let mostPopularMovies: [Movie]
    let highestRatedMovies: [Movie]
    let comingSoonMovies: [Movie]
    let featuredMovie: Movie
    var backgroundImageURL: URL? { featuredMovie.backdropImageURL }
}
