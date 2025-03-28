//
//  PagingView.swift
//  Movies
//
//  Created by Nick Sinklier on 3/27/25.
//

import SwiftUI

private struct PagingView: ViewModifier {
    private let getNextPage: () -> Void
    
    init(_ getNextPage: @escaping () -> Void) {
        self.getNextPage = getNextPage
    }
    
    func body(content: Content) -> some View {
        LazyVStack {
            content
            Spacer(minLength: 100)
                .onAppear(perform: getNextPage)
        }
    }
}

extension View {
    public func paging(_ getNextPage: @escaping () -> Void) -> some View {
        modifier(PagingView(getNextPage))
    }
}
