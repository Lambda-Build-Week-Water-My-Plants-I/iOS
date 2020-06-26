//
//  EditProfileViewController.swift
//  Water My Plants
//
//  Created by Nonye on 5/26/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit


class EditProfileViewController: UIViewController {
    
    let user = UserController.shared.loggedInUser
    var wasEdited = false
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited {
            guard let username = userNameTextField.text,
                !username.isEmpty,
                let phoneNumber = phoneNumberTextField.text,
                !phoneNumber.isEmpty else { return }
           
            UserController.shared.updateUser(with: username, phoneNumber: phoneNumber)
            UserController.shared.loggedInUser?.username = username
            print("\(String(describing: UserController.shared.loggedInUser))")
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing { wasEdited = true }
        
        userNameTextField.isUserInteractionEnabled = editing
        phoneNumberTextField.isUserInteractionEnabled = editing
        
    }
    
    private func updateViews() {
        
        userNameTextField.text = UserController.shared.loggedInUser?.username
        userNameTextField.isUserInteractionEnabled = isEditing
        
        phoneNumberTextField.text = UserController.shared.loggedInUser?.phone_number
        phoneNumberTextField.isUserInteractionEnabled = isEditing
    }
}
