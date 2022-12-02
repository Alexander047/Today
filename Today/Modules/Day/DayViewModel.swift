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
        let sectionType: SectionType
        
        init(id: ObjectIdentifier, isDone: Bool, text: String?, sectionType: SectionType) {
            self.id = id
            self.isDone = isDone
            self.text = text
            self.sectionType = sectionType
        }
    }
    
    struct NewMatter: Hashable {
        let sectionType: SectionType
    }
    
    struct Section: DiffableSection, Hashable {
        
//        static func == (lhs: DayViewModel.Section, rhs: DayViewModel.Section) -> Bool {
//            return lhs.type == rhs.type
//        }
//        
//        func hash(into hasher: inout Hasher) {
//            hasher.combine(type)
//        }
        
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
    
    let title: String?
    let sections: [Section]
}
