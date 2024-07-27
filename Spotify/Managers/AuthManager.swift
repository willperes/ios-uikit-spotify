//
//  AuthManager.swift
//  Spotify
//
//  Created by Willian Peres on 21/07/24.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
        static let clientID = "CLIENT_ID"
        static let clientSecret = "CLIENT_SECRET"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let baseURL = "https://accounts.spotify.com/authorize"
        let scopes = "user-read-private"
        let redirectURI = "https://willperes.vercel.app"
        let string = "\(baseURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool? {
        return false
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        // TODO: Get the token
    }
    
    public func refreshAccessToken() {
        // TODO: handle refresh token
    }
    
    private func cacheToken() {
        // TODO: handle token cache
    }
}
