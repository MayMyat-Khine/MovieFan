//
//  MovieCard.swift
//  MovieFan
//
//  Created by Khine Myat on 22/07/2024.
//

import SwiftUI

struct MovieCardView: View {
    var movie: MovieModel
    var body: some View {
        VStack {
            HStack {
                Text(movie.name)
                    .font(.headline)
                Spacer()
                let url = URL(string: movie.getImage())
                AsyncImage(url: url) {
                    image in
                    image.scaledToFit()
                } placeholder: {
                    Image("themoviedb").resizable().frame(width: 100, height: 100)
                }
            }
            HStack {
                Text(movie.releaseDate)
                Spacer()
            }

        }.padding()
    }
}

#Preview {
    MovieCardView(movie: MovieModel(id: 1, name: "Barbie", imgUrlSuffix: "/2H1TmgdfNtsKlU9jKdeNyYL5y8T.jpg", releaseDate: "2022-02-02", overview: "Lasest Barbie cartoon "))
}
