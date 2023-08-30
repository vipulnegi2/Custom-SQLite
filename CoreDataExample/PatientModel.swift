//
//  PatientModel.swift
//  CoreDataExample
//
//  Created by Vipul Negi on 16/08/23.
//

import Foundation

// MARK: - PatientDirResponse
struct PatientDirResponse: Codable {
  var status: String?
  var data: [PatientModel]?
  
  init(status: String?, data: [PatientModel]?) {
    self.status = status
    self.data = data
  }
}

// MARK: - Datum
struct PatientModel: Codable {
  var id: String?
  var profile: ProfileModel?
  var formData: [FormData]?
  var archived: Bool?
  var link: [String]?
  var created_at, updated_at: String?
  var visits: [Visit]?
  var followup, last_visit: String?
  
  
  init(id: String?, profile: ProfileModel?, formData: [FormData]?, archived: Bool?, link: [String]?, created_at: String?, updated_at: String?, visits: [Visit]?, followup: String?, last_visit: String?) {
    self.id = id
    self.profile = profile
    self.formData = formData
    self.archived = archived
    self.link = link
    self.created_at = created_at
    self.updated_at = updated_at
    self.visits = visits
    self.followup = followup
    self.last_visit = last_visit
  }
  
}

// MARK: - FormData
struct FormData: Codable {
  var label, type, key: String?
//  var value: String?

//  init(label: String?, type: String?, key: String?, value: Any?) {
    init(label: String?, type: String?, key: String?) {
    self.label = label
    self.type = type
    self.key = key
//    self.value = "\(value ?? "")"
  }

}

// MARK: - ProfileModel
struct ProfileModel: Codable {
  var personal: Personal?
  
  init(personal: Personal?) {
    self.personal = personal
  }
}

// MARK: - Personal
struct Personal: Codable {
  var name: String?
  var age: Age?
  var phone: Phone?
  var gender, bloodgroup: String?
  var onApp: Bool?
  
  init(name: String?, age: Age?, phone: Phone?, gender: String?, bloodgroup: String?, onApp: Bool?) {
    self.name = name
    self.age = age
    self.phone = phone
    self.gender = gender
    self.bloodgroup = bloodgroup
    self.onApp = onApp
  }
}

// MARK: - Age
struct Age: Codable {
  var dob: String?
  
  init(dob: String?) {
    self.dob = dob
  }
}

// MARK: - Phone
struct Phone: Codable {
  var c, n: String?
  
  init(c: String?, n: String?) {
    self.c = c
    self.n = n
  }
}

// MARK: - Visit
struct Visit: Codable {
  var vid, visit_date: String?
  var url: String?
  var pxid, name, clinicid, status: String?
  
  init(vid: String?, visit_date: String?, url: String?, pxid: String?, name: String?, clinicid: String?, status: String?) {
    self.vid = vid
    self.visit_date = visit_date
    self.url = url
    self.pxid = pxid
    self.name = name
    self.clinicid = clinicid
    self.status = status
  }
}

