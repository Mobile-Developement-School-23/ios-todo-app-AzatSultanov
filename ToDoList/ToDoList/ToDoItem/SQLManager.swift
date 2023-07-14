//
//  SQLManager.swift
//  ToDoList
//
//  Created by Азат Султанов on 14.07.2023.
//

import Foundation
import SQLite

protocol ISQLiteStorage {
    //will create DB. If DB was already created will fetch with it
    func fetchOrCreateDB()
    
    func insertOrUpdate(item: ToDoItem)
    func load() -> [ToDoItem]?
    func delete(id: String)
}

final class SQLiteStorage {
    private let fileManager = FileManager.default
    
    private var db: Connection?
    
    private let tableDB = Table("items")
    private let id = Expression<String>("id")
    private let text = Expression<String>("text")
    private let importance = Expression<String>("importance")
    private let deadLine = Expression<Date?>("deadLine")
    private let isDone = Expression<Bool>("isDone")
    private let creationDate = Expression<Date>("creationDate")
    private let changeDate = Expression<Date?>("changeDate")
}

// MARK: - ISQLiteStorage

extension SQLiteStorage: ISQLiteStorage {
    func fetchOrCreateDB() {
        guard let fileURL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appending(path: "db.sqlite") else {
          print("failed found path")
          return
        }
        
        db = try? Connection(fileURL.path)
        
        do {
            try db?.run(tableDB.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(text)
                table.column(importance)
                table.column(deadLine)
                table.column(isDone)
                table.column(creationDate)
                table.column(changeDate)
            })
        } catch {
          print("failed create DB")
        }
    }
    
    func insertOrUpdate(item: ToDoItem) {
        let insertOrReplace = tableDB.insert(
            or: .replace,
            id <- item.id,
            text <- item.text,
            importance <- item.importance.rawValue,
            deadLine <- item.deadLine,
            isDone <- item.isDone,
            creationDate <- item.creationDate,
            changeDate <- item.changeDate
        )
        
        do {
            try db?.run(insertOrReplace)
        } catch {
          print("failed to save")
        }
    }
    
    func load() -> [ToDoItem]? {
        var items: [ToDoItem] = []
        
        do {
            let query = tableDB.select(*)
            
            guard let result = try db?.prepare(query) else { return nil }
            
            for row in result {
                let item = ToDoItem(id: row[id],
                                    text: row[text],
                                    importance: Importance(rawValue: row[importance]) ?? .normal,
                                    deadLine: row[deadLine],
                                    isDone: row[isDone],
                                    creationDate: row[creationDate],
                                    changeDate: row[changeDate])
                
                items.append(item)
            }
        } catch {
          print("failed to load")
        }
        
        return items
    }
    
    func delete(id: String) {
        let deleteQuery = tableDB.filter(id == self.id).delete()
        
        do {
            try db?.run(deleteQuery)
        } catch {
          print("failed delete")
        }
    }
}
