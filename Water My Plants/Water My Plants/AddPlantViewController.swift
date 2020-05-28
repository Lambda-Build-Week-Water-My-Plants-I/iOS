//
//  AddPlantViewController.swift
//  Water My Plants
//
//  Created by Ezra Black on 5/26/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit

class AddPlantViewController: UIViewController {
    
    // MARK: - Properties
    
    var plant: Plant?
    var controller: PlantController?
    
    // MARK: - OUTLETS
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNameText: UITextField!
    @IBOutlet weak var plantSpeciesText: UITextField!
    @IBOutlet weak var plantFrequency: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    // MARK: - ACTIONS
    @IBAction func savePlantButton(_ sender: UIBarButtonItem) {
//        guard let plantImage = plantImageView.image,
            guard let nickname = plantNameText.text,
            let species = plantSpeciesText.text,
            let h2o_frequency = plantFrequency.text else { return }
        
        if let plant = plant {
            plant.nickname = nickname
            plant.species = species
            plant.h2o_frequency = h2o_frequency
        } else {
            controller?.createPlant(nickname: nickname, species: species, h2o_frequency: h2o_frequency)
        }
//        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
} //EOC


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


