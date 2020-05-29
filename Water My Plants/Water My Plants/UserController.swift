//
//  UserController.swift
//  Water My Plants
//
//  Created by Dahna on 5/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//
import Foundation
import UIKit



final class UserController {
    
    struct APIUser: Codable {
        var id: Int
        var username: String
        var phone_number: String
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    enum NetworkError: Error {
        case failedSignUp, failedSignIn, noData, badData, noToken, failedLogOut, otherError, failedUpdate
    }
    
    // MARK: - Properties
    
    static let shared = UserController()
    var loggedInUser: APIUser?
    var bearer: Bearer?
    var currentUserID: UserID?
    
    private init () {
    }
    
    private let baseURL = URL(string: "https://wmplants-db.herokuapp.com/")!
    private lazy var signUpURL = baseURL.appendingPathComponent("api/auth/register")
    private lazy var signInURL = baseURL.appendingPathComponent("api/auth/login")
    private lazy var editUserURL = baseURL.appendingPathComponent("api/users/")
    private lazy var fetchUserURL = baseURL.appendingPathComponent("api/users/")
    
    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    
    func signUp(with username: String, password: String, phoneNumber: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        let user = User(username: username, password: password, phone_number: phoneNumber)
        print("\(String(describing: loggedInUser))🧞‍♀️🧞‍♀️")
        print("signUpURL = \(signUpURL.absoluteString)")
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    NSLog("Sign up failed with error: \(error)⚠️⚠️⚠️")
                    completion(.failure(.failedSignUp))
                    return
                }
                if let response = response as? HTTPURLResponse,
                    response.statusCode != 201 {
                    NSLog("Unexpected status code :\(response.statusCode)")
                    completion(.failure(.failedSignIn))
                    return
                }
                completion(.success(true))
            }
            task.resume()
        } catch {
            NSLog("Error encoding user: \(error)")
            completion(.failure(.failedSignUp))
        }
    }
    func signIn(with username: String, password: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        print("signInURL = \(signInURL.absoluteString)")
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let signInDictionary = ["username": username, "password": password]
            print(signInDictionary)
            let jsonData = try jsonEncoder.encode(signInDictionary)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    NSLog("Sign in failed with error: \(error)⚠️⚠️⚠️")
                    completion(.failure(.failedSignIn))
                    return
                }
                if let response = response as? HTTPURLResponse,
                    response.statusCode != 200 {
                    NSLog("Sign in was unsuccessful, server status code = \(response.statusCode)⚠️⚠️⚠️")
                    completion(.failure(.failedSignIn))
                    return
                }
                guard let data = data else {
                    NSLog("No data received during sign in.⚠️⚠️⚠️")
                    completion(.failure(.noData))
                    return
                }
                do {
                    self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                    self.currentUserID = try self.jsonDecoder.decode(UserID.self, from: data)
                    print("\(String(describing: self.currentUserID))")
                    
                    guard let userID = self.currentUserID else { return }
                    self.fetchUserFromServer(with: userID) { result in
                        switch result {
                        case .success(let apiUser):
                            self.loggedInUser = apiUser
                        case .failure(let error):
                            NSLog("Error: \(error)")
                        }
                    }
                } catch {
                    NSLog("Error decoding bearer object: \(error)⚠️⚠️⚠️")
                    completion(.failure(.noToken))
                }
                completion(.success(true))
            }
            task.resume()
        } catch {
            NSLog("Error encoding user: \(error)⚠️⚠️⚠️")
            completion(.failure(.failedSignIn))
        }
    }
    
    func fetchUserFromServer(with userID: UserID, completion: @escaping (Result<APIUser, NetworkError>) -> Void = { _ in }) {
        
        let requestURL = fetchUserURL.appendingPathComponent("\(userID.id)")
        print("\(userID)")
        print("fetchUserURL: \(requestURL)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let token = self.bearer?.token else { return }
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error fetching user: \(error)⚠️⚠️⚠️")
                completion(.failure(.otherError))
                return
            }

            guard let data = data else {
                NSLog("No data returned from server (fetching user).⚠️⚠️⚠️")
                completion(.failure(.noData))
                return
            }
            
            do {
                
                let apiUser = try self.jsonDecoder.decode(APIUser.self, from: data)
                completion(.success(apiUser))
            } catch {
                NSLog("Error deocding APIUser from server: \(error)⚠️⚠️⚠️")
                completion(.failure(.otherError))
            }
        }.resume()
    }
    
    func updateUser(with username: String, phoneNumber: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        guard let userID = currentUserID else { return }
        
        let requestURL = editUserURL.appendingPathComponent("\(userID)")
        print("editUserURL = \(requestURL.absoluteString)")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        #warning("Check to see if we need another setValue for bearer token when this runs")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let editDictionary = ["username": username, "phone_number": phoneNumber]
            print(editDictionary)
            
            let jsonData = try jsonEncoder.encode(editDictionary)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    NSLog("Updating user failed: \(error)⚠️⚠️⚠️")
                    completion(.failure(.otherError))
                    return
                }
                if let response = response as? HTTPURLResponse,
                    response.statusCode != 200 {
                    NSLog("Updating user failed, server status code = \(response.statusCode)⚠️⚠️⚠️")
                    completion(.failure(.otherError))
                    return
                }
                guard let data = data else {
                    NSLog("No data received during update user ⚠️⚠️⚠️")
                    completion(.failure(.noData))
                    return
                }
                do {
                    self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                    self.currentUserID = try self.jsonDecoder.decode(UserID.self, from: data)
                } catch {
                    NSLog("Error decoding bearer object: \(error)⚠️⚠️⚠️")
                    completion(.failure(.noToken))
                }
                completion(.success(true))
            }
            task.resume()
        } catch {
            NSLog("Error updating User on Server: \(error)⚠️⚠️⚠️")
            completion(.failure(.failedUpdate))
        }
    }
    
    //    func createLoggedInUser(username: String, password: String, phoneNumber: String) -> User {
    //
    //        let newUser = User(username: username, password: password, phone_number: phoneNumber)
    //
    //        self.loggedInUser = newUser
    //        return newUser
    //    }
    
}
