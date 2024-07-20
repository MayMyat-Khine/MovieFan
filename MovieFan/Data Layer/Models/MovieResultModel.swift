//
//  MovieModel.swift
//  MovieFan
//
//  Created by Khine Myat on 18/07/2024.
//

import Foundation

struct MovieResultModel: Codable {
    let page: Int
    let movies: [MovieModel]

    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
    }
}

struct MovieModel: Codable, Identifiable, Hashable {
    enum Constants {
        static let baseImageUrl = "http://image.tmdb.org/t/p/"
        static let logoSize = "w500"
    }

    let id: Int
    let name: String
    let imgUrlSuffix: String
    let releaseDate: String
    let overview: String

    private func getImage() -> String {
        return "\(Constants.baseImageUrl)\(Constants.logoSize)\(imgUrlSuffix)"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
        case overview
        case releaseDate = "release_date"
        case imgUrlSuffix = "poster_path"
    }
}
