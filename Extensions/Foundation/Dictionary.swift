//
//  Dictionary.swift
//  Today
//
//  Created by Alexander on 05.12.2022.
//

import Foundation

extension Dictionary<MatterType, [Matter]> {
    
    func elapsedByPriority() -> [Matter] {
        let filtered = (self[.necessary] ?? []) + (self[.needed] ?? []) + (self[.wanted] ?? []).filter { !$0.done }
        return filtered
    }
}
