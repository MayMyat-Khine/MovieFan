//
//  MoviesView.swift
//  MovieFan
//
//  Created by Khine Myat on 18/07/2024.
//

import Charts
import CoreData
import SwiftUI

struct MoviesView: View {
    @EnvironmentObject var movieVM: MovieViewModel
//    @FetchRequest(sortDescriptors: [
//        // ------ Sorted The Show Data At UI View Directly ----//
//        SortDescriptor(\.name, order: .reverse),
//        SortDescriptor(\.releaseDate)
//    ]) var movieCDList: FetchedResults<MovieCD>
    var body: some View {
        TabView {
            List { // dun know why use list yet
                Section {
                    ForEach(movieVM.movies ?? [], id: \.self) { movie in
//                    ForEach(movieCDList) { movieCD in
//                        let movie = MovieModel(id: Int(movieCD.id), name: movieCD.name ?? "", imgUrlSuffix: movieCD.imgUrlSuffix ?? "", releaseDate: movieCD.releaseDate ?? "", overview: movieCD.overview ?? "")
                        NavigationLink { MovieDetailView(movie: movie)
                        } label: {
                            MovieCardView(movie: movie)
                        }
                    }

                } header: {
                    Text("Movie Lists")
                }
            }
            .tabItem {
                Label("Movies", systemImage: "popcorn.fill")
            }

            Chart {
                ForEach(movieVM.moviesRatings.prefix(15)) {
                    movieRating in
                    //
                    //                    LineMark(x: .value("Movies", movieRating.title),
                    //                             y: .value("Vote Count", movieRating.voteCount))
                    //                        .foregroundStyle(Color.red)
                    //                        //                        .symbol(by: .value("Movies", movieRating.title))
                    //                        .accessibilityLabel(movieRating.title)
                    //                        .accessibilityValue("\(movieRating.voteCount) votes")
                    //                        .interpolationMethod(.stepEnd)
                    //
                    //                    BarMark(x: .value("Movies", movieRating.title),
                    //                            y: .value("Vote Avg", movieRating.voteAvg))
                    //                        .foregroundStyle(by: .value("Movies", movieRating.title))
                    //                        .symbol(by: .value("Movies", movieRating.title))
                    //                        .accessibilityLabel(movieRating.title)
                    //                        .accessibilityValue("\(movieRating.voteAvg)counts")
                    //
                    //                    BarMark(x: .value("Movies", movieRating.title),
                    //                            y: .value("Vote Avg", movieRating.popularity))
                    //                        .foregroundStyle(Color.blue)
                    //                        .symbol(by: .value("Movies", movieRating.title))
                    //                        .accessibilityLabel(movieRating.title)
                    //                        .accessibilityValue("\(movieRating.voteAvg)counts")
                    //                    //////// --- Area Chart Part
                    //                    LineMark(x: .value("Movies", movieRating.title),
                    //                             y: .value("Avg Count", movieRating.voteAvg))
                    //
                    //                    AreaMark(x: .value("Movies", movieRating.title), yStart: .value("Min Value", movieRating.minVote()), yEnd: .value("Max Value", movieRating.maxVote()))
                    //                        .opacity(0.3)
                    /// ---------  Rectangle Chart Part
                    RectangleMark(x: .value("Movies", movieRating.title),
                                  y: .value("Avg Count", movieRating.voteAvg), width: .ratio(0.8), height: 3)

                    BarMark(x: .value("Movies", movieRating.title), yStart: .value("Min Value", movieRating.minVote()), yEnd: .value("Max Value", movieRating.maxVote()), width: .ratio(0.4))
                        .opacity(0.3)
                }.foregroundStyle(.gray.opacity(0.3))
                //// -------- Rule Mark
                RuleMark(
                    y: .value("Average",
                              movieVM.getMovieRatingVoteAverage())
                )
                .lineStyle(StrokeStyle(lineWidth: 2))
                .annotation(position: .top,
                            alignment: .leading)
                {
                    Text("Average:  \(movieVM.getMovieRatingVoteAverage(), format: .number)")
                        .font(.headline)
                        .foregroundStyle(.red)
                }

            }.chartYScale(domain: 0 ... 35)
                .chartYAxis {
                    AxisMarks(preset: .extended, position: .trailing)
                }
                .chartPlotStyle { plot in
                    plot.frame(height: 400).background(.green.opacity(0.1)).border(.pink, width: 1)
                }
                .onAppear {
                    movieVM.getMoviesRating()
                }
                .padding(20)
                .tabItem {
                    Label("Chart", systemImage: "chart.bar")
                }
        }

        .navigationTitle("Movies")
        .onAppear {
            movieVM.getMovies()
            movieVM.getMoviesRating()
        }
//        .onTapGesture {
//            if let movie = movieVM.movies.first {
//                let movieCD = MovieCD(context: managedObjectContext)
//                movieCD.id = Int64(movie.id)
//                movieCD.name = movie.name
//                movieCD.releaseDate = movie.releaseDate
//                movieCD.overview = movie.overview
//                movieCD.getImage = movie.getImage()
//                movieCD.getDetailImage = movie.getDetailImage()
//                movieCD.imgUrlSuffix = movie.imgUrlSuffix
//                try? managedObjectContext.save()
//            }
//        }
    }
}

#Preview {
    MoviesView().environmentObject(MovieViewModel())
}
