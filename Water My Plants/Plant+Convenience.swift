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
    
    @discardableResult convenience init(nickname: String,
                                        species: String?,
                                        frequency: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.nickname = nickname
        self.species = species
        self.h2o_frequency = h2o_frequency
    }
    
}
