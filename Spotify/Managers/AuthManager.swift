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
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://willperes.vercel.app"
        static let scopes = [
            "user-read-private",
            "playlist-modify-public",
            "playlist-read-private",
            "playlist-modify-private",
            "user-follow-read",
            "user-library-read",
            "user-library-read",
            "user-read-email"
        ].joined(separator: "%20")
        
        static let userDefaultsAccessTokenKey = "access_token"
        static let userDefaultsRefreshTokenKey = "refresh_token"
        static let userDefaultsTokenExpirationDateKey = "expirationDate"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let baseURL = "https://accounts.spotify.com/authorize"
        let string = "\(baseURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: Constants.userDefaultsAccessTokenKey)
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: Constants.userDefaultsRefreshTokenKey)
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: Constants.userDefaultsTokenExpirationDateKey) as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        
        let currentDate = Date()
        let fiveMinutes: TimeInterval = TimeInterval(60 * 5)
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let basic64String = data?.base64EncodedString() else {
            completion(false)
            print("Failed to get base64String")
            return
        }
        request.setValue("Basic \(basic64String)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    public func refreshTokenIfNeeded(completion: @escaping (Bool) -> Void) {
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            completion(false)
            return
        }
        
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let basic64String = data?.base64EncodedString() else {
            completion(false)
            print("Failed to get base64String")
            return
        }
        request.setValue("Basic \(basic64String)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: Constants.userDefaultsAccessTokenKey)
        
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: Constants.userDefaultsRefreshTokenKey)
        }
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: Constants.userDefaultsTokenExpirationDateKey)
    }
}
