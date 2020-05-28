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
    
    // MARK: - PROPERTIES
    var plantController: PlantController?
    var wasEdited = false
    var plant: Plant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited {
            guard let plantName = plantNameText.text,
                !plantName.isEmpty,
                let plantSpecies = plantSpeciesText.text,
                !plantSpecies.isEmpty,
                let plantFreq = plantFrequency.text,
                !plantFreq.isEmpty,
                let plant = plant else { return }
            
            let species = plantSpeciesText.text
            plant.species = species
            let h2o_frequency = plantFrequency.text
            plant.h2o_frequency = h2o_frequency
            
            do {
                try CoreDataStack.shared.save()
            } catch {
                NSLog("Error saving managed object context (during plant edit): \(error)")
            }
        }
    }
    
    // MARK: - ACTIONS
    
    
    // MARK: - EDITING
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing { wasEdited = true }
        
        plantNameText.isUserInteractionEnabled = editing
        plantSpeciesText.isUserInteractionEnabled = editing
        plantFrequency.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }
    
    private func updateViews() {
        guard let plant = plant else { return }
        
        plantNameText.text = plant.nickname
        plantNameText.isUserInteractionEnabled = isEditing
        
        plantSpeciesText.text = plant.species
        plantSpeciesText.isUserInteractionEnabled = isEditing
        
        plantFrequency.text = plant.h2o_frequency
        plantFrequency.isUserInteractionEnabled = isEditing
        
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
