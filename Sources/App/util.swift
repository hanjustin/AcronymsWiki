//
//  util.swift
//  
//
//  Created by Justin Lee on 6/4/23.
//

import Foundation

func ??<T>(lhs: Optional<T>, rhs: Error) throws -> T {
    switch lhs {
    case .none:
        throw rhs
    case .some(let val):
        return val
    }
}


//func ??<T>(lhs: Optional<T>, rhs: () throws -> ()) throws -> T {
//    switch lhs {
//    case .none:
//        try rhs()
//    case .some(let val):
//        return val
//    }
//
//    fatalError()
//}

//func test() async throws -> Int {
//    let num: Int? = nil
//    let test: () throws -> Int = {
//            throw Abort(.notFound)
//    }
//    return try await num ?? test
//}
//
//func lala() throws {
//
//}
