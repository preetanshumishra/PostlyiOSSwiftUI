//
//  PostModel.swift
//  PostlyiOSSwiftUI
//
//  Created by Preetanshu Mishra on 2026-06-06.
//

import Foundation

struct PostModel: Codable, Equatable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
