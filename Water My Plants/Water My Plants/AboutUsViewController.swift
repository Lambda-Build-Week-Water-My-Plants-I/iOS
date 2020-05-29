//
//  AboutUsViewController.swift
//  Water My Plants
//
//  Created by Ezra Black on 5/26/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantParentLabel: UILabel!
    @IBOutlet weak var aboutUsTextView: UITextView!
    @IBOutlet weak var getStartedButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
    }
    
    func updateViews() {
        plantImageView.image = UIImage(named: "purplePlants")
        aboutUsTextView.textAlignment = .center
        aboutUsTextView.text = "Visit our Home Page for more information: \n https://watermyownplants.netlify.app/index.html "
        aboutUsTextView.textColor = .black
        aboutUsTextView.isScrollEnabled = false
    }

}
