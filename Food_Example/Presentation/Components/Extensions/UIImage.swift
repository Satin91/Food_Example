//
//  UIImage.swift
//  Food_Example
//
//  Created by Артур Кулик on 08.02.2023.
//

import UIKit

extension UIImage {
    func hasWhiteBorder() -> Bool {
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int =
            ((Int(self.size.width) * Int(5)) + Int(5)) * 4
        let red = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let green = CGFloat(data[pixelInfo + 1]) / CGFloat(255.0)
        let blue = CGFloat(data[pixelInfo + 2]) / CGFloat(255.0)
        let alpha = CGFloat(data[pixelInfo + 3]) / CGFloat(255.0)
        print(red, green, blue, alpha)
        if red == 1.0, green == 1.0, blue == 1.0, alpha == 1.0 {
            return true
        }
        return false
    }
}
