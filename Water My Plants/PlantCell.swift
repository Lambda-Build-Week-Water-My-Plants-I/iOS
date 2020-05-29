//
//  PlantCell.swift
//  Water My Plants
//
//  Created by Nonye on 5/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit

class PlantCell: UITableViewCell {
    //MARK: - WORKING ON THE TOGGLE
    var plantController: PlantController?
    
    // MARK: OUTLETS
    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantSpecies: UILabel!
    @IBOutlet weak var waterButton: UIButton!
    @IBOutlet weak var plantPicture: UIImageView!
    
    var plant: Plant? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let plant = plant else { return }
        plantName.text = plant.nickname
        plantSpecies.text = plant.species
        
        // MARK: - HELP
        waterButton.setImage((plant.h2o_frequency != nil) ? UIImage(contentsOfFile: "empty-droplet") : UIImage(contentsOfFile: "filled-droplet"), for: .normal)
    }
    
    // MARK: - ACTIONS -- TODO
    @IBAction func beenWateredToggle(_ sender: UIButton) {
        guard let plant = plant else { return }
        
        //to do toggle
        //plant.().toggle()
        
        // todo image
        do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                CoreDataStack.shared.mainContext.reset()
                NSLog("Error saving context (changing task complete boolean): \(error)")
            }
        }
    }

