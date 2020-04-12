//
//  Routes.swift
//  tweets-app
//
//  Created by Misael Rivera on 09/04/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import Foundation

struct Routes {
    static let API = "https://platzi-tweets-backend.herokuapp.com/api/v1"
    static let LOGIN = Routes.API + "/auth"
    static let REGISTER = Routes.API + "/register"
    static let GET_POST = Routes.API + "/posts"
    static let SEND_POST = Routes.API + "/posts"
    static let DELETE_POST = Routes.API + "/posts/"
}
