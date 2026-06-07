//
//  AppCoordinator.swift
//  PostlyiOSSwiftUI
//
//  Created by Preetanshu Mishra on 2026-06-06.
//
//  Owns the navigation stack and all flow decisions, mirroring the UIKit
//  app's AppCoordinator. Views and view models call back into the coordinator;
//  they never decide navigation themselves.
//

import Foundation

protocol AppCoordinatorProtocol: AnyObject {
    func showPostList(token: String, isGuest: Bool)
    func logout()
}

@Observable
final class AppCoordinator: AppCoordinatorProtocol {

    var path: [Route] = []

    func showPostList(token: String, isGuest: Bool) {
        path.append(.postList(token: token, isGuest: isGuest))
    }

    func logout() {
        path.removeAll()
    }
}
