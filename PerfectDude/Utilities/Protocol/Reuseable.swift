//
//  Reuseable.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseID: String { get }
}

extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}
extension UICollectionReusableView: Reusable {}

extension UICollectionView {
    func dequeueReusableCell<T>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseID,
                                             for: indexPath) as? T else {
                                                fatalError("❌ Failed to find cell!")
        }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T>(ofKind kind: String, ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UICollectionReusableView {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cellType.reuseID, for: indexPath) as? T else {
            fatalError("❌ Failed to find cell!")
        }
        return view
    }
}

extension UITableView {
    func dequeueReusableCell<T>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseID,
                                             for: indexPath) as? T else {
                                                fatalError("❌ Failed to find cell!")
        }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T>(ofType cellType: T.Type = T.self) -> T where T: UITableViewHeaderFooterView {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: cellType.reuseID) as? T else {
            fatalError("❌ Failed to find cell!")
        }
        return headerFooterView
    }
    
    func registerHeaderFooterView<T>(ofType cellType: T.Type = T.self) where T: UITableViewHeaderFooterView {
        register(UINib(nibName: cellType.reuseID, bundle: nil), forHeaderFooterViewReuseIdentifier: cellType.reuseID)
    }
}
