//
//  RootView.swift
//  PostlyiOSSwiftUI
//
//  Created by Preetanshu Mishra on 2026-06-06.
//
//  Hosts the NavigationStack driven by the AppCoordinator's path and wires
//  each screen's navigation callbacks back to the coordinator.
//

import SwiftUI

struct RootView: View {

    @State private var coordinator: AppCoordinator
    private let container: DependencyContainerProtocol

    init(container: DependencyContainerProtocol, coordinator: AppCoordinator) {
        self.container = container
        _coordinator = State(wrappedValue: coordinator)
    }

    var body: some View {
        @Bindable var coordinator = coordinator

        return NavigationStack(path: $coordinator.path) {
            container.makeLoginView { token, isGuest in
                coordinator.showPostList(token: token, isGuest: isGuest)
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case let .postList(token, isGuest):
                    container.makePostListView(token: token, isGuest: isGuest) {
                        coordinator.logout()
                    }
                }
            }
        }
    }
}
