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
        }
        acronyms.get("search", use: search)
        acronyms.get("first", use: first)
        acronyms.get("sorted", use: sorted)
    }
    
    func create(req: Request) async throws -> Acronym {
        let acronym = try req.content.decode(Acronym.self)
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
        
        let receivedAcronym = try req.content.decode(Acronym.self)
        acronym.short = receivedAcronym.short
        acronym.long = receivedAcronym.long
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
}
