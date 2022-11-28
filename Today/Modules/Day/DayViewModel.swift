//
//  DayViewModel.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import Foundation

struct DayViewModel: DiffableViewModel, Equatable {
    
    class Matter: Hashable {
        
        static func == (lhs: DayViewModel.Matter, rhs: DayViewModel.Matter) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.id)
        }
        
        let id: ObjectIdentifier
        var isDone: Bool
        var text: String?
        
        init(id: ObjectIdentifier, isDone: Bool, text: String?) {
            self.id = id
            self.isDone = isDone
            self.text = text
        }
    }
    
    struct Comment: Hashable {
        let id: UUID
        let text: String?
    }
    
    struct Section: DiffableSection, Hashable {
        
        var header: String?
        let rows: [Row]
    }
    
    enum Row: Hashable {
        case matter(Matter)
        case comment(Comment)
    }
    
    let title: String?
    let sections: [Section]
}
