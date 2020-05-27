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
    
    var userController: UserController?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.layer.cornerRadius = 8.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        usernameTextField.becomeFirstResponder()
    }
    
    // MARK: - Action Handlers
    
    @IBAction func buttonTapped(_ sender: UIButton) {

        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty,
            let phoneNumber = phoneNumberTextField.text,
            !phoneNumber.isEmpty {
            let user = User(username: username, password: password, phone_number: Int(phoneNumber) ?? 000)
            
            if loginType == .signUp {
                
                userController?.signUp(with: user, completion: { result in
                    
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
                        print("Error signing up: \(error)⚠️⚠️⚠️")
                    }
                })
            } else {
                
                userController?.signIn(with: user, completion: { result in
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
        } else {
            // sign in
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
}

