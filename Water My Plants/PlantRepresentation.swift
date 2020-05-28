//
//  PlantRepresentation.swift
//  Water My Plants
//
//  Created by Nonye on 5/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
import CoreData

struct PlantRepresentation: Codable {
    var nickname: String
    var species: String?
    var h2o_frequency: String
    var user_id: Int
    var id: Int
}
