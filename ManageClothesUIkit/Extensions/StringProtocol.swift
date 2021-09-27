//
//  StringProtocol.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/09/27.
//

import Foundation

extension StringProtocol where Self: RangeReplaceableCollection {
  var removeWhitespaces: Self {
    filter { !$0.isWhitespace }
  }
}
