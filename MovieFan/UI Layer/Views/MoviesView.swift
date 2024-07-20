//
//  MoviesView.swift
//  MovieFan
//
//  Created by Khine Myat on 18/07/2024.
//

import SwiftUI

struct MoviesView: View {
    @EnvironmentObject var movieVM: MovieViewModel
    var body: some View {
        List { // dun know why use list yet
            ForEach(movieVM.movies, id: \.self) { movie in
                Text(movie.name)
            }
        }

        .onAppear {
            movieVM.getMovies()
        }
    }
}

#Preview {
    MoviesView()
}
