//
//  MovieRatingModel.swift
//  MovieFan
//
//  Created by Khine Myat on 02/08/2024.
//

import Foundation

struct MovieRatingResultModel: Codable {
    let page: Int
    let moviesRating: [MovieRatingModel]

    enum CodingKeys: String, CodingKey {
        case page
        case moviesRating = "results"
    }
}

struct MovieRatingModel: Codable, Identifiable {
    let id: Int
    let title: String
    let popularity: Double
    let voteAvg: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case popularity
        case voteAvg = "vote_average"
        case voteCount = "vote_count"
    }

    func minVote() -> Double {
        return voteAvg / Double.random(in: 2 ... 3)
    }

    func maxVote() -> Double {
        return voteAvg * Double.random(in: 2 ... 3)
    }
}
