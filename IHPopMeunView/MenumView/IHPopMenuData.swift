//
//  IHPopMenuData.swift
//  iGenealogy
//
//  Created by hlf on 2022/7/4.
//

import Foundation
import UIKit

struct IHPopMenuData {
    var action: String = ""
    var text: String = ""
    init(action: String, text: String) {
        self.action = action
        self.text = text
    }
}

struct MenuConstant {
    static let cellId: String = "IGPopOverMenuCellIdentifier"
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let bottomSafeHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
    static let width = 112.0
    static let allowSize: CGSize = CGSize(width: 15, height: 15)
    static let cellHeight = 44.0
    static let cellMargin = 18.0
    static let cellPadding = 12.0
}
