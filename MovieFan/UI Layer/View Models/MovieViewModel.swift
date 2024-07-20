//
//  MovieViewModel.swift
//  MovieFan
//
//  Created by Khine Myat on 18/07/2024.
//

import Foundation

class MovieViewModel: ObservableObject {
    @Published private(set) var movies: [MovieModel] = []
    @Published private(set) var error: DataError?

    private let apiService: MovieAPILogic

    init(apiService: MovieAPILogic = MovieApiImpl()) {
        self.apiService = apiService
    }

    func getMovies() {
        apiService.getMovies { result in
            switch result {
            case .success(let moviesData):
                self.movies = moviesData ?? []
            case .failure(let errorData):
                self.error = errorData
            }
        }
    }
}
