//
//  AcronymsController.swift
//  
//
//  Created by Justin Lee on 5/6/23.
//

import Vapor
import Fluent

struct AcronymsController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let acronyms = routes.grouped("api", "acronyms")
        acronyms.post(use: create)
        acronyms.get(use: index)
        acronyms.group(":acronymID") { acronym in
            acronym.get(use: show)
            acronym.put(use: update)
            acronym.delete(use: delete)
            acronym.get("user", use: getUser)
        }
        acronyms.get("search", use: search)
        acronyms.get("first", use: first)
        acronyms.get("sorted", use: sorted)
    }
    
    func create(req: Request) async throws -> Acronym {
        let data = try req.content.decode(CreateAcronymData.self)
        let acronym = Acronym(short: data.short, long: data.long, userID: data.userID)
        try await acronym.save(on: req.db)
        return acronym
    }
    
    func index(req: Request) async throws -> [Acronym] {
        try await Acronym.query(on: req.db).all()
    }
    
    func show(req: Request) async throws -> Acronym {
        guard let acronym = try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return acronym
    }
    
    func update(req: Request) async throws -> Acronym {
        guard let acronym = try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let receivedAcronym = try req.content.decode(CreateAcronymData.self)
        acronym.short = receivedAcronym.short
        acronym.long = receivedAcronym.long
        acronym.$user.id = receivedAcronym.userID
        try await acronym.save(on: req.db)
        return acronym
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let acronym = try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await acronym.delete(on: req.db)
        return .noContent
    }
    
    func search(req: Request) async throws -> [Acronym] {
        guard let searchTerm = req.query[String.self, at: "term"] else {
          throw Abort(.badRequest)
        }
        return try await Acronym.query(on: req.db).group(.or) { or in
            or.filter(\.$short == searchTerm)
            or.filter(\.$long == searchTerm)
        }.all()
    }
    
    func first(req: Request) async throws -> Acronym {
        guard let first = try await Acronym.query(on: req.db).first() else {
          throw Abort(.badRequest)
        }
        return first
    }
    
    func sorted(req: Request) async throws -> [Acronym] {
        try await Acronym.query(on: req.db).sort(\.$short, .ascending).all()
    }
    
    func getUser(req: Request) async throws -> User {
        guard let acronym = try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return try await acronym.$user.get(on: req.db)
    }
}

struct CreateAcronymData: Content {
    let short: String
    let long: String
    let userID: UUID
}
