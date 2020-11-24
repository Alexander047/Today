//
//  UITableView+Diffable.swift
//  Razz
//
//  Created by Alexander Sheludchenko on 31.07.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import UIKit

extension UITableView {
    func updateWithDiff(_ diff: ViewModelDiff, animation: UITableView.RowAnimation = .fade) {
        guard !diff.isEmpty else { return }
        func performUpdates() {
            if let sections = diff.toDelete.sections {
                deleteSections(sections, with: animation)
            }
            if let indexPaths = diff.toDelete.rows {
                deleteRows(at: indexPaths, with: animation)
            }
            if let sections = diff.toReload.sections {
                reloadSections(sections, with: animation)
            }
            if let indexPaths = diff.toReload.rows {
                reloadRows(at: indexPaths, with: animation)
            }
            if let sections = diff.toInsert.sections {
                insertSections(sections, with: animation)
            }
            if let indexPaths = diff.toInsert.rows {
                insertRows(at: indexPaths, with: animation)
            }
        }
        performBatchUpdates(performUpdates, completion: nil)
    }
}
