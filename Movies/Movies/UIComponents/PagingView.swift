//
//  PagingView.swift
//  Movies
//
//  Created by Nick Sinklier on 3/27/25.
//

import SwiftUI

/// This restructures the given view into a VStack with a Spacer at the bottom that triggers the custom fetch closure.
/// Since the Spacer is below the ever-expanding content, it will always be at the bottom of the incoming data.
/// It appears when you get to the bottom of the content, and initiates the fetch every time it does.
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
    /// This allows for paged data to be populated when you scroll to the bottom of your content.
    /// - Parameter getNextPage: This closure is the custom logic required to trigger the fetching of the next page.
    /// - Note: This should be used on the content inside of your scrollView.
    /// - Returns: This returns a version of your view that includes your paging logic.
    public func paging(_ getNextPage: @escaping () -> Void) -> some View {
        modifier(PagingView(getNextPage))
    }
}
