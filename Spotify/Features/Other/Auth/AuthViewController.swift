//
//  AuthViewController.swift
//  Spotify
//
//  Created by Willian Peres on 21/07/24.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {
    private let viewModel: AuthViewModelProtocol?
    private let authCompletionHandler: ((Bool) -> Void)?
    
    init(viewModel: AuthViewModelProtocol, authCompletionHandler: @escaping (_ success: Bool) -> Void) {
        self.viewModel = viewModel
        self.authCompletionHandler = authCompletionHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign In"
        view.backgroundColor = .systemBackground
        
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        guard let url = viewModel?.fetchSignInURL() else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        
        let component = URLComponents(string: url.absoluteString)
        guard let code = component?.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        
        webView.isHidden = true
        viewModel?.handleCodeExchange(code) { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.authCompletionHandler?(success)
            }
        }
    }
}

extension AuthViewController: WKNavigationDelegate {}
