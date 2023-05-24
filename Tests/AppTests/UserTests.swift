//
//  UserTests.swift
//  
//
//  Created by Justin Lee on 5/8/23.
//

@testable import App
import XCTVapor
import Fluent

final class UserTests: XCTestCase {
    let usersName = "Alice"
    let usersUsername = "alicea"
    let usersURI = "/api/users/"
    var app: Application!
      
    override func setUp() async throws {
        app = try await Application.testable()
    }

    override func tearDownWithError() throws {
        app.shutdown()
    }
    
    func testUsersCanBeRetrievedFromAPI() async throws {
        _ = try await User.create(on: app.db)
        _ = try await User.create(on: app.db)

        try app.test(.GET, usersURI) { response in
            XCTAssertEqual(response.status, .ok)
            let users = try response.content.decode([User].self)
            XCTAssertEqual(users.count, 2)
        }
    }
    
    func testUserCanBeSavedWithAPI() async throws {
        let user = User(name: usersName, username: usersUsername)
        
        try app.test(.POST, usersURI, beforeRequest: { req in
            try req.content.encode(user)
        }, afterResponse: { response in
            let receivedUser = try response.content.decode(User.self)
            XCTAssertEqual(receivedUser.name, usersName)
            XCTAssertEqual(receivedUser.username, usersUsername)
            XCTAssertNotNil(receivedUser.id)
            
            try app.test(.GET, usersURI) { secondResponse in
                let users = try secondResponse.content.decode([User].self)
                XCTAssertEqual(users.count, 1)
                XCTAssertEqual(users[0].name, usersName)
                XCTAssertEqual(users[0].username, usersUsername)
                XCTAssertEqual(users[0].id, receivedUser.id)
            }
        })
    }
    
    func testGettingASingleUserFromTheAPI() async throws {
        guard
            let userID = try await User.create(name: usersName, username: usersUsername, on: app.db).id
        else { throw Abort(.notFound) }
        
        try app.test(.GET, usersURI + "\(userID)") { response in
            let receivedUser = try response.content.decode(User.self)
            XCTAssertEqual(receivedUser.name, usersName)
            XCTAssertEqual(receivedUser.username, usersUsername)
            XCTAssertEqual(receivedUser.id, userID)
        }
    }
    
    func testGettingAUsersAcronymsFromTheAPI() async throws {
        let user = try await User.create(on: app.db)
        _ = try await Acronym.create(user: user, on: app.db)
        _ = try await Acronym.create(user: user, on: app.db)
        
        try app.test(.GET, usersURI + "\(user.id!)/acronyms") { response in
            let acronyms = try response.content.decode([Acronym].self)
            XCTAssertEqual(acronyms.count, 2)
        }
    }
}




