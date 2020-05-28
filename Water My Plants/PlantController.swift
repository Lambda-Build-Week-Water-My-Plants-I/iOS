//
//  PlantController.swift
//  Water My Plants
//
//  Created by Nonye on 5/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

enum NetworkError: Error {
    case otherError
    case noData
    case failedDecode
    case serverDown
    case failedEncode
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
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    // MARK: FETCH PLANTS "GET"
    //MARK: - TODO - come back to the api/user once i have user info
    
    func fetchPlantsFromServer(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = baseURL.appendingPathComponent("api/users").appendingPathComponent("plants")
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
    
    // MARK: - SEND PLANTS "PUT" --- TODO
    
    func sendPlantsToServer(plant: Plant, completion: @escaping () -> Void
        = { }) {
        let requestURL = baseURL.appendingPathComponent("/api/plants")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        guard let plantRepresentation = plant.plantRepresentation else {
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(plantRepresentation)
        } catch {
            NSLog("Error encoding \(plant): \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error sending plant to server \(plant): \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    // MARK: - UPDATE PLANTS
    func updatePlants(with representations: [PlantRepresentation]) throws {
        // HOW TO IMPLEMENT WITH INT16
        
        //        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        //        fetchRequest.predicate = NSPredicate()
        //
        //        let context = CoreDataStack.shared.container.newBackgroundContext()
        //        var error: Error?
        //
        //        context.performAndWait {
        //            do {
        //                let existingPlants = try context.fetch(fetchRequest)
        //            }
        //        }
        
    }
    
    // MARK: - DELETE PLANTS
    func deletePlantsFromServer(_ plant: Plant, completion: @escaping CompletionHandler = { _ in }) {
        //TODO
        let identifier = String()
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathComponent("api/users").appendingPathComponent("delete")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error deleting plant from server \(plant): \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }.resume()
    }
    


} // EOC
