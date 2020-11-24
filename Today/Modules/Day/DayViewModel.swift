//
//  DayViewModel.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import Foundation

struct DayViewModel: DiffableViewModel {
    
    class Matter: Equatable {
        static func == (lhs: DayViewModel.Matter, rhs: DayViewModel.Matter) -> Bool {
            return lhs === rhs
        }
        
        var isDone: Bool
        var text: String?
        
        init(isDone: Bool, text: String?) {
            self.isDone = isDone
            self.text = text
        }
    }
    
    struct Section: DiffableSection, Equatable {
        
        typealias Header = String
        
        var header: String?
        let rows: [Row]
    }
    
    enum Row: Equatable {
        case matter(Matter)
        case comment(String?)
    }
    
    let title: String?
    let sections: [Section]
}
