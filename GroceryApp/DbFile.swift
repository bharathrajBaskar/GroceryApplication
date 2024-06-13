//
//  DbFile.swift
//  GroceryApp
//
//  Created by Bharath on 07/06/24.
//

import Foundation
import SQLite3
class DataBaseFile{
    
    var dbPath :String = "groceryDb.sqlite"
    var MainDataPointer:OpaquePointer?
    
    
    init(){
        MainDataPointer = openDatabase()
        
    }
    
    func openDatabase() -> OpaquePointer?{
        do{
            let documentUrl = try FileManager.default.url(for:.documentDirectory ,in: .userDomainMask,appropriateFor: nil,create: false)
            UserDefaults.standard.setValue(documentUrl.absoluteString, forKey: kForFileManagerPath)
            let fileUrl = documentUrl.appendingPathComponent(dbPath)
            var dbpointer : OpaquePointer? = nil
            if sqlite3_open(fileUrl.path, &dbpointer) == SQLITE_OK{
                print("Successfullt opened the database")
                return dbpointer
            }
            else{
                print("Unable to open the database ")
                return nil
            }
            
        }
        catch{
            print("OpenDatabase catch block")
            return nil
        }
        
    }
    func createOrderTable(){
        let createTableQuery = """
     CREATE TABLE IF NOT EXISTS orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date_of_order DATE,
            no_of_products INTEGER
);

"""
        
    }
    
    
/*
 func createTable() {
     let createTableString = """
         CREATE TABLE IF NOT EXISTS newusers (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             name TEXT,
             date_of_birth DATE,
             phone_no TEXT CHECK (LENGTH(phone_no) = 10),
             image TEXT,
             email TEXT UNIQUE
         );
     """

     var localPointer: OpaquePointer?
     if sqlite3_prepare_v2(MainDbPointer, createTableString, -1, &localPointer, nil) == SQLITE_OK {
         if sqlite3_step(localPointer) == SQLITE_DONE {
             print("Table created successfully")
         } else {
             let errorMessage = String(cString: sqlite3_errmsg(MainDbPointer)!)
             print("Failed to create table: \(errorMessage)")
         }
     } else {
         let errorMessage = String(cString: sqlite3_errmsg(MainDbPointer)!)
         print("Failed to prepare create table statement: \(errorMessage)")
     }

     sqlite3_finalize(localPointer)
 }
 */
    
}
