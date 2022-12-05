//
//  DayViewModel.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import Foundation

struct DayViewModel: DiffableViewModel, Equatable {
    
    let title: String?
    let sections: [Section]
    
    struct Section: DiffableSection, Hashable {
        
        var header: String?
        let rows: [Row]
        let type: SectionType
    }
    
    enum SectionType: Int, Hashable {
        
        case necessery
        case needed
        case wanted
        
        init(_ matterType: MatterType) {
            switch matterType {
            case .necessary: self = .necessery
            case .needed: self = .needed
            case .wanted: self = .wanted
            }
        }
    }
    
    enum Row: Hashable {
        case matter(Matter)
        case newMatter(NewMatter)
    }
    
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
        let isEditable: Bool
        let sectionType: SectionType
        
        init(id: ObjectIdentifier, isDone: Bool, text: String?, isEditable: Bool, sectionType: SectionType) {
            self.id = id
            self.isDone = isDone
            self.text = text
            self.isEditable = isEditable
            self.sectionType = sectionType
        }
    }
    
    struct NewMatter: Hashable {
        let sectionType: SectionType
    }
}
