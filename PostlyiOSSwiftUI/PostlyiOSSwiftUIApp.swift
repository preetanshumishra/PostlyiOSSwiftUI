//
//  PostlyiOSSwiftUIApp.swift
//  PostlyiOSSwiftUI
//
//  Created by Preetanshu Mishra on 2026-06-06.
//

import SwiftUI

@main
struct PostlyiOSSwiftUIApp: App {

    private let container: DependencyContainerProtocol
    private let coordinator: AppCoordinator

    init() {
        let networkService = NetworkService()
        let imageLoaderService = ImageLoaderService()
        container = DependencyContainer(
            networkService: networkService,
            imageLoaderService: imageLoaderService
        )
        coordinator = AppCoordinator()
    }

    var body: some Scene {
        WindowGroup {
            RootView(container: container, coordinator: coordinator)
        }
    }
}
