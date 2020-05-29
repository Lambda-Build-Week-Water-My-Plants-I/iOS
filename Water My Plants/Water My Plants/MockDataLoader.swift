//
//  MockDataLoader.swift
//  Water My PlantsUITests
//
//  Created by Ezra Black on 5/29/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
@testable import Water_My_Plants

class MockDataLoader: NetworkDataLoader {
    
    let data: Data?
    let response: URLResponse?
    let error: Error?
    
    private(set) var request: URLRequest?
    
    internal init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    func loadData(using request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        self.request = request
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
            completion(self.data, self.response, self.error)
        }
    }
}

extension Data {
    static func mockJSONData(with name: String) -> Data {
        let bundle = Bundle(for: MockDataLoader.self)
        let url = bundle.url(forResource: name, withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}
