//
//  CalendarViewModel.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import Foundation

struct CalendarViewModel {
    
    let sections: [Section]
    
    subscript (row indexPath: IndexPath) -> Row? {
        return sections[safe: indexPath.section]?.rows[indexPath.row]
    }
}

extension CalendarViewModel {
    
    struct Section {
        let title: String
        let rows: [Row]
    }
    
    enum Row {
        case day(Day)
        case spacer
    }
    
    struct Day {
        let day: Int
        let month: Int
        let year: Int
        
        let isWeekend: Bool
        let hasMatters: Bool
    }
}
