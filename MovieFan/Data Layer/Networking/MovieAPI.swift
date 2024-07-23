//
//  MovieAPI.swift
//  MovieFan
//
//  Created by Khine Myat on 18/07/2024.
//

import Alamofire
import Foundation

typealias movieApiResponse = (Swift.Result<[MovieModel]?, DataError>) -> Void
protocol MovieAPILogic {
    func getMovies(completion: @escaping movieApiResponse)
}

class MovieApiImpl: MovieAPILogic {
    private enum Constants {
        static let apiKey = "19d8f41b09ef02e5236d07399338869c"
//        static let apiKey = "9b94de2654d82e14b601cc6143665af"
//        static let apiKey = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxOWQ4ZjQxYjA5ZWYwMmU1MjM2ZDA3Mzk5MzM4ODY5YyIsIm5iZiI6MTcyMTQwNjgyNS4yMDIyMzEsInN1YiI6IjY2OWE5MjA5OTBmY2UwMTFiYTMwNjExMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.U0Q3ZWQd7M0F2qbjKky7AVWiIbknVjA6Qfp6tHcI8TMeyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxOWQ4ZjQxYjA5ZWYwMmU1MjM2ZDA3Mzk5MzM4ODY5YyIsIm5iZiI6MTcyMTQwNjgyNS4yMDIyMzEsInN1YiI6IjY2OWE5MjA5OTBmY2UwMTFiYTMwNjExMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.U0Q3ZWQd7M0F2qbjKky7AVWiIbknVjA6Qfp6tHcI8TM"

        static let languageLocale = "en-US"
        static let domain = "https://api.themoviedb.org/3"
        static let pageValue = 1
        static let moviePopularUrl = "/movie/popular?api_key=\(apiKey)&language=\(languageLocale)&page=\(pageValue)"
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
}
