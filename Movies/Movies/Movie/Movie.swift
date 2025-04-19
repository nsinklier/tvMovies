//
//  Movie.swift
//  Movies
//
//  Created by Nick Sinklier on 3/5/25.
//

import Foundation

public struct Movie: Identifiable, Codable {
    public let id: Int
    public let title: String
    public let overview: String
    private let posterPath: String?
    private let backdropPath: String?
    
    public var imageURL: URL? {
        guard let path = posterPath else { return backdropImageURL }
        return URL(string: API.imageURL + path)
    }
    
    public var backdropImageURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: API.imageURL + path)
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

#if DEBUG
extension Movie {
    public static var mock: Movie {
        .init(
            id: UUID().hashValue,
            title: "Fantastic Mr. Fox",
            overview: "This is the story of Mr. Fox (George Clooney) and his wild ways of hen heckling, turkey taking, and cider sipping, nocturnal, instinctive adventures. He has to put his wild days behind him and do what fathers do best: be responsible. He is too rebellious. He is too wild. He is going to try \"just one more raid\" on the three nastiest, meanest farmers that are Walter Boggis (Robin Hurlstone), Nathan Bunce (Hugo Guinness), and Franklin Bean (Sir Michael Gambon). It is a tale of crossing the line of family responsibilities and midnight adventure and the friendships and awakenings of this country life that is inhabited by Fantastic Mr. Fox and his friends.",
            posterPath: "/njbTizADSZg4PqeyJdDzZGooikv.jpg",
            backdropPath: "/qU4HDNKv7gjdlvMu74r70rISPwn.jpg")
    }
    
    public static var mockArray: [Movie] {
        [.mock,
         Movie(
            id: UUID().hashValue,
            title: "The Grand Budapest Hotel",
            overview: "",
            posterPath: "/eWdyYQreja6JGCzqHWXpWHDrrPo.jpg",
            backdropPath: "cIH7Yhml7hTweIB0RwOziURMubR.jpg"
         ),
         Movie(
            id: UUID().hashValue,
            title: "Isle of Dogs",
            overview: "",
            posterPath: "/rSluCePdXXtNiQeE6Na5yRGamhL.jpg",
            backdropPath: "/LXyh4u5v0vVRqs6gsD0QmN4Fvx.jpg"
         ),
         Movie(
            id: UUID().hashValue,
            title: "The Royal Tenenbaums",
            overview: "",
            posterPath: "/syaECBy6irxSgeF0m5ltGPNTWXL.jpg",
            backdropPath: "/pihQ7BDQdYI9tWTZZYlq9H3rCbJ.jpg"
         ),
         Movie(
            id: UUID().hashValue,
            title: "Rushmore",
            overview: "",
            posterPath: "/hSJ6swahAuZ8wM96lHDTwQPXUvZ.jpg",
            backdropPath: "/yHlFaLTQi5MB2nI2z5F5rlHhUN.jpg"
         ),
         Movie(
            id: UUID().hashValue,
            title: "The Life Aquatic",
            overview: "",
            posterPath: "/sV1fDLNWHcA4HSJcIPpzDh1qNxL.jpg",
            backdropPath: "/seNkyFw8AQjDD0chYIaZmtxtdUt.jpg"
         ),
         Movie(
            id: UUID().hashValue,
            title: "Moonrise Kingdom",
            overview: "",
            posterPath: "/xrziXRHRQ7c7YLIehgSJY8GQBsx.jpg",
            backdropPath: "/tqoIZNaiKBRhyBZXu9G52jBMkwg.jpg"
         ),
         Movie(
            id: UUID().hashValue,
            title: "The French Dispatch",
            overview: "",
            posterPath: "/cmp97NR0qFqaxSXSeEjHOTTU42Z.jpg",
            backdropPath: "/j1FoLl0mh9tcKdcxsa30mqJMqwp.jpg"
         ),
         Movie(
            id: UUID().hashValue,
            title: "Asteroid City",
            overview: "In an American desert town circa 1955, the itinerary of a Junior Stargazer/Space Cadet convention is spectacularly disrupted by world-changing events.",
            posterPath: "/rAkz95CREc3A1qTnwlSQ0jh8Zw8.jpg",
            backdropPath: "/1IcjEKEUvdx7fqt4i0UOyLV8lvE.jpg"
         )
        ]
    }
}
#endif
