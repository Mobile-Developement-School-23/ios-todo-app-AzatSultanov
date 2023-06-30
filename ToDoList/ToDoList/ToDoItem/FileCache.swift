
import Foundation

// MARK: protocols
protocol JsonFunc {
  var dictToDo: [String: ToDoItem] { get }
  func add(toDoItem: ToDoItem) -> ToDoItem?
  
  func remove(id: String) -> ToDoItem?
}

// MARK: enums
private enum FileFormat: String {
  case json = ".json"
  case csv = ".csv"
}

class FileCache: JsonFunc {
  private(set) var dictToDo: [String: ToDoItem] = [:]
  
  // MARK: add & remove funcs
  func add(toDoItem: ToDoItem) -> ToDoItem? {
    if let replacedItem = dictToDo[toDoItem.id] {
      dictToDo[toDoItem.id] = toDoItem
      return replacedItem
    } else {
      dictToDo[toDoItem.id] = toDoItem
      return nil
    }
  }
  
  func remove(id: String) -> ToDoItem? {
    if let removedItem = dictToDo[id] {
      dictToDo[id] = nil
      return removedItem
    } else {
      print("There is no item with this id")
      return nil
    }
    
  }
}

extension FileCache {
  
  // MARK: work with JSON
  func loadFromJSON(name: String) {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      print("Файл не найден")
      return
    }
    let pathToFile = documentDirectory.appendingPathComponent(name + FileFormat.json.rawValue)
    guard let data = try? Data(contentsOf: pathToFile) else {
      print("Файл поврежден")
      return
    }
    guard let jsonFile = try? JSONSerialization.jsonObject(with: data) as? [Any] else {
      print("Не можем распарсить")
      return
    }
    
    for jsonItem in jsonFile {
      if let parsedItem = ToDoItem.parse(json: jsonItem) {
        add(toDoItem: parsedItem)
      }
    }
  }
  
  func saveToJSON(name: String) {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      print("Директория не найдена")
      return
    }
    let pathToFile = documentDirectory.appendingPathComponent(name + FileFormat.json.rawValue)
    let jsonItem = dictToDo.map {
      $0.value.json
    }
    guard let data = try? JSONSerialization.data(withJSONObject: jsonItem) else {
      print("Ошибка преобразования в json")
      return
    }
    
    
    guard ((try? data.write(to: pathToFile)) != nil) else {
      print("Ошибка при сохранении файла")
      return
    }
  }
  
  // MARK: work with CSV
  
  func loadFromCSV(name: String) {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      print("Файл не найден")
      return
    }
    let pathToFile = documentDirectory.appendingPathComponent(name + FileFormat.csv.rawValue)
    guard let data = try? String(contentsOf: pathToFile, encoding: .utf8) else {
      print("Файл поврежден")
      return
    }
    var rows = data.components(separatedBy: "\n")
    rows.removeFirst()
    for row in rows {
      if let parsedItem = ToDoItem.parseCSV(csv: row) {
        add(toDoItem: parsedItem)
      }
    }
  }
  
  func saveToCSV(name: String) {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      print("Файл не найден")
      return
    }
    let pathToFile = documentDirectory.appendingPathComponent(name + FileFormat.csv.rawValue)
    var csvItem = dictToDo.map { $0.value.csv }
    csvItem.insert("id,text,importance,deadLine,isDone,creationDate,changeDate", at: 0)
    let csvString = csvItem.joined(separator: "\n")
    guard ((try? csvString.write(to: pathToFile, atomically: true, encoding: .utf8)) != nil) else {
      print("Ошибка при записи")
      return
    }
  }
  
}
