//
//  DayViewModel.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import Foundation

struct DayViewModel {
    
    struct Matter {
        let isDone: Bool
        let text: String?
        
    }
    
    struct Section {
        let title: String?
        let rows: [Row]
    }
    
    enum Row {
        case matter(Matter)
        case comment(String?)
    }
    
    let title: String?
    let sections: [Section]
}
