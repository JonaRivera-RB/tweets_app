//
//  RegisterVC.swift
//  tweets-app
//
//  Created by Misael Rivera on 09/04/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

class RegisterVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    //MARK: - Actions
    @IBAction func reigsterButtonAction() {
        view.endEditing(true)
        performRegister()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - Private methods
    
    private func setupUI() {
        registerButton.layer.cornerRadius = 25
    }
    
    private func performRegister() {
        guard let email = emailTextField.text, !email.isEmpty else {
            NotificationBanner(title: AppConstans.UPS, subtitle:
                AppConstans.WRONG_EMAIL, style: .warning).show()
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            NotificationBanner(title: AppConstans.UPS, subtitle: AppConstans.WRONG_PASSWORD, style: .warning).show()
            return
        }
        
        guard let name = nameTextField.text, !name.isEmpty else {
            NotificationBanner(title: AppConstans.UPS, subtitle: AppConstans.WRONG_NAME, style: .warning).show()
            return
        }
        
        
        let request = RegisterRequest(email: email, password: password, names: name)
        SVProgressHUD.show()
        SN.post(endpoint: Routes.REGISTER, model: request) { (response: SNResultWithEntity<LoginRegisterResponse, ErrorResponse>) in
            
            SVProgressHUD.dismiss()
            switch response {
            case .success(let user):
                NotificationBanner(subtitle: "Bienvenido \(user.user.names)", style: .success).show()
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
