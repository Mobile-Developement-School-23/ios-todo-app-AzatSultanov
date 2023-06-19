

import Foundation

// MARK: enums
enum Importance: String {
    case unimportant
    case important
    case normal
}

// MARK: ToDoItem struct
struct ToDoItem {
    let id: String
    let text: String
    let importance: Importance
    let deadLine: Date?
    let isDone: Bool
    let creationDate: Date
    let changeDate: Date?
    init(id: String = UUID().uuidString, text: String, importance: Importance, deadLine: Date? = nil, isDone: Bool, creationDate: Date = Date(), changeDate: Date? = nil) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadLine = deadLine
        self.isDone = isDone
        self.creationDate = creationDate
        self.changeDate = changeDate
    }
}

// MARK: extension for JSON
extension ToDoItem {
    
    // MARK: JSON save & parse
    var json: Any {
        var dictionary: [String: Any] = [:]
        dictionary["id"] = self.id
        dictionary["text"] = self.text
        dictionary["creationDate"] = self.creationDate.timeIntervalSince1970
        if self.deadLine != nil {
            dictionary["deadLine"] = self.deadLine?.timeIntervalSince1970
        }
        dictionary["isDone"] = self.isDone
        if let chDate = self.changeDate {
            dictionary["changeDate"] = chDate.timeIntervalSince1970
        }
        if self.importance != .normal {
            dictionary["importance"] = self.importance.rawValue
        }
        return dictionary
    }
    
    static func parse(json: Any) -> ToDoItem? {
        guard let jsDict = json as? [String:Any] else {
            return nil
        }
        guard let id = jsDict["id"] as? String,
              let text = jsDict["text"] as? String,
              let creationDate = jsDict["creationDate"] as? Double else { return nil }
        let importance = jsDict["importance"] as? Importance ?? .normal
        let deadLine = (jsDict["deadLine"] as? Double).flatMap { Date(timeIntervalSince1970: TimeInterval($0)) }
        let isDone = jsDict["isDone"] as? Bool ?? false
        let changeDate = (jsDict["changeDate"] as? Double).flatMap { Date(timeIntervalSince1970: TimeInterval($0)) }
        return ToDoItem(id: id, text: text, importance: importance, deadLine: deadLine, isDone: isDone, creationDate: Date(timeIntervalSince1970: creationDate), changeDate: changeDate)
    }
    
}

// MARK: extension for CSV
extension ToDoItem {
    static func parseCSV(csv: String) -> ToDoItem? {
        let columns = csv.components(separatedBy: ",")
        guard columns.count >= 7,
              let id = columns[0].isEmpty ? nil : columns[0],
              let text = columns[1].isEmpty ? nil : columns[1],
              let creationDateDouble = Double(columns[5])
          else {
              return nil
          }
        let importance = Importance(rawValue: columns[2]) ?? .normal
        let deadLine = Double(columns[3]).flatMap { Date(timeIntervalSince1970: TimeInterval($0)) }
        let isDone = Bool(columns[4]) ?? false
        let creationDate = Date(timeIntervalSince1970: creationDateDouble)
        let changeDate = Double(columns[6]).flatMap { Date(timeIntervalSince1970: TimeInterval($0)) }
        return ToDoItem(
            id: id,
            text: text,
            importance: importance,
            deadLine: deadLine,
            isDone: isDone,
            creationDate: creationDate,
            changeDate: changeDate)
    }
    
    var csv: String {
            return [
                id,
                text,
                importance == .normal ? "" : importance.rawValue,
                deadLine.flatMap { "\($0.timeIntervalSince1970)" } ?? "",
                String(isDone),
                "\(creationDate.timeIntervalSince1970)",
                changeDate.flatMap { "\($0.timeIntervalSince1970)" } ?? ""
            ].joined(separator: ",")
        }
}





