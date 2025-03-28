//
//  SearchView.swift
//  Movies
//
//  Created by Nick Sinklier on 3/22/25.
//

import SwiftUI
import SwiftUIMasonry

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        ScrollView {
            Masonry(.vertical, lines: 5, spacing: 30) {
                ForEach(viewModel.movies) { movie in
                    PosterView(movie: movie)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.4)
                        }
                }
            }
            .paging(loadNextPage)
        }
        .ignoresSafeArea(.keyboard)
        .searchable(text: $viewModel.searchText, prompt: "Search movies")
        .padding(.top, 10)
        .background(Color.gray.opacity(0.1))
    }
}

extension SearchView {
    func loadNextPage() {
        Task {
            await viewModel.loadNextPage()
        }
    }
}

#Preview {
    SearchFactory.makeView()
}
