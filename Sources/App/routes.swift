import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.post("api", "acronyms") { req async throws -> Acronym in
        let acronym = try req.content.decode(Acronym.self)
        try await acronym.save(on: req.db)
        return acronym
    }
    
    app.get("api", "acronyms") { req async throws -> [Acronym] in
        try await Acronym.query(on: req.db).all()
    }
    
    app.get("api", "acronyms", ":acronymID") { req async throws -> Acronym in
        guard let acronym = try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return acronym
    }
    
    app.put("api", "acronyms", ":acronymID") { req async throws -> Acronym in
        guard let acronym = try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedAcronym = try req.content.decode(Acronym.self)
        acronym.short = updatedAcronym.short
        acronym.long = updatedAcronym.long
        try await acronym.save(on: req.db)
        return acronym
    }
    
    app.delete("api", "acronyms", ":acronymID") { req async throws -> HTTPStatus in
        guard let acronym = try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await acronym.delete(on: req.db)
        return .noContent
    }
    
    app.get("api", "acronyms", "search") { req async throws -> [Acronym] in
        guard let searchTerm = req.query[String.self, at: "term"] else {
          throw Abort(.badRequest)
        }
        return try await Acronym.query(on: req.db)
            .filter(\.$short == searchTerm)
            .all()
    }
}
