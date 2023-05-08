//
//  Acronym.swift
//  
//
//  Created by Justin Lee on 5/5/23.
//

import Vapor
import Fluent

final class Acronym: Model, Content {
    static let schema = "acronyms"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "short")
    var short: String
    
    @Field(key: "long")
    var long: String
    
    @Parent(key: "userID")
    var user: User
    
    init() {}
    
    init(id: UUID? = nil, short: String, long: String, userID: User.IDValue) {
        self.id = id
        self.short = short
        self.long = long
        self.$user.id = userID
    }
}
