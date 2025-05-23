//
//  APIComponents.swift
//  Movies
//
//  Created by Nick Sinklier on 3/5/25.
//

struct API {
    static let baseURL = "https://api.themoviedb.org/3/"
    static let discoverPath = "discover/movie"
    static let searchPath = "search/movie"
    static let family = "with_genres=10751"
    static let sortByPopularity = "sort_by=popularity.desc"
    static let sortByRating = "sort_by=vote_average.desc"
    static let latest = "sort_by=release_date.desc"
    static let comingSoon = "movie/upcoming"
    static let locale = "language=en-US"
    static let searchQuery = "query="
    static let imageURL = "https://image.tmdb.org/t/p/w500"
    static let apiKey = "api_key=789a3ad9fb130b33628be0e27eaf57c8"
    static let excludeAdult = "include_adult=false&"
    static let page1 = "page=1"
}
