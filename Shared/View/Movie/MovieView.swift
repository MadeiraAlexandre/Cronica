//
//  HomeView.swift
//  Story
//
//  Created by Alexandre Madeira on 16/01/22.
//

import SwiftUI

struct MovieView: View {
    @StateObject private var viewModel = MovieViewModel()
    static let tag: String? = "Movie"
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(viewModel.sections) {
                        HorizontalMovieListView(style: $0.style,
                                           title: $0.title,
                                           movies: $0.results) 
                    }
                }
                .task {
                    load()
                }
            }
            .navigationTitle("Movies")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "person")
                            .padding(.horizontal)
                            
                    }
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    @Sendable
    private func load() {
        Task {
            await viewModel.loadAllEndpoints()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView()
    }
}
