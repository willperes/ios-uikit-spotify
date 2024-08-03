//
//  AuthViewControllerFactory.swift
//  Spotify
//
//  Created by Willian Peres on 03/08/24.
//

import Foundation

class AuthViewControllerFactory {
    static func create(authCompletionHandler: @escaping (_ success: Bool) -> Void) -> AuthViewController {
        let viewModel = AuthViewModel()
        let viewController = AuthViewController(viewModel: viewModel, authCompletionHandler: authCompletionHandler)
        return viewController
    }
}
