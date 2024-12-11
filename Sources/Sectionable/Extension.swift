//
//  Extension.swift
//
//
//  Created by SeoJunYoung on 12/11/24.
//

import UIKit

public extension UITableViewCell {
    static var identifiers: String {
        return String(describing: self)
    }
}

public extension UICollectionViewCell {
    static var identifiers: String {
        return String(describing: self)
    }
}

public extension UICollectionReusableView {
    var identifiers: String {
        return String(describing: self)
    }
}
