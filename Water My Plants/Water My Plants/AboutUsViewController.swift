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
    @IBOutlet weak var linkTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
    }
    
    func updateViews() {
        plantImageView.image = UIImage(named: "purplePlants")
        aboutUsTextView.textAlignment = .center
        aboutUsTextView.text = "Visit our Home Page for more information:"
        aboutUsTextView.isScrollEnabled = false
        linkTextView.isScrollEnabled = false
        linkTextView.textAlignment = .center
        linkTextView.text = "https://watermyownplants.netlify.app/index.html"
    }

}
