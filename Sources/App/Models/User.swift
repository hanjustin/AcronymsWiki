//
//  User.swift
//  
//
//  Created by Justin Lee on 5/7/23.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "username")
    var username: String

    @Children(for: \.$user)
    var acronyms: [Acronym]

    init() {}

    init(id: UUID? = nil, name: String, username: String) {
        self.name = name
        self.username = username
    }
}
