//
//  Module.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import UIKit

final class Module<I: Any> {

    var interactor: I
    var view: UIViewController

    public required init(interactor: I, view: UIViewController) {
        self.interactor = interactor
        self.view = view
    }
}
