//
//  LoginViewModel.swift
//  PostlyiOSSwiftUI
//
//  Created by Preetanshu Mishra on 2026-06-06.
//

import Foundation

enum LoginValidationError: LocalizedError {
    case emptyCredentials
    case emptyUsername
    case emptyPassword

    var errorDescription: String? {
        switch self {
        case .emptyCredentials:
            return "Please enter a username and password."
        case .emptyUsername:
            return "Please enter a username."
        case .emptyPassword:
            return "Please enter a password."
        }
    }
}

@MainActor
@Observable
final class LoginViewModel {

    var username: String = ""
    var password: String = ""
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?

    private let networkService: NetworkServiceProtocol
    private let onAuthenticated: (_ token: String, _ isGuest: Bool) -> Void

    init(networkService: NetworkServiceProtocol,
         onAuthenticated: @escaping (_ token: String, _ isGuest: Bool) -> Void) {
        self.networkService = networkService
        self.onAuthenticated = onAuthenticated
    }

    func login() async {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !(trimmedUsername.isEmpty && trimmedPassword.isEmpty) else {
            errorMessage = LoginValidationError.emptyCredentials.errorDescription
            return
        }

        guard !trimmedUsername.isEmpty else {
            errorMessage = LoginValidationError.emptyUsername.errorDescription
            return
        }

        guard !trimmedPassword.isEmpty else {
            errorMessage = LoginValidationError.emptyPassword.errorDescription
            return
        }

        await authenticate(username: trimmedUsername, password: trimmedPassword, isGuest: false)
    }

    func continueAsGuest() async {
        await authenticate(username: "", password: "", isGuest: true)
    }

    func dismissError() {
        errorMessage = nil
    }

    private func authenticate(username: String, password: String, isGuest: Bool) async {
        isLoading = true
        errorMessage = nil
        do {
            let token = try await networkService.fetchUserToken(username: username, password: password)
            isLoading = false
            onAuthenticated(token, isGuest)
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
}
