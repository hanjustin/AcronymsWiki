//
//  CategoryTests.swift
//  
//
//  Created by Justin Lee on 6/3/23.
//

@testable import App
import XCTVapor

final class CategoryTests: XCTestCase {
    let categoriesURI = "/api/categories/"
    let categoryName = "Teenager"
    var app: Application!
    
    override func setUp() async throws {
        app = try await Application.testable()
    }
    
    override func tearDownWithError() throws {
        app.shutdown()
    }
    
    func testCategoriesCanBeRetrievedFromAPI() async throws {
        _ = try await Category.create(on: app.db)
        _ = try await Category.create(on: app.db)
        
        try app.test(.GET, categoriesURI) { response in
            let categories = try response.content.decode([App.Category].self)
            XCTAssertEqual(categories.count, 2)
        }
    }

    func testCategoryCanBeSavedWithAPI() throws {
        let category = Category(name: categoryName)

        try app.test(.POST, categoriesURI, beforeRequest: { request in
            try request.content.encode(category)
        }, afterResponse: { response in
            let receivedCategory = try response.content.decode(Category.self)
            XCTAssertEqual(receivedCategory.name, categoryName)
            XCTAssertNotNil(receivedCategory.id)

            try app.test(.GET, categoriesURI, afterResponse: { response in
                let categories = try response.content.decode([App.Category].self)
                XCTAssertEqual(categories.count, 1)
                XCTAssertEqual(categories[0].name, categoryName)
                XCTAssertEqual(categories[0].id, receivedCategory.id)
            })
        })
    }
    
    func testGettingASingleCategoryFromTheAPI() async throws {
        guard
            let categoryID = try await Category.create(name: categoryName, on: app.db).id
        else { throw Abort(.notFound) }

        try app.test(.GET, "\(categoriesURI)\(categoryID)") { response in
            let returnedCategory = try response.content.decode(Category.self)
            XCTAssertEqual(returnedCategory.name, categoryName)
            XCTAssertEqual(returnedCategory.id, categoryID)
        }
    }
    
    func testGettingACategoriesAcronymsFromTheAPI() async throws {
        let acronymShort = "OMG"
        let acronymLong = "Oh My God"

        guard
            let acronymID = try await Acronym.create(short: acronymShort, long: acronymLong, on: app.db).id,
            let categoryID = try await Category.create(name: categoryName, on: app.db).id
        else { throw Abort(.notFound) }

        try await app.test(.POST, "/api/acronyms/\(acronymID)/categories/\(categoryID)")

        try app.test(.GET, "\(categoriesURI)\(categoryID)/acronyms") { response in
            let acronyms = try response.content.decode([Acronym].self)
            XCTAssertEqual(acronyms.count, 1)
            XCTAssertEqual(acronyms[0].id, acronymID)
            XCTAssertEqual(acronyms[0].short, acronymShort)
            XCTAssertEqual(acronyms[0].long, acronymLong)
        }
    }
    
}
