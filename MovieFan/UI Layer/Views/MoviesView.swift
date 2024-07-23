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
            Section {
                ForEach(movieVM.movies, id: \.self) { movie in
                    NavigationLink { MovieDetailView(movie: movie)
                    } label: {
                        MovieCardView(movie: movie)
                    }
                }

            } header: {
                Text("Movie Listss")
            }
        }
        .navigationTitle("Movies")
        .onAppear {
            movieVM.getMovies()
        }
    }
}

#Preview {
    MoviesView().environmentObject(MovieViewModel())
}
