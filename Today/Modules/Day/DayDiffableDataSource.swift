//
//  DayDiffableDataSource.swift
//  Today
//
//  Created by Alexander on 02.12.2022.
//

import UIKit

final class DayDiffableDataSource: UITableViewDiffableDataSource<DayViewModel.SectionType, Int> {
    
    override func tableView(
        _ tableView: UITableView,
        canEditRowAt indexPath: IndexPath
    ) -> Bool {
        let sectionType = snapshot().sectionIdentifiers[indexPath.section]
        return !sectionType.isButton
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            
        }
    }
}
