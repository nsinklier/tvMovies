//
//  URLFactory.swift
//  Movies
//
//  Created by Nick Sinklier on 3/5/25.
//

import Foundation

protocol URLFactoryProtocol {
    func makePopularMoviesURL() -> URL?
    func makeFamilyMoviesURL() -> URL?
    func makeTopRatedMoviesURL() -> URL?
    func makeComingSoonMoviesURL() -> URL?
    func makeMovieSearchURL(query: String, page: Int) -> URL?
}

struct URLFactory: URLFactoryProtocol {
    func makePopularMoviesURL() -> URL? {
        URL(string: API.baseURL + API.discoverPath + "?" + API.apiKey + "&" + API.sortByPopularity + "&" + API.locale)
    }
    
    func makeFamilyMoviesURL() -> URL? {
        URL(string: API.baseURL + API.discoverPath + "?" + API.excludeAdult + "&" + API.locale + "&" + API.apiKey + "&" + API.sortByPopularity + "&" + API.locale + "&" + API.family)
    }
    
    func makeTopRatedMoviesURL() -> URL? {
        URL(string: API.baseURL + API.discoverPath + "?" + API.apiKey + "&" + API.sortByRating + "&" + API.locale)
    }
    
    func makeComingSoonMoviesURL() -> URL? {
        URL(string: API.baseURL + API.comingSoon + "?" + API.apiKey + "&" + API.locale)
    }
    
    func makeMovieSearchURL(query: String, page: Int) -> URL? {
        URL(string: API.baseURL + API.searchPath + "?" + API.apiKey + "&" + API.searchQuery + query + "&page=\(page)")
    }
}
