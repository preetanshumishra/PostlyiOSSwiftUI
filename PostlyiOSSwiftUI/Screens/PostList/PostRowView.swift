//
//  PostRowView.swift
//  PostlyiOSSwiftUI
//
//  Created by Preetanshu Mishra on 2026-06-06.
//

import SwiftUI

struct PostRowView: View {

    let item: PostListViewModel.PostItem
    let imageLoaderService: ImageLoaderServiceProtocol
    let onUserTapped: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Button(action: onUserTapped) {
                AvatarView(urlString: item.avatarUrl, size: 60, imageLoaderService: imageLoaderService)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Button(action: onUserTapped) {
                    Text(item.username)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)

                Text(item.title)
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(2)

                Text(item.body)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
    }
}
