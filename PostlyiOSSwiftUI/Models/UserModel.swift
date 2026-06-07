//
//  UserModel.swift
//  PostlyiOSSwiftUI
//
//  Created by Preetanshu Mishra on 2026-06-06.
//

import Foundation

struct UserModel: Codable, Equatable {
    let id: Int
    let avatar: String
    let name: String
    let email: String
    let username: String
}
