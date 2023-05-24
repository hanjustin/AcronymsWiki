//
//  Application+Testable.swift
//  
//
//  Created by Justin Lee on 5/21/23.
//

import XCTVapor
import App

extension Application {
    static func testable() async throws -> Application {
        let app = Application(.testing)
        try await configure(app)

        try await app.autoRevert()
        try await app.autoMigrate()

        return app
    }
}
