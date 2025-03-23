//
//  SearchView.swift
//  Movies
//
//  Created by Nick Sinklier on 3/22/25.
//

import SwiftUI

struct SearchView: View {
    @State var searchText: String = ""
    @Namespace private var namespace
    
    var body: some View {
        VStack {
            results
                .padding(.top, 40)
            Text("This is not hooked up yet 🥺")
                .padding()
        }
        .searchable(text: $searchText, prompt: "Search movies")
        .padding(.top, 80)
        .background(Color.gray.opacity(0.1))
        .focusScope(namespace)
    }
    
    private var results: some View {
        Text("No results found for \"\(searchText)\"")
    }
}

#Preview {
    SearchView()
}

class SearchViewModel: ObservableObject {
    
}

protocol SearchServiceWorkerProtocol {
    
}

class SearchServiceWorker {
    
}
