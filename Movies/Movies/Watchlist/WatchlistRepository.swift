//
//  WatchlistRepository.swift
//  Movies
//
//  Created by Nick Sinklier on 4/17/25.
//

import Foundation
import Combine

struct WatchlistMovie: Identifiable, Codable, Hashable {
    var id: Int { movie.id }
    let movie: Movie
    let timestamp: Date
    
    init(movie: Movie, timestamp: Date = Date.now) {
        self.movie = movie
        self.timestamp = timestamp
    }
    
    static func == (lhs: WatchlistMovie, rhs: WatchlistMovie) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class WatchlistRepository: ObservableObject {
    private var cache: WatchlistCacheProtocol
    @Published var watchlistIDs: Set<Int> = []
    @Published var movies: Set<WatchlistMovie> = []
    
    static var shared = WatchlistRepository()
    
    init(cache: WatchlistCacheProtocol = WatchlistCache()) {
        self.cache = cache
        Task {
            movies = await self.cache.load()
            watchlistIDs = Set(movies.map { $0.id })
        }
    }
    
    @MainActor
    func refresh() async {
        movies = await cache.load()
        watchlistIDs = Set(movies.map { $0.id })
    }
    
    @MainActor
    func add(_ movie: Movie) async throws {
        movies = await cache.add(WatchlistMovie(movie: movie))
        watchlistIDs = Set(movies.map { $0.id })
    }
    
    @MainActor
    func remove(_ movieId: Int) async throws {
        movies = await cache.remove(movieId)
        watchlistIDs = Set(movies.map { $0.id })
    }
}

protocol WatchlistCacheProtocol {
    func load() async -> Set<WatchlistMovie>
    func add(_ movie: WatchlistMovie) async -> Set<WatchlistMovie>
    func remove(_ movieId: Int) async -> Set<WatchlistMovie>
    func update(_ movies: Set<WatchlistMovie>) async -> Set<WatchlistMovie>
}

actor WatchlistCache: WatchlistCacheProtocol {
    private let key = "watchlist"
    
    func load() -> Set<WatchlistMovie> {
        getMovies()
    }
    
    func add(_ movie: WatchlistMovie) -> Set<WatchlistMovie> {
        var movies = getMovies()
        movies.insert(movie)
        return update(movies)
    }
    
    func remove(_ movieId: Int) -> Set<WatchlistMovie> {
        let movies = getMovies().filter { $0.id != movieId }
        do {
            let data = try JSONEncoder().encode(movies)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
        return movies
    }
    
    func update(_ movies: Set<WatchlistMovie>) -> Set<WatchlistMovie> {
        do {
            let data = try JSONEncoder().encode(movies)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
        return movies
    }
    
    private func getMovies() -> Set<WatchlistMovie> {
        guard let data = UserDefaults.standard.data(forKey: key),
              let movies = try? JSONDecoder().decode(Set<WatchlistMovie>.self, from: data)
        else {
            return []
        }
        return movies
    }
}
