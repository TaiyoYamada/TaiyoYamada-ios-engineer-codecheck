//
//  Owner.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田大陽 on 2025/08/26.
//  Copyright © 2025 YUMEMI Inc. All rights reserved.
//


import Foundation

struct Owner: Codable {
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}
