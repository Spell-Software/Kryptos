//
//  Utilities.swift
//  Kryptos
//
//  Created by Craig Spell on 7/13/17.
//  Copyright © 2017 Spell Software Inc. All rights reserved.
//

import Foundation

extension String {

    func reversed() -> String {

        let str = self.map({ return String.init($0) })
        return Array(str.reversed()).joined()
    }

    func letterArray() -> [String] {
        return self.map({ return String.init($0) })
    }
}
