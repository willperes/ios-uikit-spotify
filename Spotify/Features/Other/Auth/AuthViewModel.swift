//
//  AuthViewModel.swift
//  Spotify
//
//  Created by Willian Peres on 03/08/24.
//

import Foundation

protocol AuthViewModelProtocol {
    func handleCodeExchange(_ code: String, completion: @escaping (_ success: Bool) -> Void) -> Void
    func fetchSignInURL() -> URL?
}

class AuthViewModel: AuthViewModelProtocol {
    func fetchSignInURL() -> URL? {
        return AuthManager.shared.signInURL
    }
    
    func handleCodeExchange(_ code: String, completion: @escaping (Bool) -> Void) {
        AuthManager.shared.exchangeCodeForToken(code: code) { success in
            completion(success)
        }
    }
}
