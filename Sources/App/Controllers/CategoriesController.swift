//
//  CategoriesController.swift
//  
//
//  Created by Justin Lee on 5/7/23.
//

import Vapor
import Fluent

struct CategoriesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categories = routes.grouped("api", "categories")
        categories.post(use: create)
        categories.get(use: index)
        categories.group(":categoryID") { category in
            category.get(use: show)
            category.get("acronyms", use: getAcronyms)
        }
    }

    func create(req: Request) async throws -> Category {
        let category = try req.content.decode(Category.self)
        try await category.save(on: req.db)
        return category
    }

    func index(req: Request) async throws -> [Category] {
        try await Category.query(on: req.db).all()
    }

    func show(req: Request) async throws -> Category {
        let category = try await Category.for(req)
        return category
    }

    func getAcronyms(_ req: Request) async throws -> [Acronym] {
        let category = try await Category.for(req)
        return try await category.$acronyms.get(on: req.db)
    }
}

extension Category {
    static func `for`(_ req: Request, on db: Database? = nil) async throws -> Category {
        guard let category = try await Category.find(req.parameters.get("categoryID"), on: db ?? req.db) else {
            throw Abort(.notFound)
        }
        return category
    }
}
