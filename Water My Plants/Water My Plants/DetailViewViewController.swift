//
//  DetailViewViewController.swift
//  Water My Plants
//
//  Created by Ezra Black on 5/26/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit

class DetailViewViewController: UIViewController {
    // MARK: - OUTLETS
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNameText: UITextField!
    @IBOutlet weak var plantSpeciesText: UITextField!
    @IBOutlet weak var plantFrequency: UITextField!
       
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
