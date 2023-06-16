

import Foundation

enum Importance: String {
    case unimportant
    case important
    case normal
}

extension ToDoItem {
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



