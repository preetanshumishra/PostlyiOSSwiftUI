//
//  UserInfoView.swift
//  PostlyiOSSwiftUI
//
//  Created by Preetanshu Mishra on 2026-06-06.
//

import SwiftUI

struct UserInfoData: Identifiable {
    let id = UUID()
    let username: String
    let avatarUrl: String
    let email: String
}

struct UserInfoView: View {

    let data: UserInfoData
    let imageLoaderService: ImageLoaderServiceProtocol

    private var isEmailValid: Bool {
        EmailValidator.isValidDomain(email: data.email)
    }

    var body: some View {
        VStack(spacing: 16) {
            AvatarView(urlString: data.avatarUrl, size: 100, imageLoaderService: imageLoaderService)

            Text(data.username)
                .font(.system(size: 20, weight: .semibold))

            HStack(spacing: 8) {
                Text(data.email)
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)

                if !isEmailValid {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.yellow)
                        .frame(width: 20, height: 20)
                }
            }
        }
        .padding(32)
    }
}
