//
//  Models+Testable.swift
//  
//
//  Created by Justin Lee on 5/21/23.
//

@testable import App
import Fluent
import XCTVapor

extension User {
    static func create(
        name: String = "Luke",
        username: String = "lukes",
        on database: Database
    ) async throws -> User {
        let user = User(name: name, username: username)
        try await user.create(on: database)
        return user
    }
}

extension Acronym {
    static func create(
        short: String = "TIL",
        long: String = "Today I Learned",
        user: User? = nil,
        on database: Database
    ) async throws -> Acronym {
        var newID: UUID?
        if user == nil {
            newID = try await User.create(on: database).id
        }
        guard let acronymsUserID = user?.id ?? newID else { throw Abort(.notFound) }
        
        let acronym = Acronym(short: short, long: long, userID: acronymsUserID)
        try await acronym.save(on: database)
        return acronym
    }
}
