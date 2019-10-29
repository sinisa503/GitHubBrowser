//
//  UIInt64+Ext.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation

import Foundation

extension UInt64 {
   func megabytes() -> UInt64 {
      return self * 1024 * 1024
   }
}
