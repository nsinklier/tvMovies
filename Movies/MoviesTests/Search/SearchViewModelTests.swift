//
//  SearchViewModelTests.swift
//  MoviesTests
//
//  Created by Nick Sinklier on 3/27/25.
//

import Testing
@testable import Movies
import Foundation

struct SearchViewModelTests {
    @MainActor
    @Test func test_loadMovies_fetchSuccess() async throws {
        let serviceWorkerSpy = ServiceWorkerSpy()
        let urlFactoryMock = URLFactoryMock()
        let sut = SearchViewModel(serviceWorker: serviceWorkerSpy, urlFactory: urlFactoryMock)
        
        sut.searchText = "test"
        await sut.loadMovies()
        
        await #expect(serviceWorkerSpy.fetchCalls.count == 1)
        #expect(sut.state == .loaded)
    }
    
    @MainActor
    @Test func test_loadMovies_noFetchOnEmptyString() async throws {
        let serviceWorkerSpy = ServiceWorkerSpy()
        let urlFactoryMock = URLFactoryMock()
        let sut = SearchViewModel(serviceWorker: serviceWorkerSpy, urlFactory: urlFactoryMock)
        
        await sut.loadMovies()
        
        await #expect(serviceWorkerSpy.fetchCalls.count == 0)
        #expect(sut.state == .idle)
    }
    
    @MainActor
    @Test func test_loadMovies_fetchError() async throws {
        let serviceWorkerSpy = ServiceWorkerSpy()
        let urlFactoryMock = URLFactoryMock(success: false)
        let sut = SearchViewModel(serviceWorker: serviceWorkerSpy, urlFactory: urlFactoryMock)
        
        sut.searchText = "test"
        await sut.loadMovies()
        
        await #expect(serviceWorkerSpy.fetchCalls.count == 1)
        #expect(sut.state == .error(URLError(.unknown)))
    }
    
    @MainActor
    @Test func test_loadNextPage_fetchSuccess() async throws {
        let serviceWorkerSpy = ServiceWorkerSpy()
        let urlFactoryMock = URLFactoryMock()
        let sut = SearchViewModel(serviceWorker: serviceWorkerSpy, urlFactory: urlFactoryMock)
        
        sut.searchText = "test"
        await sut.loadMovies()
        
        await #expect(serviceWorkerSpy.fetchCalls.count == 1)
        
        await sut.loadNextPage()
        
        await #expect(serviceWorkerSpy.fetchCalls.count == 2)
        #expect(sut.state == .loaded)
    }
    
    @MainActor
    @Test func test_loadNextPage_noFetchOnEmptyMovies() async throws {
        let serviceWorkerSpy = ServiceWorkerSpy()
        let urlFactoryMock = URLFactoryMock()
        let sut = SearchViewModel(serviceWorker: serviceWorkerSpy, urlFactory: urlFactoryMock)
        
        await sut.loadNextPage()
        
        await #expect(serviceWorkerSpy.fetchCalls.count == 0)
        #expect(sut.state == .idle)
    }
    
    @MainActor
    @Test func test_loadNextPage_fetchError() async throws {
        let serviceWorkerSpy = ServiceWorkerSpy()
        var urlFactoryMock = URLFactoryMock()
        let sut = SearchViewModel(serviceWorker: serviceWorkerSpy, urlFactory: urlFactoryMock)
        
        sut.searchText = "test"
        await sut.loadMovies()
        
        await #expect(serviceWorkerSpy.fetchCalls.count == 1)
        #expect(sut.state == .loaded)
        
        urlFactoryMock.success = false
        
        await sut.loadNextPage()
        
        await #expect(serviceWorkerSpy.fetchCalls.count == 2)
        #expect(sut.state == .error(URLError(.unknown)))
    }
}
