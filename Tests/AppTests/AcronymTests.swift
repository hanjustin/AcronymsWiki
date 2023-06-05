//
//  AcronymTests.swift
//  
//
//  Created by Justin Lee on 6/4/23.
//

@testable import App
import XCTVapor

final class AcronymTests: XCTestCase {
    let acronymsURI = "/api/acronyms/"
    let acronymShort = "OMG"
    let acronymLong = "Oh My God"
    var app: Application!
    
    override func setUp() async throws {
        app = try await Application.testable()
    }
    
    override func tearDownWithError() throws {
        app.shutdown()
    }
    
    func testAcronymsCanBeRetrievedFromAPI() async throws {
        _ = try await Acronym.create(on: app.db)

        try app.test(.GET, acronymsURI) { response in
            let acronyms = try response.content.decode([Acronym].self)
            XCTAssertEqual(acronyms.count, 1)
        }
    }
    
    func testAcronymCanBeSavedWithAPI() async throws {
        let user = try await User.create(on: app.db)
        let createAcronymData = CreateAcronymData(short: acronymShort, long: acronymLong, userID: user.id!)
        
        try app.test(.POST, acronymsURI, beforeRequest: { request in
            try request.content.encode(createAcronymData)
        }, afterResponse: { response in
            let receivedAcronym = try response.content.decode(Acronym.self)
            XCTAssertEqual(receivedAcronym.short, acronymShort)
            XCTAssertEqual(receivedAcronym.long, acronymLong)
            XCTAssertNotNil(receivedAcronym.id)
            
            try app.test(.GET, acronymsURI) { allAcronymsResponse in
                let acronyms = try allAcronymsResponse.content.decode([Acronym].self)
                XCTAssertEqual(acronyms.count, 1)
                XCTAssertEqual(acronyms[0].short, acronymShort)
                XCTAssertEqual(acronyms[0].long, acronymLong)
                XCTAssertEqual(acronyms[0].id, receivedAcronym.id)
            }
        })
    }
    
    func testGettingASingleAcronymFromTheAPI() async throws {
        guard
            let acronymID = try await Acronym.create(short: acronymShort, long: acronymLong, on: app.db).id
        else { throw Abort(.notFound) }
        
        try app.test(.GET, "\(acronymsURI)\(acronymID)") { response in
            let returnedAcronym = try response.content.decode(Acronym.self)
            XCTAssertEqual(returnedAcronym.short, acronymShort)
            XCTAssertEqual(returnedAcronym.long, acronymLong)
            XCTAssertEqual(returnedAcronym.id, acronymID)
        }
    }
    
    func testUpdatingAnAcronym() async throws {
        guard
            let acronymID = try await Acronym.create(short: acronymShort, long: acronymLong, on: app.db).id,
            let newUserID = try await User.create(on: app.db).id
        else { throw Abort(.notFound) }
        let newLong = "Oh My Gosh"
        let updatedAcronymData = CreateAcronymData(short: acronymShort, long: newLong, userID: newUserID)
        
        try app.test(.PUT, "\(acronymsURI)\(acronymID)") { request in
            try request.content.encode(updatedAcronymData)
        }
        
        try app.test(.GET, "\(acronymsURI)\(acronymID)") { response in
            let returnedAcronym = try response.content.decode(Acronym.self)
            XCTAssertEqual(returnedAcronym.short, acronymShort)
            XCTAssertEqual(returnedAcronym.long, newLong)
            XCTAssertEqual(returnedAcronym.$user.id, newUserID)
        }
    }
    
    func testDeletingAnAcronym() async throws {
        guard
            let acronymID = try await Acronym.create(on: app.db).id
        else { throw Abort(.notFound) }
        
        try app.test(.GET, acronymsURI) { response in
            let acronyms = try response.content.decode([Acronym].self)
            XCTAssertEqual(acronyms.count, 1)
        }
        
        try await app.test(.DELETE, "\(acronymsURI)\(acronymID)")
        
        try app.test(.GET, acronymsURI) { response in
            let newAcronyms = try response.content.decode([Acronym].self)
            XCTAssertEqual(newAcronyms.count, 0)
        }
    }
    
    func testSearchAcronymShort() async throws {
        guard
            let acronymID = try await Acronym.create(short: acronymShort, long: acronymLong, on: app.db).id
        else { throw Abort(.notFound) }
        
        try app.test(.GET, "\(acronymsURI)search?term=\(acronymShort)") { response in
            let acronyms = try response.content.decode([Acronym].self)
            XCTAssertEqual(acronyms.count, 1)
            XCTAssertEqual(acronyms[0].id, acronymID)
            XCTAssertEqual(acronyms[0].short, acronymShort)
            XCTAssertEqual(acronyms[0].long, acronymLong)
        }
    }
    
    func testSearchAcronymLong() async throws {
        let acronym = try await Acronym.create(short: acronymShort, long: acronymLong, on: app.db)
        
        try app.test(.GET, "\(acronymsURI)search?term=Oh+My+God") { response in
            let acronyms = try response.content.decode([Acronym].self)
            XCTAssertEqual(acronyms.count, 1)
            XCTAssertEqual(acronyms[0].id, acronym.id)
            XCTAssertEqual(acronyms[0].short, acronymShort)
            XCTAssertEqual(acronyms[0].long, acronymLong)
        }
    }
    
    func testSortingAcronyms() async throws {
        let short2 = "LOL"
        let long2 = "Laugh Out Loud"
        let acronym1 = try await Acronym.create(short: acronymShort, long: acronymLong, on: app.db)
        let acronym2 = try await Acronym.create(short: short2, long: long2, on: app.db)
        
        try app.test(.GET, "\(acronymsURI)sorted") { response in
            let sortedAcronyms = try response.content.decode([Acronym].self)
            XCTAssertEqual(sortedAcronyms[0].id, acronym2.id)
            XCTAssertEqual(sortedAcronyms[1].id, acronym1.id)
        }
    }
    
    func testGettingAnAcronymsUser() async throws {
        let user = try await User.create(on: app.db)
        guard
            let userID = user.id,
            let acronymID = try await Acronym.create(user: user, on: app.db).id
        else { throw Abort(.notFound) }
        
        try app.test(.GET, "\(acronymsURI)\(acronymID)/user") { response in
            let acronymsUser = try response.content.decode(User.self)
            XCTAssertEqual(acronymsUser.id, userID)
            XCTAssertEqual(acronymsUser.name, user.name)
            XCTAssertEqual(acronymsUser.username, user.username)
        }
    }
}
