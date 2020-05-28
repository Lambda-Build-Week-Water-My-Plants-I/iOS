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
    
    private func updateViews() {
        
        userNameTextField.text = UserController.shared.loggedInUser?.username
        userNameTextField.isUserInteractionEnabled = isEditing
        
        phoneNumberTextField.text = UserController.shared.loggedInUser?.phone_number
        phoneNumberTextField.isUserInteractionEnabled = isEditing
        
    }
}
