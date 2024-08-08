//
//  MovieViewModel.swift
//  MovieFan
//
//  Created by Khine Myat on 18/07/2024.
//

import CoreData
import Foundation
import Network

class MovieViewModel: ObservableObject {
    private var persistentController = MoviePersistentController()
    private var networkConnectivity = NWPathMonitor()
    @Published private(set) var movies: [MovieModel]?
    @Published private(set) var moviesRatings: [MovieRatingModel] = []
    @Published private(set) var error: DataError?

    private let apiService: MovieAPILogic

    init(apiService: MovieAPILogic = MovieApiImpl()) {
        self.apiService = apiService
        // --- start monitoring the connectin ----//
//        networkConnectivity.start(queue: DispatchQueue.global(qos: .userInitiated))
    }

    func getMovies() {
        switch networkConnectivity.currentPath.status {
        case .satisfied: // connection internet
            apiService.getMovies { result in
                switch result {
                case .success(let moviesData):
                    self.movies = moviesData ?? []
                    self.persistentController.updateAndAddServerDataToCoreData(moviesFromServer: self.movies)

                case .failure(let errorData):
                    self.error = errorData
                }
            }

        default:
            // TODO: add core data fetch
            movies = persistentController.fetchFromCoreData()
        }
    }

    func getMovieRatingVoteAverage() -> Double {
        let avgs = moviesRatings.prefix(10).map { $0.voteAvg }
        let sum = avgs.reduce(0, +)
        return sum / 10
    }

    func getMoviesRating() {
        switch networkConnectivity.currentPath.status {
        case .satisfied:
            apiService.getMoviesRating { result in
                switch result {
                case .success(let moviesData):
                    self.moviesRatings = moviesData ?? []
                case .failure(let errorData):
                    self.error = errorData
                }
            }

        default:
            // TODO: core data fetch
            break
        }
    }
}
