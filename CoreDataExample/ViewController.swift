//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Vipul Negi on 14/08/23.
//

import Foundation
import SwiftUI
import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var searchText: UITextField!
  @IBOutlet weak var consoleLogView: UITextView!
  
  var patientData = [PatientModel]()
  var db: GRDBHelper = GRDBHelper()
//  var defaultPatientModelCache = DefaultPatientModelCache()
//  var coreData = CoreDataStack.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    hideKeyboardWhenTappedAround()
    
    getPatientData(number: 100) { _ in
      DispatchQueue.main.async { [self] in
        consoleLogView.text = "data added in array"
      }
    }
  }
  
  func getPatientData(number: Int, completion: @escaping (Bool) -> Void) {
    NetworkManager.shared.getApiCall(url: "https://parchi.eka.care/app/get/patientdirectory/") { [self] value in
//      patientData = (value?.data)!
      addPatientData(number: number) { sucess in
        completion(true)
      }
    }
  }
  
  func addPatientData(number: Int, completion: @escaping (Bool) -> Void) {
    var dummyData = PatientModel(id: UUID().uuidString, profile: ProfileModel(personal: Personal(name: "Abhishek Singh", age: Age(dob: "1996-07-02"), phone: Phone(c: "+91", n: "9997414678"), gender: "Male", bloodgroup: "B +ve", onApp: false)), formData: [FormData(label: "", type: "", key: "")], archived: false, link: [""], created_at: "2023-05-24T16:08:40.118Z", updated_at: "2023-08-14T11:41:43.059Z", visits: [Visit(vid: "V-DW-1684963207468-161467756044203-WFIJ", visit_date: "2023-05-25T09:40:04.796Z", url: "https://prescription-store-s3.dev.eka.care/P-MW-09EAB4D2-9CB5-5524-914B-EEAA91F63940.pdf", pxid: "P-MW-09EAB4D2-9CB5-5524-914B-EEAA91F63940", name: "Visit on May 25th 2023, 3:10 pm", clinicid: "60b8a8fe31b23b642ff99de9", status: "CM"), Visit(vid: "V-DW-1684963207468-161467756044203-WFIJ", visit_date: "2023-05-25T09:40:04.796Z", url: "https://prescription-store-s3.dev.eka.care/P-MW-09EAB4D2-9CB5-5524-914B-EEAA91F63940.pdf", pxid: "P-MW-09EAB4D2-9CB5-5524-914B-EEAA91F63940", name: "Visit on May 25th 2023, 3:10 pm", clinicid: "60b8a8fe31b23b642ff99de9", status: "CM"), Visit(vid: "V-DW-1684963207468-161467756044203-WFIJ", visit_date: "2023-05-25T09:40:04.796Z", url: "https://prescription-store-s3.dev.eka.care/P-MW-09EAB4D2-9CB5-5524-914B-EEAA91F63940.pdf", pxid: "P-MW-09EAB4D2-9CB5-5524-914B-EEAA91F63940", name: "Visit on May 25th 2023, 3:10 pm", clinicid: "60b8a8fe31b23b642ff99de9", status: "CM"), Visit(vid: "V-DW-1684963207468-161467756044203-WFIJ", visit_date: "2023-05-25T09:40:04.796Z", url: "https://prescription-store-s3.dev.eka.care/P-MW-09EAB4D2-9CB5-5524-914B-EEAA91F63940.pdf", pxid: "P-MW-09EAB4D2-9CB5-5524-914B-EEAA91F63940", name: "Visit on May 25th 2023, 3:10 pm", clinicid: "60b8a8fe31b23b642ff99de9", status: "CM"), Visit(vid: "V-DW-1684963207468-161467756044203-WFIJ", visit_date: "2023-05-25T09:40:04.796Z", url: "https://prescription-store-s3.dev.eka.care/P-MW-09EAB4D2-9CB5-5524-914B-EEAA91F63940.pdf", pxid: "P-MW-09EAB4D2-9CB5-5524-914B-EEAA91F63940", name: "Visit on May 25th 2023, 3:10 pm", clinicid: "60b8a8fe31b23b642ff99de9", status: "CM")], followup: "2023-08-27T18:30:00.000Z", last_visit: "2023-08-14T11:29:57.739Z")
    
    for _ in 0..<number {
      dummyData.id = UUID().uuidString
      dummyData.profile?.personal?.phone?.n = random(digits: 10)
      dummyData.profile?.personal?.name = randomString(length: 7)
      patientData.append(dummyData)
    }
    completion(true)
  }
  
  @IBAction func addData(_ sender: UIButton) {
    let startTimeSql = Date()
    //MARK: Sqlite
//    db.saveToSql(patientData: patientData) { [self] error, value, success in
//      if success {
//        let duration = Date().seconds(from: startTimeSql)
//        let startMiliSec = startTimeSql.millisecondsSince1970
//        let currentMiliSec = Date().millisecondsSince1970
//        let mSec = currentMiliSec - startMiliSec
//        consoleLogView.text = "time_taken_to_add_sqlite: \(duration) sec\nValue_returned: \(value.count)\nmilli_seconds: \(mSec) ms\nrecords failed: \(error.count)"
//      }
//    }
    
  }
  
  @IBAction func fetchData(_ sender: UIButton) {
    //MARK: Sqlite
    let startTimeSql = Date()
//    db.read { [self] value in
//      patientData = value
//      let duration = Date().seconds(from: startTimeSql)
//      let startMiliSec = startTimeSql.millisecondsSince1970
//      let currentMiliSec = Date().millisecondsSince1970
//      let mSec = currentMiliSec - startMiliSec
//      consoleLogView.text = "time_taken_to_fetch_sqlite: \(duration) sec\nValue_returned: \(value.count)\nmilli_seconds: \(mSec) ms"
//    }
    
  }
  
  @IBAction func searchFromData(_ sender: UIButton) {
    guard let searchText = searchText.text else { return }
    //MARK: Sqlite
    let startTimeSqlite = Date()
//    db.searchPatient(searchText: searchText) { [self] value in
//      let duration = Date().seconds(from: startTimeSqlite)
//      let startMiliSec = startTimeSqlite.millisecondsSince1970
//      let currentMiliSec = Date().millisecondsSince1970
//      let mSec = currentMiliSec - startMiliSec
//      consoleLogView.text = "time_taken_to_search_sqlite: \(duration) sec\nValue_returned: \(value.count)\nmilli_seconds: \(mSec) ms"
//    }
    
  }
  
  @IBAction func addNewPatients(_ sender: UIButton) {
    patientData.removeAll()
    guard let text = Int(searchText.text ?? "10000") else { return }
    getPatientData(number: text) { _ in
      DispatchQueue.main.async { [self] in
        consoleLogView.text = "data added in array"
        let startTimeSql = Date()
        //MARK: Sqlite
//        db.saveToSql(patientData: patientData) { [self] error, value, success in
//          if success {
//            let duration = Date().seconds(from: startTimeSql)
//            let startMiliSec = startTimeSql.millisecondsSince1970
//            let currentMiliSec = Date().millisecondsSince1970
//            let mSec = currentMiliSec - startMiliSec
//            consoleLogView.text = "time_taken_to_add_sqlite: \(duration) sec\nValue_returned: \(value.count)\nmilli_seconds: \(mSec) ms\nrecords failed: \(error.count)"
//          }
//        }
      }
    }
    
  }
  
  @IBAction func deleteFromDB(_ sender: UIButton) {
//    db.deletefromDB { [self] value in
//      consoleLogView.text = value
//    }
  }
  
