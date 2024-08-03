//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Willian Peres on 21/07/24.
//

import UIKit

class ProfileViewController: UIViewController {
    private let viewModel: ProfileViewModelProtocol?
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        view.backgroundColor = .systemBackground
        
        viewModel?.fetchCurrentUserProfile { success in
            guard success else {
                // Failure
                return
            }
            
            // Success
        }
    }
}
