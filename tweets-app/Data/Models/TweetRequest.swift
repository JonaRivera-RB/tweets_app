//
//  TweetRequest.swift
//  tweets-app
//
//  Created by Misael Rivera on 09/04/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import Foundation

struct TweetRequest: Codable {
    let text: String
    let imageUrl: String?
    let videoUrl: String?
    let location: Location?
}
