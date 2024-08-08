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
    private var movieCDFetchRequest: NSFetchRequest<MovieCD> = MovieCD.fetchRequest()
    @Published private(set) var movies: [MovieModel]?
    @Published private(set) var moviesRatings: [MovieRatingModel] = []
    @Published private(set) var error: DataError?

    private let apiService: MovieAPILogic

    init(apiService: MovieAPILogic = MovieApiImpl()) {
        self.apiService = apiService
        // --- start monitoring the connectin ----//
        networkConnectivity.start(queue: DispatchQueue.global(qos: .userInitiated))
    }

    func getMovies() {
        switch networkConnectivity.currentPath.status {
        case .satisfied: // connection internet
            apiService.getMovies { result in
                switch result {
                case .success(let moviesData):
                    self.movies = moviesData ?? []
                    // 0. prepare incoming server side movie ids and dictionary
                    var moviesIDDict: [Int: MovieModel] = [:]
                    var moviesIDList: [Int] = []
                    if let movies = self.movies {
                        for movie in movies {
                            moviesIDDict[movie.id] = movie
                            moviesIDList.append(movie.id)
                        }
//                        moviesIDList = movies.map { $0.id }

                        // 1. get all movies that match incoming server side  movie ids
                        // find any existing movies in our Local CoreData

                        self.movieCDFetchRequest.predicate = NSPredicate(format: "id IN %@", moviesIDList)

                        // 2. make a fetch request using predicate
                        let managedObjectContext = self.persistentController.persistentContainer.viewContext

                        let movieCDList = try? managedObjectContext.fetch(self.movieCDFetchRequest)
                        print("MovieCD List \(movieCDList)")

                        // 3. update all matching movies to have the same data
                        guard let movieCDList = movieCDList else { return }

                        var movieIDListInCD: [Int] = []

                        for movieCD in movieCDList {
                            movieIDListInCD.append(Int(movieCD.id))
                            let movie = moviesIDDict[Int(movieCD.id)]
                            movieCD.setValue(movie?.overview, forKey: "overview")
                            movieCD.setValue(movie?.releaseDate, forKey: "releaseDate")
                            movieCD.setValue(movie?.imgUrlSuffix, forKey: "imgUrlSuffix")
                            movieCD.setValue(movie?.name, forKey: "name")
                        }
                        // 4. add new objects coming from backend/server side
                        for movie in movies {
                            if !movieIDListInCD.contains(movie.id) {
                                let movieCD = MovieCD(context: managedObjectContext)
                                movieCD.name = movie.name
                                movieCD.id = Int64(movie.id)
                                movieCD.releaseDate = movie.releaseDate
                                movieCD.imgUrlSuffix = movie.imgUrlSuffix
                                movieCD.overview = movie.overview
                            }
                        }
                        // 5. save changes
                        try? managedObjectContext.save()
                    }
                case .failure(let errorData):
                    self.error = errorData
                }
            }

        default:
            // TODO: add core data fetch
            do {
                let movieCDList = try persistentController.persistentContainer.viewContext.fetch(movieCDFetchRequest)
                print("MovieCD list \(movieCDList)")
                var convertedMovies: [MovieModel] = []
                for movieCD in movieCDList {
                    let movie = MovieModel(id: Int(movieCD.id) ?? 1, name: movieCD.name ?? "", imgUrlSuffix: movieCD.imgUrlSuffix ?? "", releaseDate: movieCD.releaseDate ?? "", overview: movieCD.overview ?? "")
                    convertedMovies.append(movie)
                }

                movies = convertedMovies

            } catch {
                print("Could not Fetch Core Data For Movies")
            }
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
