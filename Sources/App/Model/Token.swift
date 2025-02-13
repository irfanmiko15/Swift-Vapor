//
//  Token.swift
//  vapor_postgresql_example
//
//  Created by Irfan Dary Sujatmiko on 12/02/25.
//

import Fluent
import Vapor

final class Token: Model, Content, @unchecked Sendable {
    static let schema = "tokens"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "tokenValue")
    var tokenValue: String
    
    @Parent(key: "userID")
    var user: User
    
    init() { }
    
    init(id: UUID? = nil, tokenValue: String, userID: User.IDValue) {
        self.id = id
        self.tokenValue = tokenValue
        self.$user.id = userID
    }
}

extension Token {
    static func generate(for user: User) throws -> Token {
        let random = [UInt8].random(count: 32).base64
        return try Token(tokenValue: random, userID: user.requireID())
    }
}

extension Token: ModelTokenAuthenticatable {
    typealias User = App.User
    
    static let valueKey = \Token.$tokenValue
    static let userKey = \Token.$user
    
    var isValid: Bool {
        true
    }
}
