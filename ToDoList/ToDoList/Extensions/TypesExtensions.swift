//
//  TypesExtensions.swift
//  ToDoList
//
//  Created by Азат Султанов on 30.06.2023.
//

import Foundation

extension Date {
  var timeStamp: Int {
    Int(self.timeIntervalSince1970)
  }
}

let dateFormatterWithYear: DateFormatter = {
  let df = DateFormatter()
  df.locale = Locale(identifier: "ru_Ru")
  df.dateFormat = "dd LLLL yyyy"
  return df
}()

func formatDateWithYearToString(_ date: Date) -> String {
  let stringDate = dateFormatterWithYear.string(from: date)
  
  return stringDate
}

let dateFormatterWithoutYear: DateFormatter = {
  let df = DateFormatter()
  df.locale = Locale(identifier: "ru_Ru")
  df.dateFormat = "dd MMM"
  return df
}()

func formatDateWithoutYearToString(_ date: Date) -> String {
  let stringDate = dateFormatterWithoutYear.string(from: date)
  
  return stringDate
}
