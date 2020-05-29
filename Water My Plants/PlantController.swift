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
    
    struct ApiPlant : Codable {
        let nickname: String
        let species: String?
        let h2o_frequency: String
    }
    
    private let baseURL = URL(string: "https://wmplants-db.herokuapp.com/")!
    private lazy var plantDetailURL = baseURL.appendingPathComponent("api/plants/")
    
    var plantRepresentation: [PlantRepresentation] = []
    let decoder = JSONDecoder()
    
    
    //    var userPlants: [] = []
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    // MARK: FETCH PLANTS "GET"
    //MARK: - TODO - come back to the api/user once i have user info
    
    
    func fetchPlantsFromServer(completion: @escaping CompletionHandler = { _ in }) {
        guard let userID = UserController.shared.currentUserID?.id else { return }
        let requestURL = baseURL.appendingPathComponent("api/users/\(userID)/plants")
        var request = URLRequest(url: requestURL)
        guard let token = UserController.shared.bearer?.token else { return }
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request) { data, _, error in
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
                let plantRepresentations = try JSONDecoder().decode( [PlantRepresentation].self, from: data)
                try self.updatePlants(with: plantRepresentations)
            } catch {
                NSLog("Error decoding plants from server: \(error)")
                completion(.failure(.failedDecode))
            }
        }.resume()
    }
    
    // MARK: - SEND PLANTS "POST" --- TODO
    
    func sendPlantToServer(plant: PlantRepresentation, completion: @escaping (_ plantID: Int?) -> Void
        = {_ in }) {
        
        let apiPlant = ApiPlant(nickname: plant.nickname, species: plant.species, h2o_frequency: plant.h2o_frequency)
        
        let requestURL = baseURL.appendingPathComponent("api/plants")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        guard let token = UserController.shared.bearer?.token else { return }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        do {
            let body = try JSONEncoder().encode(apiPlant)
            print ("Request body: \(body)")
            request.httpBody = body
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
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 201 {
                    NSLog("No 201 response from server")
                    completion(nil)
                    return }
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
    // MARK: - CREATE PLANT FUNC
    func createPlant(nickname: String, species: String, h2o_frequency: String) {
        guard let userID = UserController.shared.currentUserID?.id else { return }
        var newPlant = PlantRepresentation(nickname: nickname, species: species, h2o_frequency: h2o_frequency, user_id: userID, id: 0)
        self.sendPlantToServer(plant: newPlant) { (id) in
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
    // updates users data with remote data (representation)
    func updatePlants(with representations: [PlantRepresentation]) throws {
        let plantID = representations.compactMap { ($0.id) }
        let representationbyID = Dictionary(uniqueKeysWithValues: zip(plantID, representations))
        var plantToCreate = representationbyID
        
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", plantID)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        var error: Error?
        
        context.performAndWait {
            do {
                let existingPlants = try context.fetch(fetchRequest)
                for plant in existingPlants {
                    guard let id = plant.id,
                        let representation  = representationbyID[Int(id)] else { continue }
                    self.update(plant: plant, with: representation)
                    plantToCreate.removeValue(forKey: Int(id))
                }
            } catch let fetchError {
                error = fetchError
            }
            for representation in plantToCreate.values {
                Plant(plantRepresentation: representation, context: context)
            }
        }
        if let error = error { throw error }
        try CoreDataStack.shared.save(context: context)
    }
    
    // MARK: - UPDATE PLANTS LOCALLY
    
    func updatePlantOnServer(plant: Plant, completion: @escaping (_ plantID: Int?) -> Void
        = {_ in }) {

        
        let apiPlant = ApiPlant(nickname: plant.nickname ?? "" , species: plant.species, h2o_frequency: plant.h2o_frequency ?? "")
        
        guard let plantID = plant.id else { return }
        
        let requestURL = baseURL.appendingPathComponent("api/plants").appendingPathComponent("\(plantID)")
        print("\(requestURL)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        guard let token = UserController.shared.bearer?.token else { return }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        do {
            let body = try JSONEncoder().encode(apiPlant)
            print ("Request body: \(body)")
            request.httpBody = body
        } catch {
            NSLog("Error encoding \(plant): \(error)")
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                NSLog("Error sending plant to server \(plant): \(error)")
                completion(nil)
                return
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 201 {
                    NSLog("No 201 response from server")
                    completion(nil)
                    return }
            }
        }.resume()
        
    }
    
    func update(plant: Plant, with representations: PlantRepresentation, completion: @escaping (_ plantID: Int?) -> Void
        = {_ in }) {
        
        plant.nickname = representations.nickname
        plant.species = representations.species
        plant.h2o_frequency = representations.h2o_frequency
        
    }
    
    // MARK: - DELETE PLANTS
    func deletePlantsFromServer(_ plant: Plant, completion: @escaping CompletionHandler = { _ in }) {
        guard let plantID = plant.id else { return }
        let requestURL = baseURL.appendingPathComponent("api/plants/\(plantID)")
        var request = URLRequest(url: requestURL)
        guard let token = UserController.shared.bearer?.token else { return }
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
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
