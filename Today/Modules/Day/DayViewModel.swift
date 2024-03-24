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
    var sections: [Section]
    
    mutating func moveRow(
        at sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        guard let row = self[sourceIndexPath] 
        else { return }
        
        sections[sourceIndexPath.section].rows.remove(at: sourceIndexPath.row)
        sections[destinationIndexPath.section].rows.insert(row, at: destinationIndexPath.row)
    }
    
    struct Section: DiffableSection, Hashable {
        
        var header: String?
        var rows: [Row]
        let type: SectionType
    }
    
    enum SectionType: Int, Hashable {
        
        case necessery
        case needed
        case wanted
        case necesseryButton
        case neededButton
        case wantedButton
        
        init(_ matterType: MatterType) {
            switch matterType {
            case .necessary: self = .necessery
            case .needed: self = .needed
            case .wanted: self = .wanted
            }
        }
        
        var isButton: Bool {
            switch self {
            case .necessery, .needed, .wanted:
                return false
            default:
                return true
            }
        }
    }
    
    enum Row: Hashable {
        case matter(Matter)
        case newMatter(NewMatter)
        
        var id: Int {
            switch self {
            case .matter(let matter):
                matter.id.hashValue
            case .newMatter(let matter):
                matter.sectionType.rawValue
            }
        }
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
