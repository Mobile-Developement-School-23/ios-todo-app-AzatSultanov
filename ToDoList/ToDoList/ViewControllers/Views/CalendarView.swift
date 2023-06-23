//
//  CalendarView.swift
//  ToDoList
//
//  Created by Азат Султанов on 22.06.2023.
//

import UIKit

class CalendarView: UIView {
  
  private let calendarView: UICalendarView = {
    let calendarView = UICalendarView()
    let gregorianCalendar = Calendar(identifier: .gregorian)
    calendarView.calendar = gregorianCalendar
    calendarView.tintColor = .systemBlue
    calendarView.availableDateRange = DateInterval(start: .now, end: .distantFuture)
    calendarView.translatesAutoresizingMaskIntoConstraints = false
    return calendarView
  }()
  
  private var selection: UICalendarSelectionSingleDate?
  private weak var delegate: UICalendarSelectionSingleDateDelegate?
  
  init() {
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    addSubview(calendarView)
    
    NSLayoutConstraint.activate([
      calendarView.topAnchor.constraint(equalTo: topAnchor, constant: 1),
      calendarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      calendarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
      calendarView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
    ])
  }
  
  public func setCalendarDelegate(delegate: UICalendarSelectionSingleDateDelegate) {
    selection = UICalendarSelectionSingleDate(delegate: delegate)
    calendarView.selectionBehavior = selection
    
  }
  
  public func setup(selectedDate: Date?) {
    if let selectedDate {
      let dateComponent = Calendar.current.dateComponents(in: .current, from: selectedDate)
      selection?.setSelected(dateComponent, animated: true)
    } else if let date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
      let dateComponent = Calendar.current.dateComponents(in: .current, from: date)
      selection?.setSelected(dateComponent, animated: true)
    }
  }
}
