//
//  Diffable.swift
//  Wildberries
//
//  Created by Alexander Sheludchenko on 23.12.2019.
//  Copyright © 2019 Wildberries LLC. All rights reserved.
//

import Foundation

struct ViewModelDiff {
    struct Item {
        var sections: IndexSet?
        var rows: [IndexPath]?
    }
    
    var toDelete = Item()
    var toReload = Item()
    var toInsert = Item()
}
extension ViewModelDiff {
    var isEmpty: Bool {
        return toDelete.isEmpty && toReload.isEmpty && toInsert.isEmpty
    }
}
extension ViewModelDiff.Item {
    var isEmpty: Bool {
        return sections == nil && rows?.isEmpty != false
    }
}

protocol DiffableViewModel {
    
    associatedtype Section: (DiffableSection & Equatable)
    
    var sections: [Section] { get }
    
    func diffWithOldModel(_ oldModel: Self) -> ViewModelDiff
}

protocol DiffableSection {
    
    associatedtype Header: Equatable
    associatedtype Row: Equatable
    
    var header: Header? { get }
    var rows: [Row] { get }
}

extension DiffableViewModel {

    func diffWithOldModel(_ oldModel: Self) -> ViewModelDiff {
        
        var diff = ViewModelDiff()
        
        let minSectionsCount = min(sections.count, oldModel.sections.count)
        
        if oldModel.sections.count > sections.count {
            diff.toDelete.sections = IndexSet(integersIn: sections.count..<oldModel.sections.count)
        }
        
        var rowsToDelete: [IndexPath] = []
        for section in 0..<minSectionsCount {
            let oldRowsCount = oldModel.sections[section].rows.count
            let newRowsCount = sections[section].rows.count
            if oldRowsCount > newRowsCount {
                (newRowsCount..<oldRowsCount).forEach({ rowsToDelete.append(IndexPath(row: $0, section: section)) })
            }
        }
        diff.toDelete.rows = rowsToDelete.isEmpty ? nil : rowsToDelete
        
        let sectionsToReload = (0..<minSectionsCount).filter({ oldModel.sections[$0].header != sections[$0].header })
        diff.toReload.sections = sectionsToReload.isEmpty ? nil : IndexSet(sectionsToReload)
        
        var rowsToReload: [IndexPath] = []
        for section in 0..<minSectionsCount {
            let oldRows = oldModel.sections[section].rows
            let newRows = sections[section].rows
            for row in 0..<min(oldRows.count, newRows.count) {
                if oldRows[row] != newRows[row] {
                    rowsToReload.append(IndexPath(row: row, section: section))
                }
            }
        }
        diff.toReload.rows = rowsToReload.isEmpty ? nil : rowsToReload
        
        if sections.count > oldModel.sections.count {
            diff.toInsert.sections = IndexSet(integersIn: oldModel.sections.count..<sections.count)
        }
        
        var rowsToInsert: [IndexPath] = []
        for section in 0..<minSectionsCount {
            let oldRowsCount = oldModel.sections[section].rows.count
            let newRowsCount = sections[section].rows.count
            if oldRowsCount < newRowsCount {
                (oldRowsCount..<newRowsCount).forEach({ rowsToInsert.append(IndexPath(row: $0, section: section)) })
            }
        }
        diff.toInsert.rows = rowsToInsert.isEmpty ? nil : rowsToInsert
        
        return diff
    }
}
