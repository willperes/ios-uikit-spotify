//
//  AuthResponse.swift
//  Spotify
//
//  Created by Willian Peres on 28/07/24.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
