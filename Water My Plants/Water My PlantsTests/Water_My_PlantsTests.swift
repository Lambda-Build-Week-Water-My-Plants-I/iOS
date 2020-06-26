//
//  Water_My_PlantsTests.swift
//  Water My PlantsTests
//
//  Created by Ezra Black on 5/26/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import XCTest
@testable import Water_My_Plants

#warning("All of these errors are due to the whole app being remapped last second due to singleton issues.. these tests are depricated.")

class Water_My_PlantsTests: XCTestCase {
    var bearer: Bearer?
       var user: User?
       
       enum NetworkError: Error {
           case failedRegister
           case failedLogin
           case noData
           case notSignedIn
           case failedFetch
           case otherError
           case noIdentifier
           case noDecode
           case noEncode
           case noRep
       }
       private enum LoginStatus {
           case notLoggedIn
           case loggedIn(Bearer)
           static var isLoggedIn: Self {
               if let bearer = userController.bearer {
                   return loggedIn(bearer)
               } else {
                   return notLoggedIn
               }
           }
       }

       // MARK: User Tests
       func testUserCreate() {
           let user = UserRepresentation(id: 1, username: "usertest", password: "new", phoneNumber: "555-555-5555")
           if user.id == 1,
               user.username == "usertest",
               user.password == "new",
               user.phoneNumber == "555-555-5555" {
               XCTAssert(user.id == 1)
               XCTAssert(user.username == "usertest")
               XCTAssert(user.password == "new")
               XCTAssert(user.phoneNumber == "555-555-5555")
           }
       }
       func testForRegisterResults() {
       }

       func testForLoginResults() {
           let expectation = self.expectation(description: "Wait for results")
           let controller = userController()
                   controller.login(username: "test", password: "password") {_ in
               print("Returned Results ⚠️")
               expectation.fulfill()
           }
           wait(for: [expectation], timeout: 5)
       }

       // MARK: Plant Tests

       func testPlantTableView() {
           XCTAssertFalse(LoginViewController.isAccessibilityElement())
       }
       func testCreatingPlant() {
           let controller = ApiController()
           //  var plantRep: PlantRepresentation?
           guard let newBearer = bearer else {return}
           let plant = Plant(commonName: "Eggy", scientificName: "Weggy", image: "")
           let newPlant = plant
           let resultsExpectation = expectation(description: "wait for results")
           controller.sendPlantToServer(plant: newPlant) { (_ ) in
               self.bearer = newBearer
               XCTAssert(newPlant.commonName != nil, "The Plant has a name")
               XCTAssertFalse(newPlant.h2oFrequency != 0.1, "The Plant has a h2o Frequency")
               XCTAssert(newPlant.id != nil, "The Plant has a id")
               XCTAssert(newPlant.image != nil, "The Plant has a image")
               XCTAssert(newPlant.plantRepresentation != nil, "The Plant has a representation")
               resultsExpectation.fulfill()
           }
           wait(for: [resultsExpectation], timeout: 2)
           XCTAssertNotNil(newBearer)
       }
       func testSpeedOfNetworkRequestGetPlantNames() {
           measure {
               let expectation = self.expectation(description: "Wait for results")
               let controller = ApiController(dataLoader: URLSession(configuration: .ephemeral))
               controller.getPlantNames { (_ ) in
                   expectation.fulfill()
               }
               wait(for: [expectation], timeout: 5)
           }
       }
       func testUserRegister() {
           guard let newUser = user else {return}
           let expectation = self.expectation(description: "Wait for Register")
           let controller = ApiController(dataLoader: URLSession(configuration: .ephemeral))
           controller.register(with: newUser) { (_ ) in
               self.user = newUser
               expectation.fulfill()
           }
           wait(for: [expectation], timeout: 5)
           XCTAssertNotNil(newUser)
       }
       func testValidData() {
           let mockDataLoader = MockDataLoader(data: goodResultPlantData, response: nil, error: nil)
           let expectation = self.expectation(description: "Wait for results")
           let controller = ApiController(dataLoader: mockDataLoader)
                   controller.fetchPlantsFromServer { (_ ) in
               expectation.fulfill()
           }
           wait(for: [expectation], timeout: 5)
       }
       func testInvalidValidData() {
               let mockDataLoader = MockDataLoader(data: badResultPlantData, response: nil, error: nil)
               let expectation = self.expectation(description: "Wait for results")
               let controller = ApiController(dataLoader: mockDataLoader)
                       controller.fetchPlantsFromServer { (_ ) in
                   expectation.fulfill()
               }
               wait(for: [expectation], timeout: 5)
           }
}
