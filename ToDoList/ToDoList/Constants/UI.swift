//
//  UI.swift
//  ToDoList
//
//  Created by Азат Султанов on 22.06.2023.
//

import Foundation
import UIKit

enum Colors {
  
  enum LightTheme {
    //  back
    static let backPrimary = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
    static let backElevated = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    //  label
    static let labelPrimary = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    static let labelTertiary = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
    static let labelDisable = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.15)
    
    //    system
    static let red = UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0)
    static let green = UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1.0)
    static let blue = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
    
    //    support
    static let supportSeparator = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
    static let supportOverlay = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.06)
    
    static let lightGray = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1.0)
  }
  
  enum DarkTheme {
    //  back
    static let backPrimary = UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1.0)
    static let backElevated = UIColor(red: 0.23, green: 0.23, blue: 0.25, alpha: 1.0)
    
    //  label
    static let labelPrimary = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let labelTertiary = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
    static let labelDisable = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.15)
    
    //    system
    static let red = UIColor(red: 1.0, green: 0.27, blue: 0.23, alpha: 1.0)
    static let green = UIColor(red: 0.2, green: 0.84, blue: 0.29, alpha: 1.0)
    static let blue = UIColor(red: 0.04, green: 0.52, blue: 1.0, alpha: 1.0)
    
    //    support
    static let supportSeparator = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
    static let supportOverlay = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.32)
    
  }
}


enum Images {
  static let imageSegment1 = UIImage(named: "lowPriority")
  static let imageSegment3 = UIImage(named: "important")
}
