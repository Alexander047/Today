//
//  UIImage+Color.swift
//  Razz
//
//  Created by Alexander Sheludchenko on 13.08.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import UIKit

extension UIImage {
    
    convenience init?(_ color: UIColor?, size: CGSize = CGSize(width: 1, height: 1)) {
        guard let color = color else { return nil }
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
