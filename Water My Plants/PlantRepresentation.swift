//
//  PlantRepresentation.swift
//  Water My Plants
//
//  Created by Nonye on 5/26/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
import CoreData

struct PlantRepresentation: Codable {
    var nickname: String
    var species: String?
    var frequency: String
    var userID: String
}
