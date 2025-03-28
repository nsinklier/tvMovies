//
//  SearchFactory.swift
//  Movies
//
//  Created by Nick Sinklier on 3/27/25.
//

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

#if DEBUG
extension SearchFactory {
    static func makeMockView() -> SearchView {
        SearchView(viewModel: makeMockViewModel())
    }
    
    static func makeMockViewModel() -> SearchViewModel {
        let viewModel = SearchViewModel(serviceWorker: MockServiceWorker(), urlFactory: makeURLFactory())
        viewModel.movies = Movie.mockArray
        return viewModel
    }
}
#endif
