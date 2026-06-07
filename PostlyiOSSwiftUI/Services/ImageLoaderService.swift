//
//  ImageLoaderService.swift
//  PostlyiOSSwiftUI
//
//  Created by Preetanshu Mishra on 2026-06-06.
//

import Foundation
import UIKit

protocol ImageLoaderServiceProtocol: Sendable {
    func loadImage(from urlString: String) async -> UIImage?
}

final class ImageLoaderService: ImageLoaderServiceProtocol, @unchecked Sendable {

    private let session: URLSession
    private let cache = NSCache<NSString, UIImage>()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func loadImage(from urlString: String) async -> UIImage? {
        let key = urlString as NSString
        if let cached = cache.object(forKey: key) {
            return cached
        }

        guard let url = URL(string: urlString) else {
            return nil
        }

        do {
            let (data, _) = try await session.data(from: url)
            guard let image = UIImage(data: data) else {
                return nil
            }
            cache.setObject(image, forKey: key)
            return image
        } catch {
            return nil
        }
    }
}
