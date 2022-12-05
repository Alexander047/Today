//
//  DayDiffableDataSource.swift
//  Today
//
//  Created by Alexander on 02.12.2022.
//

import UIKit

final class DayDiffableDataSource: UITableViewDiffableDataSource<DayViewModel.Section, DayViewModel.Row> {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
