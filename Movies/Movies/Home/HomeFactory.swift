//
//  HomeFactory.swift
//  Movies
//
//  Created by Nick Sinklier on 3/5/25.
//

struct HomeFactory {
    static func makeView() -> HomeView {
        HomeView(viewModel: makeViewModel())
    }
    
    static func makeViewModel() -> HomeViewModel {
        HomeViewModel(serviceWorker: makeServiceWorker(), urlFactory: makeURLFactory())
    }
    
    static func makeServiceWorker() -> ServiceWorkerProtocol {
        ServiceWorker()
    }
    
    static func makeURLFactory() -> any URLFactoryProtocol {
        URLFactory()
    }
}

#if DEBUG
import Foundation

extension HomeFactory {
    static func makeMockView() -> HomeView {
        HomeView(viewModel: makeMockViewModel())
    }
    
    static func makeMockViewModel() -> HomeViewModel {
        let mock = HomeViewModel(serviceWorker: makeMockServiceWorker(), urlFactory: makeURLFactory())
        mock.populate()
        return mock
    }
    
    static func makeMockServiceWorker() -> ServiceWorkerProtocol {
        struct Mock: ServiceWorkerProtocol {
            func fetchMovies(for url: URL?) async throws -> [Movie] {
                Movie.mockArray
            }
        }
        
        return Mock()
    }
}
#endif
