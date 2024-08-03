//
//  ProfileViewModel.swift
//  Spotify
//
//  Created by Willian Peres on 03/08/24.
//

import Foundation

protocol ProfileViewModelProtocol {
    func fetchCurrentUserProfile(successCompletion: @escaping (_ model: UserProfile) -> Void, errorCompletion: @escaping (_ error: Error) -> Void)
}

class ProfileViewModel: ProfileViewModelProtocol {
    func fetchCurrentUserProfile(successCompletion: @escaping (UserProfile) -> Void, errorCompletion: @escaping (any Error) -> Void) {
        APICaller.shared.getCurrentUserProfile { result in
            switch result {
            case .success(let model):
                successCompletion(model)
                break
            case .failure(let error):
                errorCompletion(error)
                break
            }
        }
    }
}
