//
//  RegisterVC.swift
//  tweets-app
//
//  Created by Misael Rivera on 09/04/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit
import NotificationBannerSwift

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
        
        performSegue(withIdentifier: AppConstans.SHOW_HOME, sender: nil)
        //registro aqui
    }
}
