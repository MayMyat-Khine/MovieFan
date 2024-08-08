//
//  MovieAPI.swift
//  MovieFan
//
//  Created by Khine Myat on 18/07/2024.
//

import Alamofire
import Foundation

typealias movieApiResponse = (Swift.Result<[MovieModel]?, DataError>) -> Void
typealias movieRatingApiResponse = (Swift.Result<[MovieRatingModel]?, DataError>) -> Void

protocol MovieAPILogic {
    func getMovies(completion: @escaping movieApiResponse)
    func getMoviesRating(completion: @escaping movieRatingApiResponse)
}

class MovieApiImpl: MovieAPILogic {
    private enum Constants {
        static let apiKey = "19d8f41b09ef02e5236d07399338869c"

        static let languageLocale = "en-US"
        static let domain = "https://api.themoviedb.org/3"
        static let pageValue = 1
        static let moviePopularUrl = "/movie/popular?api_key=\(apiKey)&language=\(languageLocale)&page=\(pageValue)"
        static let movieRatingUrl = "/movie/top_rated?api_key=\(apiKey)&language=\(languageLocale)&page=\(pageValue)"
    }

    func getMovies(completion: @escaping movieApiResponse) {
        URLCache.shared.removeAllCachedResponses()

        AF.request(Constants.domain + Constants.moviePopularUrl, method: .get, encoding: URLEncoding.default)
            .validate()
            .responseDecodable(of: MovieResultModel.self) { response in
                switch response.result {
                case .success(let movies):
//                    print("Movies \(movies)")
                    completion(.success(movies.movies))
                case .failure(let error):
                    print("Error \(error)")
                    completion(.failure(.networkingError(error.localizedDescription)))
                }
            }
    }

    func getMoviesRating(completion: @escaping movieRatingApiResponse) {
        URLCache.shared.removeAllCachedResponses()

        AF.request(Constants.domain + Constants.movieRatingUrl, method: .get, encoding: URLEncoding.default)
            .validate()
            .responseDecodable(of: MovieRatingResultModel.self) { response in
                switch response.result {
                case .success(let moviesRating):
                    completion(.success(moviesRating.moviesRating))
                case .failure(let error):
                    print("Error \(error)")
                    completion(.failure(.networkingError(error.localizedDescription)))
                }
            }
    }
}
