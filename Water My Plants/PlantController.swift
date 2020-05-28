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
    private lazy var plantDetailURL = baseURL.appendingPathComponent("api/plants/")
    
    var plantRepresentation: [PlantRepresentation] = []
    let decoder = JSONDecoder()
    
    //    var userPlants: [] = []
    
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
    
    // MARK: - SEND PLANTS "POST" --- TODO
    
    func sendPlantsToServer(plant: PlantRepresentation, completion: @escaping (_ plantID: Int?) -> Void
        = {_ in }) {
        let requestURL = baseURL.appendingPathComponent("api/plants")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        guard let token = UserController.shared.bearer?.token else { return }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")

        do {
            request.httpBody = try JSONEncoder().encode(plantRepresentation)
        } catch {
            NSLog("Error encoding \(plant): \(error)")
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error sending plant to server \(plant): \(error)")
                completion(nil)
                return
            }
            //Retrieve id of plant from response from server
            if let data = data {
                
                do {
                    let newPlant = try self.decoder.decode(PlantRepresentation.self, from: data)
                    completion(newPlant.id)
                } catch {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func createPlant(nickname: String, species: String, h2o_frequency: String) {
        guard let userID = UserController.shared.currentUserID?.id else { return }
        var newPlant = PlantRepresentation(nickname: nickname, species: species, h2o_frequency: h2o_frequency, user_id: userID, id: 0)
        self.sendPlantsToServer(plant: newPlant) { (id) in
            guard let id = id else { return }
            newPlant.id = id
            let _ = Plant(plantRepresentation: newPlant)
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
        
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
