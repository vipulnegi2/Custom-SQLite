//
//  DataBaseManager.swift
//  EkaCareDoctor
//
//  Created by Vipul Negi on 20/08/23.
//
//
import Foundation
import GRDB

class GRDBHelper {
  init() {
    db = openDatabase()
    //    addExtension()
    createTable()
  }
  
  let dbPath: String = "myDb.sqlite"
  var db:OpaquePointer?
  
  func openDatabase() -> OpaquePointer? {
    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent(dbPath)
    print(fileURL)
    var db: OpaquePointer? = nil
    if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
      print("error opening database")
      return nil
    } else {
      print("Successfully opened connection to database at \(dbPath)")
      return db
    }
  }
  
  func createTable() {
    let createTableString = "CREATE VIRTUAL TABLE IF NOT EXISTS pdf4 USING spellfix1;"//(id TEXT PRIMARY KEY,number TEXT,name TEXT,uhid TEXT,profile TEXT,formData TEXT,archived TEXT,link TEXT,created_at TEXT,updated_at TEXT,visits TEXT,followup TEXT,last_visit TEXT);"
    var createTableStatement: OpaquePointer? = nil
    if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
      let val = sqlite3_step(createTableStatement)
      print(val)
      if val == SQLITE_DONE {
        print("patient table created.")
      } else {
        print("patient table could not be created.")
      }
    } else {
      print("CREATE TABLE statement could not be prepared.")
    }
    sqlite3_finalize(createTableStatement)
  }
  
  func saveToSql(patientData: [PatientModel], completion: @escaping ([PatientModel], [PatientModel], Bool) -> Void) {
    var patientArray = [PatientModel]()
    var patientArrayErr = [PatientModel]()
    let chunks = patientData.chunked(into: 35000)
    var successCount = 0
    for i in chunks {
      patientArray = i
      var value = "(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
      for _ in 1..<patientArray.count {
        value += ", (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
      }
      let insertStatementString = "INSERT OR REPLACE INTO patient (id, number, name, uhid, profile, formData, archived, link, created_at, updated_at, visits, followup, last_visit) VALUES \(value);"
      var insertStatement: OpaquePointer? = nil
      if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
        for (index, patient) in patientArray.enumerated() {
          sqlite3_bind_text(insertStatement, Int32(13 * index + 1), ((patient.id ?? "") as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, Int32(13 * index + 2), ((patient.profile?.personal?.phone?.n ?? "") as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, Int32(13 * index + 3), ((patient.profile?.personal?.name ?? "") as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, Int32(13 * index + 4), (("") as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, Int32(13 * index + 5), ((patient.profile?.toJSONString() ?? "") as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, Int32(13 * index + 6), ((patient.formData?.toJSONString() ?? "") as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, Int32(13 * index + 7), ("\(patient.archived ?? false)" as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, Int32(13 * index + 8), ((patient.link?.toJSONString() ?? "") as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, Int32(13 * index + 9), ((patient.created_at ?? "") as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, Int32(13 * index + 10), ((patient.updated_at ?? "") as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, Int32(13 * index + 11), ((patient.visits?.toJSONString() ?? "") as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, Int32(13 * index + 12), ((patient.followup ?? "") as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, Int32(13 * index + 13), ((patient.last_visit ?? "") as NSString).utf8String, -1, nil)
        }
        
        if sqlite3_step(insertStatement) == SQLITE_DONE {
          successCount += 1
        } else {
          for p in patientArray {
            patientArrayErr.append(p)
          }
        }
      } else {
        print("INSERT statement could not be prepared.")
      }
      sqlite3_finalize(insertStatement)
    }
    completion(patientArrayErr, patientData, true)
  }
  
  func read(limit: Int = 100, completion: @escaping ([PatientModel]) -> Void) {
    let queryStatementString = "SELECT * FROM patient ORDER BY updated_at desc LIMIT ?;"
    var queryStatement: OpaquePointer? = nil
    var psns : [PatientModel] = []
    let str = ("\(limit)" as NSString).utf8String
    if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
      if sqlite3_bind_text(queryStatement, 1, str, -1, nil) == SQLITE_OK {
        while sqlite3_step(queryStatement) == SQLITE_ROW {
          if let query = queryStatement {
            psns.append(transformFromDb(queryStatement: query))
          }
        }
      }
    } else {
      print("SELECT statement could not be prepared")
    }
    sqlite3_finalize(queryStatement)
    completion(psns)
  }
  
  func searchByID(searchText: String, completion: @escaping ([PatientModel]) -> Void) {
    let searchStatementString = "SELECT * FROM patient WHERE id MATCH ?"
    var queryStatement: OpaquePointer? = nil
    var psns : [PatientModel] = []
    let str = (searchText as NSString).utf8String
    if sqlite3_prepare_v2(db, searchStatementString, -1, &queryStatement, nil) == SQLITE_OK {
      if sqlite3_bind_text(queryStatement, 1, str, -1, nil) == SQLITE_OK {
        //executing the query to read value , (searchText as NSString).utf8String
        while sqlite3_step(queryStatement) == SQLITE_ROW {
          if let query = queryStatement {
            psns.append(transformFromDb(queryStatement: query))
          }
        }
        
      }
    } else {
      print("SELECT statement could not be prepared")
    }
    sqlite3_finalize(queryStatement)
    completion(psns)
  }
  
  func searchPatient(searchText: String, completion: @escaping ([PatientModel]) -> Void) {
    var queryStatement: OpaquePointer? = nil
    var psns : [PatientModel] = []
    let str = (searchText as NSString).utf8String

    let fuzzyNameString = "SELECT *, editdist3(?, name) as editDist from patient WHERE editDist < 500 ORDER BY editDist;"
    if sqlite3_prepare_v2(db, fuzzyNameString, -1, &queryStatement, nil) == SQLITE_OK {
      if sqlite3_bind_text(queryStatement, 1, str, -1, nil) == SQLITE_OK {
        //executing the query to read value , (searchText as NSString).utf8String
        while sqlite3_step(queryStatement) == SQLITE_ROW {
          if let query = queryStatement {
            psns.append(transformFromDb(queryStatement: query))
          }
        }
        
      }
    } else {
      print("SELECT statement could not be prepared")
    }
    
    sqlite3_finalize(queryStatement)
    completion(psns)
  }
  
}

extension GRDBHelper {
  func transformFromDb(queryStatement: OpaquePointer) -> PatientModel {
    let id = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
    let profileData = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
    let formDatum = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
    let archived = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
    let linkData = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
    let created_at = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
    let updated_at = String(describing: String(cString: sqlite3_column_text(queryStatement, 9)))
    let visitsData = String(describing: String(cString: sqlite3_column_text(queryStatement, 10)))
    let followup = String(describing: String(cString: sqlite3_column_text(queryStatement, 11)))
    let last_visits = String(describing: String(cString: sqlite3_column_text(queryStatement, 12)))

    var profile: ProfileModel?
    var formData: [FormData]?
    var link: [String]?
    var visits: [Visit]?

    if profileData != "" {
      profile = try! JSONDecoder().decode(ProfileModel.self, from: (profileData.data(using: .utf8))!)
    }

    if formDatum != "" {
      formData = try! JSONDecoder().decode([FormData].self, from: (formDatum.data(using: .utf8))!)
    }

    if linkData != "" {
      link = try! JSONDecoder().decode([String].self, from: (linkData.data(using: .utf8))!)
    }

    if visitsData != "" {
      visits = try! JSONDecoder().decode([Visit].self, from: (visitsData.data(using: .utf8))!)
    }

    return PatientModel(id: id, profile: profile, formData: formData, archived: (archived == "false") ? false : true, link: link, created_at: created_at, updated_at: updated_at, visits: visits, followup: followup, last_visit: last_visits)
  }

}
