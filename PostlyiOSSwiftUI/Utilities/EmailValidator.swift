//
//  EmailValidator.swift
//  PostlyiOSSwiftUI
//
//  Created by Preetanshu Mishra on 2026-06-06.
//

import Foundation

enum EmailValidator {
    static func isValidDomain(email: String) -> Bool {
        let parts = email.split(separator: "@", omittingEmptySubsequences: false)
        guard parts.count == 2 else {
            return false
        }

        let domain = parts[1].lowercased()
        let validExtensions = [".com", ".net", ".biz"]
        return validExtensions.contains(where: { domain.hasSuffix($0) })
    }
}
