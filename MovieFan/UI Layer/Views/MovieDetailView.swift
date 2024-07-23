//
//  MovieDetailView.swift
//  MovieFan
//
//  Created by Khine Myat on 22/07/2024.
//

import SwiftUI

struct MovieDetailView: View {
    var movie: MovieModel
    var body: some View {
        ScrollView {
            VStack {
                let url = URL(string: movie.getDetailImage())
                AsyncImage(url: url) {
                    image in
                    image.resizable().frame(width: 350, height: 350)
                } placeholder: {
                    Image("themoviedb").resizable().frame(width: 100, height: 100)
                }
                Spacer()
                Text(movie.releaseDate).foregroundColor(.blue)
                Spacer()
                Text(movie.overview).font(.body)
            }
            .accessibilityLabel("Movie Detail")
        }
        .navigationTitle(movie.name)
        .foregroundColor(.green)
        .padding()
    }
}

#Preview {
    MovieDetailView(movie: MovieModel(id: 1, name: "Barbie", imgUrlSuffix: "/2H1TmgdfNtsKlU9jKdeNyYL5y8T.jpg", releaseDate: "2022-02-02", overview: "Lasest Barbie cartoon "))
}
