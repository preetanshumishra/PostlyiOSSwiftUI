//
//  DependencyContainer.swift
//  PostlyiOSSwiftUI
//
//  Created by Preetanshu Mishra on 2026-06-06.
//
//  Composition root. Centralizes service creation and builds screens with their
//  view models injected, mirroring the UIKit app's DependencyContainer.
//

import Foundation

@MainActor
protocol DependencyContainerProtocol {
    func makeLoginView(onAuthenticated: @escaping (_ token: String, _ isGuest: Bool) -> Void) -> LoginView
    func makePostListView(token: String, isGuest: Bool, onFinish: @escaping () -> Void) -> PostListView
}

final class DependencyContainer: DependencyContainerProtocol {

    private let networkService: NetworkServiceProtocol
    private let imageLoaderService: ImageLoaderServiceProtocol

    nonisolated init(networkService: NetworkServiceProtocol,
                     imageLoaderService: ImageLoaderServiceProtocol) {
        self.networkService = networkService
        self.imageLoaderService = imageLoaderService
    }

    // MARK: - View Model Factories

    @MainActor
    private func makeLoginViewModel(onAuthenticated: @escaping (_ token: String, _ isGuest: Bool) -> Void) -> LoginViewModel {
        LoginViewModel(networkService: networkService, onAuthenticated: onAuthenticated)
    }

    @MainActor
    private func makePostListViewModel(token: String, isGuest: Bool) -> PostListViewModel {
        PostListViewModel(networkService: networkService, token: token, isGuest: isGuest)
    }

    // MARK: - View Factories

    func makeLoginView(onAuthenticated: @escaping (_ token: String, _ isGuest: Bool) -> Void) -> LoginView {
        LoginView(viewModel: makeLoginViewModel(onAuthenticated: onAuthenticated))
    }

    func makePostListView(token: String, isGuest: Bool, onFinish: @escaping () -> Void) -> PostListView {
        PostListView(
            viewModel: makePostListViewModel(token: token, isGuest: isGuest),
            imageLoaderService: imageLoaderService,
            onFinish: onFinish
        )
    }
}
