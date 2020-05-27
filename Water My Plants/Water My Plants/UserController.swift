//
//  UserController.swift
//  Water My Plants
//
//  Created by Dahna on 5/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
import UIKit


//TODO: -MUST BE FIXED
final class UserController {
    
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case failedSignUp, failedSignIn, noData, badData, noToken, failedLogOut
    }
    
    // MARK: - Properties
    
    var bearer: Bearer?
    
    var currentUserID: UserID?
    
    
    private let baseURL = URL(string: "https://wmplants-db.herokuapp.com/")!
    private lazy var signUpURL = baseURL.appendingPathComponent("api/auth/register")
    private lazy var signInURL = baseURL.appendingPathComponent("api/auth/login")


    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    
    
    // create function for sign up
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        print("signUpURL = \(signUpURL.absoluteString)")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    NSLog("Sign up failed with error: \(error)⚠️⚠️⚠️")
                    completion(.failure(.failedSignUp))
                    return
                }
                if let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                        NSLog("Sign in was unsuccessful, server status code = \(response.statusCode)⚠️⚠️⚠️")
                        completion(.failure(.failedSignIn))
                        return
                }
                if let data = data {
                    print(String(data: data, encoding: .utf8)!)
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
}
