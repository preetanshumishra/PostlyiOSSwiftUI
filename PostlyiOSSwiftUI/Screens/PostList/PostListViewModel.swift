//
//  PostListViewModel.swift
//  PostlyiOSSwiftUI
//
//  Created by Preetanshu Mishra on 2026-06-06.
//

import Foundation

@MainActor
@Observable
final class PostListViewModel {

    struct PostItem: Identifiable {
        let postId: Int
        let userId: Int
        let title: String
        let body: String
        let username: String
        let avatarUrl: String
        let userEmail: String

        var id: Int { postId }
    }

    enum State {
        case loading
        case loaded([PostItem])
        case error(Error)
    }

    private(set) var state: State = .loading

    let isGuest: Bool
    private let networkService: NetworkServiceProtocol
    private let token: String

    init(networkService: NetworkServiceProtocol, token: String, isGuest: Bool) {
        self.networkService = networkService
        self.token = token
        self.isGuest = isGuest
    }

    func loadPosts() async {
        state = .loading
        do {
            async let usersResult = networkService.fetchUsers(token: token)
            async let postsResult = networkService.fetchPosts(token: token)

            let (users, posts) = try await (usersResult, postsResult)

            let userMap = Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })

            let displayItems = posts.compactMap { post -> PostItem? in
                guard let user = userMap[post.userId] else { return nil }

                return PostItem(postId: post.id,
                                userId: post.userId,
                                title: post.title,
                                body: post.body,
                                username: user.username,
                                avatarUrl: user.avatar,
                                userEmail: user.email)
            }

            state = .loaded(displayItems)
        } catch {
            state = .error(error)
        }
    }
}
