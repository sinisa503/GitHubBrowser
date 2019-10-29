//
//  RoundedButton.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

   
   override func layoutSubviews() {
      super.layoutSubviews()
    
      self.layer.cornerRadius = self.bounds.height / 3
      self.layer.masksToBounds = true
   }
}
