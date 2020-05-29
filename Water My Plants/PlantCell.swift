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
    var wasWatered: Bool = false
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
        waterButton.setBackgroundImage(UIImage(named: "empty-droplet"), for: .normal)
    }
    // MARK: - ACTIONS -- TODO
    @IBAction func beenWateredToggle(_ sender: UIButton) {
        guard let plant = plant else { return }
        
        wasWatered.toggle()
        
        if wasWatered == true {
            waterButton.setBackgroundImage(UIImage(named: "filled-droplet"), for: .normal)
        } else {
            waterButton.setBackgroundImage(UIImage(named: "empty-droplet"), for: .normal)
        }
    }
}
