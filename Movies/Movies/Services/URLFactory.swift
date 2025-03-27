//
//  URLFactory.swift
//  Movies
//
//  Created by Nick Sinklier on 3/5/25.
//

import Foundation

protocol URLFactoryProtocol {
    func makePopularMoviesURL() -> URL?
    func makeTopRatedMoviesURL() -> URL?
    func makeComingSoonMoviesURL() -> URL?
    func makeMovieSearchURL(query: String, page: Int) -> URL?
}

struct URLFactory: URLFactoryProtocol {
    func makePopularMoviesURL() -> URL? {
        URL(string: API.baseURL + API.discoverURL + "?" + API.apiKey + "&" + API.sortByPopularity)
    }
    
    func makeTopRatedMoviesURL() -> URL? {
        URL(string: API.baseURL + API.discoverURL + "?" + API.apiKey + "&" + API.sortByRating + "&" + API.locale)
    }
    
    func makeComingSoonMoviesURL() -> URL? {
        URL(string: API.baseURL + API.comingSoon + "?" + API.apiKey + "&" + API.locale)
    }
    
    func makeMovieSearchURL(query: String, page: Int) -> URL? {
        URL(string: API.baseURL + API.searchURL + "?" + API.apiKey + "&page=\(page)&" + "include_adult=false&" + "language=en-US&" + "sort_by=popularity.desc" + "&" + API.searchQuery + query)
    }
}
