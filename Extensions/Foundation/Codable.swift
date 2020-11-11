//
//  Codable.swift
//  Razz
//
//  Created by Alexander on 07.05.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import Foundation

extension Encodable {
    
    func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}

extension Decodable {
    
    static func decoded(from data: Data) -> Self? {
        return try? JSONDecoder().decode(Self.self, from: data)
    }
}

