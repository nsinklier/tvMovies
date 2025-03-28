//
//  SearchViewModel.swift
//  Movies
//
//  Created by Nick Sinklier on 3/27/25.
//

import Combine

class SearchViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var searchText: String = "" {
        didSet {
            Task { @MainActor in
                self.pageNumber = 1
                await loadMovies()
            }
        }
    }
    
    private var pageNumber: Int = 1
    private let serviceWorker: ServiceWorkerProtocol
    private let urlFactory: URLFactoryProtocol
    
    init(serviceWorker: ServiceWorkerProtocol, urlFactory: URLFactoryProtocol) {
        self.serviceWorker = serviceWorker
        self.urlFactory = urlFactory
    }
    
    func loadMovies() async {
        Task { @MainActor in
            do {
                self.movies = try await serviceWorker.fetchMovies(for: urlFactory.makeMovieSearchURL(query: searchText, page: pageNumber))
            } catch {
                print("Error fetching movies: \(error)")
            }
        }
    }
    
    func loadNextPage() async {
        guard !movies.isEmpty else { return }
        Task { @MainActor in
            self.pageNumber += 1
            guard let nextPage = try? await serviceWorker.fetchMovies(for: urlFactory.makeMovieSearchURL(query: searchText, page: pageNumber)) else { return }
            self.movies.append(contentsOf: nextPage)
        }
    }
}
