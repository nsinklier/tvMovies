//
//  SearchView.swift
//  Movies
//
//  Created by Nick Sinklier on 3/22/25.
//

import SwiftUI
import SwiftUIMasonry

struct SearchView: View {
    @Namespace private var namespace
    @ObservedObject var viewModel: SearchViewModel
    private let columns = Array(repeating: GridItem(.flexible()), count: 5)
    
    var body: some View {
        ScrollView {
            LazyVStack {
                Masonry(.vertical, lines: 5, spacing: 30) {
                    ForEach(viewModel.movies) { movie in
                        PosterView(movie: movie)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.4)
                            }
                    }
                }
                
                Spacer(minLength: 120)
                    .onAppear {
                        Task {
                            if !viewModel.movies.isEmpty {
                                await viewModel.loadNextPage()
                            }
                        }
                    }
            }
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(.keyboard)
        .searchable(text: $viewModel.searchText, prompt: "Search movies")
        .padding(.top, 10)
        .background(Color.gray.opacity(0.1))
    }
}

#Preview {
    SearchFactory.makeView()
}

class SearchFactory {
    static func makeView() -> SearchView {
        SearchView(viewModel: makeViewModel())
    }
    
    static func makeViewModel() -> SearchViewModel {
        SearchViewModel(serviceWorker: makeServiceWorker(), urlFactory: makeURLFactory())
    }
    
    static func makeServiceWorker() -> ServiceWorkerProtocol {
        ServiceWorker()
    }
    
    static func makeURLFactory() -> URLFactoryProtocol {
        URLFactory()
    }
}

class SearchViewModel: ObservableObject {
    @Published var searchText: String = "" {
        didSet {
            Task { @MainActor in
                self.pageNumber = 1
                await loadMovies()
            }
        }
    }
    
    @Published var movies: [Movie] = []
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
        Task { @MainActor in
            guard let nextPage = try? await serviceWorker.fetchMovies(for: urlFactory.makeMovieSearchURL(query: searchText, page: pageNumber)) else { return }
            self.movies.append(contentsOf: nextPage)
            self.pageNumber += 1
        }
    }
}
