//
//  Plant+Convenience.swift
//  Water My Plants
//
//  Created by Nonye on 5/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
import CoreData

extension Plant {
    
    var plantRepresentation: PlantRepresentation? {
        guard let id = id,
            let nickname = nickname,
            let user_id = user_id,
            let species = species,
            let h2o_frequency = h2o_frequency else {
                return nil
        }
        return PlantRepresentation(nickname: nickname,
                                   species: species,
                                   h2o_frequency: h2o_frequency,
                                   user_id: Int(truncating: user_id),
                                   id: Int(truncating: id))
    }
    
    @discardableResult convenience init(nickname: String,
                                        species: String?,
                                        h2o_frequency: String,
                                        id: Int16,
                                        user_id: Int16,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.nickname = nickname
        self.species = species
        self.h2o_frequency = h2o_frequency
        self.id = NSNumber(value: id)
        self.user_id = NSNumber(value: user_id)
    }
    
    @discardableResult convenience init?(plantRepresentation: PlantRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(nickname: plantRepresentation.nickname,
                  species: plantRepresentation.species,
                  h2o_frequency: plantRepresentation.h2o_frequency,
                  id: Int16(plantRepresentation.id),
                  user_id: Int16(plantRepresentation.user_id),
                  context: context)
    }
}

