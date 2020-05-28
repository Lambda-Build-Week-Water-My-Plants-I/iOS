//
//  EditProfileViewController.swift
//  Water My Plants
//
//  Created by Nonye on 5/26/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit


class EditProfileViewController: UIViewController {
    
    var user: User?
    var wasEdited = false
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateViews() {
        guard let user = user else { return }
        
        userNameTextField.text = user.username
        
        
        phoneNumberTextField.text = user.phone_number
        
    }
}
