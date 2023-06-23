import XCTest
@testable import ToDoList

final class UnitTestsTodoItem: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  //  MARK: JSON tets
  
  func testParseJSONWithAllFields() throws {
    let json: [String: Any] = [
      "id": "12345",
      "text": "finish writing unit tests",
      "priority": "important",
      "deadLine": 1686945208,
      "isDone": false,
      "creationDate": 1686945208,
      "changeDate": 1686945208
    ]
    
    guard let item = ToDoItem.parse(json: json) else {
      print("Parsin error in json")
      return
    }
    
    XCTAssertEqual(item.id, "12345")
    XCTAssertEqual(item.text, "finish writing unit tests")
    XCTAssertEqual(item.importance.rawValue, "important")
    XCTAssertEqual(item.deadLine, Date(timeIntervalSince1970: Double(1686945208)))
    XCTAssertEqual(item.isDone, false)
    XCTAssertEqual(item.creationDate, Date(timeIntervalSince1970: Double(1686945208)))
    XCTAssertEqual(item.changeDate, Date(timeIntervalSince1970: Double(1686945208)))
  }
  
  func testParseJSONWithAllRequiredFields() throws {
    let json: [String: Any] = [
      "text": "finish writing unit tests",
    ]
    
    let item = ToDoItem(text: "finish writing unit tests", importance: .normal, isDone: false)
    
    guard let parsedItem = ToDoItem.parse(json: json) else {
      print("Parsin error in json")
      return
    }
    
    compareTwoItems(item, and: parsedItem)
  }
  
  func testMultipleParseJSON() throws {
    let item1 = ToDoItem(text: "text task 1", importance: .important, isDone: false)
    let json1: [String: Any] = [
      "text": "text task 1",
      "priority": "important"
    ]
    
    let item2 = ToDoItem(text: "text task 2", importance: .normal, isDone: false)
    let json2: [String: Any] = [
      "text": "text task 2"
    ]
    
    let item3 = ToDoItem(text: "text task 3", importance: .unimportant, isDone: false)
    let json3: [String: Any] = [
      "text": "text task 3",
      "priority": "unimportant"
    ]
    
    guard let parsedItem1 = ToDoItem.parse(json: json1),
          let parsedItem2 = ToDoItem.parse(json: json2),
          let parsedItem3 = ToDoItem.parse(json: json3) else {
      print("Parsin error in jsons")
      return
    }
    
    //    check item1 and json1
    compareTwoItems(item1, and: parsedItem1)
    
    //    check item2 and json2
    compareTwoItems(item2, and: parsedItem2)
    
    //    check item3 and json3
    compareTwoItems(item3, and: parsedItem3)
  }
  
  func testConvertTodoItemToJSON() throws {
    let item = ToDoItem(text: "finish writing unit tests", importance: .normal)
    let convertedItem = item.json as? [String: Any]
    
    guard let deadLine = item.deadLine,
          let changeDate = item.changeDate else {
      print("fields of dates are nil")
      return
    }
    
    XCTAssertEqual(item.id, convertedItem?["id"] as! String)
    XCTAssertEqual(item.text, convertedItem?["text"] as! String)
    XCTAssertEqual(item.importance.rawValue, convertedItem?["importance"] as! String)
    XCTAssertEqual(Int(deadLine.timeIntervalSince1970), convertedItem?["deadLine"] as! Int)
    XCTAssertEqual(item.isDone, convertedItem?["isDone"] as! Bool)
    XCTAssertEqual(Int(item.creationDate.timeIntervalSince1970), convertedItem?["creationDate"] as! Int)
    XCTAssertEqual(Int(changeDate.timeIntervalSince1970), convertedItem?["deadLine"] as! Int)
  }
  
  
  //  MARK: CSV test
  
  func testParseCSVWithAllFields() throws {
    let csv = "12345, finish writing unit tests, important, 1686945208, false, 1686945208, 1686945208"
    
    guard let item = ToDoItem.parseCSV(csv: csv) else {
      print("Parsin error in csv")
      return
    }
    
    XCTAssertEqual(item.id, "12345")
    XCTAssertEqual(item.text, "finish writing unit tests")
    XCTAssertEqual(item.importance.rawValue, "important")
    XCTAssertEqual(item.deadLine, Date(timeIntervalSince1970: Double(1686945208)))
    XCTAssertEqual(item.isDone, false)
    XCTAssertEqual(item.creationDate, Date(timeIntervalSince1970: Double(1686945208)))
    XCTAssertEqual(item.changeDate, Date(timeIntervalSince1970: Double(1686945208)))
  }
  
  func testParseCSVWithAllRequiredFields() throws {
    let csv = "12345, finish writing unit tests, important, 1686945208, false, 1686945208, 1686945208"
    let item = ToDoItem(text: "finish writing unit tests", importance: .normal)
    
    guard let parsedItem = ToDoItem.parseCSV(csv: csv) else {
      print("Parsin error in csv")
      return
    }
    
    compareTwoItems(item, and: parsedItem)
  }
  
  func testMultipleParseCSV() throws {
    let item1 = ToDoItem(text: "text task 1", importance: .important)
    let csv1 = ",text task 1, important,,,,"
    
    let item2 = ToDoItem(text: "text task 2", importance: .normal)
    let csv2 = ",text task 2,,,,,"
    
    let item3 = ToDoItem(text: "text task 3", importance: .unimportant)
    let csv3 = ", text task 3, unimportant,,,,"
      
    
    guard let parsedItem1 = ToDoItem.parseCSV(csv: csv1),
          let parsedItem2 = ToDoItem.parseCSV(csv: csv2),
          let parsedItem3 = ToDoItem.parseCSV(csv: csv3) else {
      print("Parsin error in csvs")
      return
    }
    
    //    check item1 and csv1
    compareTwoItems(item1, and: parsedItem1)
    
    //    check item2 and csv2
    compareTwoItems(item2, and: parsedItem2)
    
    //    check item3 and csv3
    compareTwoItems(item3, and: parsedItem3)
  }
  
  func testConvertTodoItemToCSV() throws {
    let item = ToDoItem(text: "finish writing unit tests", importance: .normal)
    let convertedItem = item.csv
    
    let csvString = "\(item.id),\(item.text),,,\(item.isDone),\(item.creationDate.timeIntervalSince1970),"
    
    XCTAssertEqual(convertedItem, csvString)
  }
  

//  MARK: Help func
  
  func compareTwoItems(_ item1: ToDoItem, and item2: ToDoItem) {
    XCTAssertEqual(item1.id, item2.id)
    XCTAssertEqual(item1.text, item2.text)
    XCTAssertEqual(item1.importance.rawValue, item2.importance.rawValue)
    XCTAssertEqual(item1.deadLine, item2.deadLine)
    XCTAssertEqual(item1.isDone, item2.isDone)
    XCTAssertEqual(item1.creationDate, item2.creationDate)
    XCTAssertEqual(item1.changeDate, item2.changeDate)
  }
}


