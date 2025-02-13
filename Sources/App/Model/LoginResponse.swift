//
//  LoginResponse.swift
//  vapor_postgresql_example
//
//  Created by Irfan Dary Sujatmiko on 12/02/25.
//

import Vapor
struct LoginResponse: Content {
    let email: String
    let token: String
    let id: UUID
}

