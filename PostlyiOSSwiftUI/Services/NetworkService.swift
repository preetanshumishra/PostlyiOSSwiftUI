//
//  NetworkService.swift
//  PostlyiOSSwiftUI
//
//  Created by Preetanshu Mishra on 2026-06-06.
//

import Foundation

enum APIError: LocalizedError {
    case invalidEndpoint
    case invalidResponse
    case requestFailed(statusCode: Int)
    case decodeFailure

    var errorDescription: String? {
        switch self {
        case .invalidEndpoint:
            return "The app could not reach the requested API endpoint."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .requestFailed(let statusCode):
            switch statusCode {
            case 400:
                return "The request was invalid. Please review your input and try again."
            case 401:
                return "Authentication failed. Check your credentials and try again."
            case 403:
                return "You do not have permission to access this resource."
            case 404:
                return "The requested resource could not be found."
            case 500...599:
                return "The server encountered an error. Please try again later."
            default:
                return "The request failed with status code \(statusCode)."
            }
        case .decodeFailure:
            return "The app could not read the server response."
        }
    }
}

enum APIEndpoint: String {
    case login = "login"
    case users = "users"
    case posts = "posts"

    func getURL() -> URL? {
        let baseUrlString = "http://192.168.2.56:3005/"
        let urlString = "\(baseUrlString)\(rawValue)"

        return URL(string: urlString)
    }
}

protocol NetworkServiceProtocol {
    func fetchUserToken(username: String, password: String) async throws -> String
    func fetchUsers(token: String) async throws -> [UserModel]
    func fetchPosts(token: String) async throws -> [PostModel]
}

final class NetworkService: NetworkServiceProtocol {

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }

    private func request<T: Decodable>(url: URL, headers: [String: String], responseType: T.Type) async throws -> T {
        var request = URLRequest(url: url)

        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw APIError.requestFailed(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodeFailure
        }
    }

    func fetchUserToken(username: String, password: String) async throws -> String {
        guard let url = APIEndpoint.login.getURL() else {
            throw APIError.invalidEndpoint
        }

        let authString = "\(username):\(password)"
        let encodedAuthData = Data(authString.utf8).base64EncodedString()
        let base64AuthString = "Basic \(encodedAuthData)"
        let response: LoginResponse = try await request(
            url: url,
            headers: ["Authorization": base64AuthString],
            responseType: LoginResponse.self
        )

        return response.apiKey
    }

    func fetchUsers(token: String) async throws -> [UserModel] {
        guard let url = APIEndpoint.users.getURL() else {
            throw APIError.invalidEndpoint
        }

        let response: [UserModel] = try await request(
            url: url,
            headers: ["x-access-token": token],
            responseType: [UserModel].self
        )

        return response
    }

    func fetchPosts(token: String) async throws -> [PostModel] {
        guard let url = APIEndpoint.posts.getURL() else {
            throw APIError.invalidEndpoint
        }

        let response: [PostModel] = try await request(
            url: url,
            headers: ["x-access-token": token],
            responseType: [PostModel].self
        )

        return response
    }
}
