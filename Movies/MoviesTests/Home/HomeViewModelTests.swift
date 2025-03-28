//
//  HomeViewModelTests.swift
//  MoviesTests
//
//  Created by Nick Sinklier on 3/27/25.
//

import Testing
import Foundation
@testable import Movies

struct HomeViewModelTests {
    @MainActor
    @Test func test_populate_success() async throws {
        let serviceWorkerSpy = ServiceWorkerSpy()
        let sut = HomeViewModel(serviceWorker: serviceWorkerSpy, urlFactory: URLFactoryMock())
        
        #expect(sut.state == .loading)
        
        await sut.populate()
                        
        await #expect(serviceWorkerSpy.fetchCalls.count == 4)
        #expect(sut.state == loadedState)
    }
    
    @MainActor
    @Test func test_populate_failure() async throws {
        let serviceWorkerSpy = ServiceWorkerSpy()
        let sut = HomeViewModel(serviceWorker: serviceWorkerSpy, urlFactory: URLFactoryMock(success: false))
        
        #expect(sut.state == .loading)
        
        await sut.populate()
                        
        await #expect(serviceWorkerSpy.fetchCalls.count == 4)
        #expect(sut.state == .error(URLError(.unknown)))
    }
}

extension HomeViewModelTests {
    var loadedState: HomeViewModelState { .loaded(HomeModel(mostPopularMovies: [],
                                                            familyMovies: [],
                                                            highestRatedMovies: [],
                                                            comingSoonMovies: [],
                                                            featuredMovie: Movie.mock))
    }
}

extension HomeViewModelState: @retroactive Equatable {
    public static func == (lhs: HomeViewModelState, rhs: HomeViewModelState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.loaded(_), .loaded(_)):
            return true
        case (.error(_), .error(_)):
            return true
        default:
            return false
        }
    }
}

actor ServiceWorkerSpy: ServiceWorkerProtocol {
    var fetchCalls = [URL?]()
    
    func fetchMovies(for url: URL?) async throws -> [Movie] {
        fetchCalls.append(url)
        if url == nil { throw URLError(.badServerResponse) }
        
        return Movie.mockArray
    }
}

class URLFactoryMock: URLFactoryProtocol {
    var success: Bool
    
    init(success: Bool = true) {
        self.success = success
    }
    
    func makePopularMoviesURL() -> URL? {
        success ? URL(string: "popular") : nil
    }
    
    func makeFamilyMoviesURL() -> URL? {
        success ? URL(string: "family") : nil
    }
    
    func makeTopRatedMoviesURL() -> URL? {
        success ? URL(string: "topRated") : nil
    }
    
    func makeComingSoonMoviesURL() -> URL? {
        success ? URL(string: "comingSoon") : nil
    }
    
    func makeMovieSearchURL(query: String, page: Int) -> URL? {
        success ? URL(string: "search") : nil
    }
}
