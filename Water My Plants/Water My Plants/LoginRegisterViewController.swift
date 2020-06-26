//
//  LoginRegisterViewController.swift
//  Water My Plants
//
//  Created by Ezra Black on 5/26/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit



enum LoginType {
    case signUp
    case signIn
}

class LoginRegisterViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!

    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.layer.cornerRadius = 8.0
        passwordTextField.isSecureTextEntry = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Action Handlers
    
    @IBAction func buttonTapped(_ sender: UIButton) {

        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
        {
            
            if loginType == .signUp {
                guard let phoneNumber = phoneNumberTextField.text,
                    !phoneNumber.isEmpty else { return }
                UserController.shared.signUp(with: username, password: password, phoneNumber: phoneNumber, completion: { result in
                    
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .signIn
                                    self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                                    self.signInButton.setTitle("Sign In", for: .normal)
                                }
                            }
                        }
                    } catch {
                        NSLog("Error signing up: \(error)⚠️⚠️⚠️")
                    }
                })
            } else {
                phoneNumberTextField.isHidden = true
                UserController.shared.signIn(with: username, password: password, completion: { result in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } catch  {
                     
                        if let error = error as? UserController.NetworkError {
                            switch error {
                            case .failedSignIn:
                                NSLog("Sign in failed⚠️⚠️⚠️")
                            case .noData, .noToken:
                                NSLog("No Data received⚠️⚠️⚠️")
                            default:
                                NSLog("Other error occurred⚠️⚠️⚠️")
                            }
                        }
                    }
                })
            }
        }
    }
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // sign up
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
            phoneNumberTextField.isHidden = false
        } else {
            // sign in
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
            phoneNumberTextField.isHidden = true
        }
    }
}



