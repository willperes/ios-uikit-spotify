//
//  ProfileViewControllerFactory.swift
//  Spotify
//
//  Created by Willian Peres on 03/08/24.
//

import Foundation

class ProfileViewControllerFactory {
    static func create() -> ProfileViewController {
        let viewModel = ProfileViewModel()
        let viewController = ProfileViewController(viewModel: viewModel)
        return viewController
    }
}
