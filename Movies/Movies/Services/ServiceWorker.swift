//
//  ServiceWorker.swift
//  Movies
//
//  Created by Nick Sinklier on 3/5/25.
//

import Foundation

protocol ServiceWorkerProtocol {
    func fetchMovies(for url: URL?) async throws -> [Movie]
}

struct ServiceWorker: ServiceWorkerProtocol {
    func fetchMovies(for url: URL?) async throws -> [Movie] {
        guard let url else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let model = try JSONDecoder().decode(MovieResponseModel.self, from: data)
        
        return model.results
    }
}

struct MovieResponseModel: Decodable {
    let results: [Movie]
}
