//
//  AvatarView.swift
//  PostlyiOSSwiftUI
//
//  Created by Preetanshu Mishra on 2026-06-06.
//
//  Loads an avatar through the shared ImageLoaderService (in-memory cached),
//  reusing the same networking layer as the UIKit app rather than AsyncImage.
//

import SwiftUI

struct AvatarView: View {

    let urlString: String
    let size: CGFloat
    let imageLoaderService: ImageLoaderServiceProtocol

    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .background(Color(.systemGray5).clipShape(Circle()))
        .task(id: urlString) {
            image = await imageLoaderService.loadImage(from: urlString)
        }
    }
}
