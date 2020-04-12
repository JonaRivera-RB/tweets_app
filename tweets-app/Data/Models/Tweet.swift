//
//  Tweet.swift
//  tweets-app
//
//  Created by Misael Rivera on 09/04/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import Foundation

struct Tweet: Codable {
    let id: String
    let author: User
    let imageUrl: String
    let text: String
    let videoUrl: String
    let location: Location
    let hasVideo: Bool
    let hasImage: Bool
    let hasLocation: Bool
    let createdAt: String
}
