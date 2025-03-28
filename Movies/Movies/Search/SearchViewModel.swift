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
    
    var state: SearchState = .idle
    private var pageNumber: Int = 1
    private let serviceWorker: ServiceWorkerProtocol
    private let urlFactory: URLFactoryProtocol
    
    init(serviceWorker: ServiceWorkerProtocol, urlFactory: URLFactoryProtocol) {
        self.serviceWorker = serviceWorker
        self.urlFactory = urlFactory
    }
    
    @MainActor
    func loadMovies() async {
        guard state != .loading, !searchText.isEmpty  else { return }
        state = .loading
        do {
            let url = urlFactory.makeMovieSearchURL(query: searchText, page: pageNumber)
            self.movies = try await serviceWorker.fetchMovies(for: url)
            state = .loaded
        } catch {
            state = .error(error)
        }
    }
    
    @MainActor
    func loadNextPage() async {
        guard state != .loading, !movies.isEmpty else { return }
        state = .loading
        self.pageNumber += 1
        do {
            let url = urlFactory.makeMovieSearchURL(query: searchText, page: pageNumber)
            let nextPage = try await serviceWorker.fetchMovies(for: url)
            self.movies.append(contentsOf: nextPage)
            state = .loaded
        } catch {
            state = .error(error)
        }
    }
}

enum SearchState: Equatable {
    case idle
    case loading
    case loaded
    case error(Error)
    
    static func == (lhs: SearchState, rhs: SearchState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.loaded, .loaded), (.error(_), .error(_)):
            return true
        default:
            return false
        }
    }
}
