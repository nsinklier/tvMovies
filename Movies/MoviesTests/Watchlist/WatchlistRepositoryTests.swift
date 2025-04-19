//
//  WatchlistRepositoryTests.swift
//  MoviesTests
//
//  Created by Nick Sinklier on 4/18/25.
//

import Testing
import Combine
@testable import Movies

struct WatchlistRepositoryTests {
    @MainActor
    @Test func test_refresh_callsCacheLoad() async {
        let cache = CacheSpy()
        let expectedValue: Set<WatchlistMovie> = [WatchlistMovie.mock]
        cache.returnValue = expectedValue
        
        let sut = WatchlistRepository(cache: cache)
        await sut.refresh()
        
        #expect(cache.loadCalls <= 2) // once on init (privately async), once on refresh
        #expect(sut.movies == expectedValue)
    }
    
    @MainActor
    @Test func test_add_callsCacheAdd() async {
        let cache = CacheSpy()
        let movie = WatchlistMovie.mock
        let expectedValue: Set<WatchlistMovie> = [movie]
        cache.returnValue = expectedValue
        
        let sut = WatchlistRepository(cache: cache)
        
        try? await sut.add(movie.movie)
        
        #expect(cache.addCalls == [movie])
        #expect(sut.movies == expectedValue)
    }
    
    @MainActor
    @Test func test_remove_callsCacheAdd() async {
        let cache = CacheSpy()
        let movie = WatchlistMovie.mock
        let expectedValue: Set<WatchlistMovie> = [movie]
        cache.returnValue = expectedValue
        
        let sut = WatchlistRepository(cache: cache)
        
        try? await sut.remove(movie.id)
        
        #expect(cache.removeCalls == [movie.id])
        #expect(sut.movies == expectedValue)
    }
}

class CacheSpy: WatchlistCacheProtocol {
    var returnValue: Set<WatchlistMovie> = []
    var loadCalls = 0
    var addCalls = [WatchlistMovie]()
    var removeCalls = [Int]()
    var updateCalls = [Set<WatchlistMovie>]()
    
    func load() -> Set<WatchlistMovie> {
        loadCalls += 1
        return returnValue
    }
    
    func add(_ movie: WatchlistMovie) -> Set<WatchlistMovie> {
        addCalls.append(movie)
        return returnValue
    }
    
    func remove(_ movieId: Int) -> Set<WatchlistMovie> {
        removeCalls.append(movieId)
        return returnValue
    }
    
    func update(_ movies: Set<WatchlistMovie>) -> Set<WatchlistMovie> {
        updateCalls.append(movies)
        return movies
    }
}

extension WatchlistMovie {
    static var mock: WatchlistMovie { WatchlistMovie(movie: Movie.mock) }
}
