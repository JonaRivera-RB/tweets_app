//
//  RegisterRequest.swift
//  tweets-app
//
//  Created by Misael Rivera on 09/04/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import Foundation

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let names: String
}
