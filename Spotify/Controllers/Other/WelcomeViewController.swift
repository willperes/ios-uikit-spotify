//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Willian Peres on 21/07/24.
//

import UIKit

class WelcomeViewController: UIViewController {
    private let signInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Spotify"
        view.backgroundColor = .systemGreen
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        signInButton.frame = CGRect(x: 20, y: view.height - 50 - view.safeAreaInsets.bottom, width: view.width - 40, height: 50)
    }
    
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleSignIn(success: Bool) {
        // Log user in or yell at them for error
    }
}
