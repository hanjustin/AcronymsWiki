//
//  UsersController.swift
//  
//
//  Created by Justin Lee on 5/7/23.
//

import Vapor

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("api", "users")
        users.post(use: create)
        users.get(use: index)
        users.group(":userID") { user in
            user.get(use: show)
            user.get("acronyms", use: getAcronyms)
        }
    }

    func create(req: Request) async throws -> User {
        let user = try req.content.decode(User.self)
        try await user.save(on: req.db)
        return user
    }

    func index(req: Request) async throws -> [User] {
        try await User.query(on: req.db).all()
    }

    func show(req: Request) async throws -> User {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user
    }

    func getAcronyms(req: Request) async throws -> [Acronym] {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return try await user.$acronyms.get(on: req.db)
    }
}
