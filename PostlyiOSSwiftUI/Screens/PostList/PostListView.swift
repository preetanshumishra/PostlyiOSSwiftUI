//
//  PostListView.swift
//  PostlyiOSSwiftUI
//
//  Created by Preetanshu Mishra on 2026-06-06.
//

import SwiftUI

struct PostListView: View {

    @State private var viewModel: PostListViewModel
    private let imageLoaderService: ImageLoaderServiceProtocol
    private let onFinish: () -> Void

    @State private var selectedUser: UserInfoData?
    @State private var showExitAlert: Bool = false

    init(viewModel: PostListViewModel,
         imageLoaderService: ImageLoaderServiceProtocol,
         onFinish: @escaping () -> Void) {
        _viewModel = State(wrappedValue: viewModel)
        self.imageLoaderService = imageLoaderService
        self.onFinish = onFinish
    }

    var body: some View {
        content
            .navigationTitle("Posts")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isGuest {
                        Button("Exit") { showExitAlert = true }
                    } else {
                        Button("Logout") { onFinish() }
                    }
                }
            }
            .task { await viewModel.loadPosts() }
            .sheet(item: $selectedUser) { user in
                UserInfoView(data: user, imageLoaderService: imageLoaderService)
            }
            .alert("Thank you for trialing this app", isPresented: $showExitAlert) {
                Button("OK", role: .cancel) { onFinish() }
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case let .loaded(items):
            List(items) { item in
                PostRowView(item: item, imageLoaderService: imageLoaderService) {
                    selectedUser = UserInfoData(
                        username: item.username,
                        avatarUrl: item.avatarUrl,
                        email: item.userEmail
                    )
                }
            }
            .listStyle(.plain)
        case let .error(error):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                Text(error.localizedDescription)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                Button("Retry") {
                    Task { await viewModel.loadPosts() }
                }
                .buttonStyle(.bordered)
            }
            .padding(32)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