//  @IBAction func showResetMenu(_ gestureRecognizer: UILongPressGestureRecognizer) {
//     if gestureRecognizer.state == .began {
//        self.becomeFirstResponder()
//        self.view = gestureRecognizer.view
//
//
//        // Configure the menu item to display
//        let menuItemTitle = NSLocalizedString("Reset", comment: "Reset menu item title")
//        let action = #selector(ViewController.resetPiece)
//        let resetMenuItem = UIMenuItem(title: menuItemTitle, action: action)
//
//
//        // Configure the shared menu controller
//        let menuController = UIMenuController.shared
//        menuController.menuItems = [resetMenuItem]
//
//
//        // Set the location of the menu in the view.
//        let location = gestureRecognizer.location(in: gestureRecognizer.view)
//        let menuLocation = CGRect(x: location.x, y: location.y, width: 0, height: 0)
//        menuController.setTargetRect(menuLocation, in: gestureRecognizer.view!)
//
//
//        // Show the menu.
//        menuController.setMenuVisible(true, animated: true)
//     }
//  }
//
//  @objc func resetPiece() {
//    print("reset")
//  }
  
}

extension ViewController {
  
  func random(digits:Int) -> String {
    var number = String()
    for _ in 1...digits {
      number += "\(Int.random(in: 1...9))"
    }
    return number
  }
  
  func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    return String((0..<length).map{ _ in letters.randomElement()! })
  }
  
}
