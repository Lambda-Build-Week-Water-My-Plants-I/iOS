//
//  PlantController.swift
//  Water My Plants
//
//  Created by Nonye on 5/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
import UIKit
//PLANT CONTROLLER
enum NetworkError: Error {
    case otherError
    case noData
    case failedDecode
    case serverDown
}
enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

import Foundation
import CoreData

class PlantController {

private let baseURL = URL(string: "https://wmplants-db.herokuapp.com/")!
private lazy var plantDetailURL = baseURL.appendingPathComponent("/api/plants/")
    
    var plantRepresentation: [PlantRepresentation] = []
    
    typealias CompletionHandler = (Error?) -> Void
    
    func fetchPlantsFromServer(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        let requestURL = baseURL.appendingPathComponent("api/").appendingPathComponent("plants")
            URLSession.shared.dataTask(with: requestURL) { data, _, error in
                if let error = error {
                    NSLog("Error fetching tasks: \(error)")
                    completion(.failure(.otherError))
                    return
                }
                guard let data = data else {
                    NSLog("No data returned from server (fetching plants).")
                    completion(.failure(.noData))
                    return
                }
                do {
                    let plantRepresentations = Array(try JSONDecoder().decode([String : PlantRepresentation].self, from: data).values)
                    try self.updatePlants(with: plantRepresentations)
                } catch {
                    NSLog("Error decoding plants from server: \(error)")
                    completion(.failure(.failedDecode))
                }
            }.resume()
        }
        
    
    func sendPlantsToServer() {
        
    }
    
    func updatePlants(with representations: [PlantRepresentation]) throws {
        
    }
    
    func deletePlantsOnServer() {
        
    }


}
