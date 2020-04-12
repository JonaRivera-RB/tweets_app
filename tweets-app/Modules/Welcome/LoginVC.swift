//
//  LoginVC.swift
//  tweets-app
//
//  Created by Misael Rivera on 09/04/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

class LoginVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - Actions
    @IBAction func loginButtonAction() {
        view.endEditing(true)
        performLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - Private methods
    
    private func setupUI() {
        loginButton.layer.cornerRadius = 25
    }
    
    private func performLogin() {
        guard let email = emailTextField.text, !email.isEmpty else {
            NotificationBanner(title: AppConstans.UPS, subtitle: AppConstans.WRONG_EMAIL, style: .warning).show()
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            NotificationBanner(title: AppConstans.UPS, subtitle: AppConstans.WRONG_PASSWORD, style: .warning).show()
            return
        }
        
        
        let request = LoginRequest(email: email, password: password)
        SVProgressHUD.show()
        SN.post(endpoint: Routes.LOGIN, model: request) { (response: SNResultWithEntity<LoginRegisterResponse, ErrorResponse>) in
            
            SVProgressHUD.dismiss()
            switch response {
            case .success(let user):
                NotificationBanner(subtitle: "Bienvenido \(user.user.names)", style: .success).show()
                SimpleNetworking.setAuthenticationHeader(prefix: "", token: user.token)
                self.performSegue(withIdentifier: AppConstans.SHOW_HOME, sender: nil)
                
            case .error(let error):
                NotificationBanner(subtitle: "\(error)", style: .warning).show()
                return
                
            case .errorResult(let entity):
                NotificationBanner(subtitle: "\(entity.error)", style: .danger).show()
                return
            }
        }
    }
}
