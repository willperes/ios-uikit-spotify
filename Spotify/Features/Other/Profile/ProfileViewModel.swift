//
//  ProfileViewModel.swift
//  Spotify
//
//  Created by Willian Peres on 03/08/24.
//

import Foundation

protocol ProfileViewModelProtocol {
    func fetchCurrentUserProfile(completion: @escaping (_ success: Bool) -> Void)
}

class ProfileViewModel: ProfileViewModelProtocol {
    func fetchCurrentUserProfile(completion: @escaping (Bool) -> Void) {
        APICaller.shared.getCurrentUserProfile { result in
            switch result {
            case .success(let model):
                completion(true)
                break
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
                break
            }
        }
    }
}
