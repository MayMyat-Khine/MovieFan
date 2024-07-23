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
        static let baseImageUrl = "https://image.tmdb.org/t/p/"
        static let logoSize = "w45"
        static let detailImgSize = "w500"
    }

    let id: Int
    let name: String
    let imgUrlSuffix: String
    let releaseDate: String
    let overview: String

    func getImage() -> String {
        return "\(Constants.baseImageUrl)\(Constants.logoSize)\(imgUrlSuffix)"
    }

    func getDetailImage() -> String {
        return "\(Constants.baseImageUrl)\(Constants.detailImgSize)\(imgUrlSuffix)"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
        case overview
        case releaseDate = "release_date"
        case imgUrlSuffix = "poster_path"
    }
}
