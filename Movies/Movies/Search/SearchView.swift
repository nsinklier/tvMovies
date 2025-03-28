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
                        /// This scrollTransition gives focus to the chosen row of content by fading out the other rows.
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.4)
                        }
                }
            }
            .paging(loadNextPage)
        }
        .ignoresSafeArea(.keyboard)
        /// This Searchable viewModifier adds the system search bar to the top of the screen.
        .searchable(text: $viewModel.searchText, prompt: "Search movies")
        .padding(.top, 10)
        .background(Color.gray.opacity(0.1))
    }
}

extension SearchView {
    private func loadNextPage() {
        Task {
            await viewModel.loadNextPage()
        }
    }
}

#Preview {
    SearchFactory.makeMockView()
}
