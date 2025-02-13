//
//  UserController.swift
//  vapor_postgresql_example
//
//  Created by Irfan Dary Sujatmiko on 12/02/25.
//
import Vapor
import Fluent
struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("api", "v1", "users")
        
        let basicAuthMiddleware = User.authenticator()
        let basicAuthGroup = users.grouped(basicAuthMiddleware)
        basicAuthGroup.post("login", use: loginHandler)
        users.post("register",use: create)
    }
    
    @Sendable func loginHandler(_ req: Request) async throws -> BaseResponse<LoginResponse> {
        let user = try req.auth.require(User.self)
        let token = try Token.generate(for: user)
        try await token.save(on: req.db)  

            return BaseResponse(
                success: true,
                statusCode: 200,
                message: "Login Successfully",
                errors: [],
                data: LoginResponse(
                    email: user.email,
                    token: token.tokenValue,
                    id: try user.requireID()
                   
                )
            )
    }
    // MARK: - Create
    @Sendable func create(_ req: Request) throws -> BaseResponse<User> {
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        user.save(on: req.db).map {
            user.convertToPublic()
        }
        
        return BaseResponse(success: true, statusCode: 200, message: "Success create user", errors: [], data: User(id: user.id,email: user.email, password: ""))
    }
}
