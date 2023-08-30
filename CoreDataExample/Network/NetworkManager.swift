//
//  NetworkManager.swift
//  CoreDataExample
//
//  Created by Vipul Negi on 17/08/23.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func getApiCall(url: String, completion: @escaping (PatientDirResponse?) -> ()) {
        
        guard let url = URL(string: url) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
      request.allHTTPHeaderFields = [
        "authority": "parchi.eka.care",
        "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
        "accept-language": "en-GB,en-US;q=0.9,en;q=0.8",
        "cache-control": "max-age=0",
        "cookie": "_hjSessionUser_2591420=eyJpZCI6ImU3MTQxMDlkLTYwZWQtNWM1Yy1iNzBjLTkxNWIyZDc4ZTM4ZCIsImNyZWF0ZWQiOjE2ODgzODM0Mjg4MTksImV4aXN0aW5nIjp0cnVlfQ==; _gcl_au=1.1.465907658.1688538012; _fbp=fb.1.1688538011783.963385515; _ga=GA1.1.127565568.1688538012; _hjSessionUser_2344911=eyJpZCI6Ijc0YTU2MGMwLTU1MDMtNWRjNi1iN2U4LTdhNWJmMGUwY2U5MSIsImNyZWF0ZWQiOjE2ODg1MzgwMTEzOTIsImV4aXN0aW5nIjp0cnVlfQ==; mp_301023b0a63d2fa20a516329bac66fc5_mixpanel=%7B%22distinct_id%22%3A%20%22161467756044203%22%2C%22%24device_id%22%3A%20%22189d9af76ef9a9-086e01979f3964-1a525634-1fa400-189d9af76ef9a9%22%2C%22%24initial_referrer%22%3A%20%22https%3A%2F%2Fdocapp.dev.eka.care%2Fapp%22%2C%22%24initial_referring_domain%22%3A%20%22docapp.dev.eka.care%22%2C%22%24user_id%22%3A%20%22161467756044203%22%2C%22__timers%22%3A%20%7B%7D%7D; mp_3fde766bfa831171e76eb92825c7064c_mixpanel=%7B%22distinct_id%22%3A%20%22161467756044203%22%2C%22%24device_id%22%3A%20%2218924b5560c1cf4-0169bf77db98f6-1b525634-1aeaa0-18924b5560d241a%22%2C%22%24initial_referrer%22%3A%20%22https%3A%2F%2Fdr.eka.care%2F%22%2C%22%24initial_referring_domain%22%3A%20%22dr.eka.care%22%2C%22doctor%22%3A%20%22dr-raghunandan-gupta-general-practitioner-bengaluru%22%2C%22clientId%22%3A%20%22dr-eka-care%22%2C%22%24user_id%22%3A%20%22161467756044203%22%2C%22uuid%22%3A%20%2240d6c891-4a30-400e-a861-7fdb9b06606a%22%2C%22oid%22%3A%20%22161467756044203%22%2C%22fn%22%3A%20%22Raghunandan%20Gupta%22%2C%22gen%22%3A%20%22M%22%2C%22is-p%22%3A%20true%2C%22is-d%22%3A%20true%2C%22dob%22%3A%20%221992-08-05%22%2C%22mob%22%3A%20%22%2B919******826%22%2C%22type%22%3A%201%2C%22doc-id%22%3A%20%22161467756044203%22%2C%22iat%22%3A%201692183026%2C%22exp%22%3A%201692193826%2C%22loading%22%3A%20false%2C%22is-d-s%22%3A%20true%7D; _ga_JKBK7MFNEV=GS1.1.1692183055.7.0.1692183056.0.0.0; _clck=8144ri|2|fee|0|1279; sess=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiYzlhM2JkNTctYWIzYS00YWFlLTk1MmItYzRiZjhkMDE3ZTEzIiwib2lkIjoiMTY4NTE4MTUzMjk2MjIyIiwiZm4iOiJWaXB1bCBOZWdpIiwiZ2VuIjoiTSIsImlzLXAiOnRydWUsImlzLWQiOnRydWUsImRvYiI6IjE5OTYtMDktMDgiLCJtb2IiOiIrOTE5KioqKioqNjc4IiwidHlwZSI6MSwiZG9jLWlkIjoiMTY4NTE4MTUzMjk2MjIyIiwiaWF0IjoxNjkyNzk2Nzk1LCJleHAiOjE2OTI4MDc1OTV9.Up3FMtTT4muojHfET7gJEb3mJq-1Q3b03ctxJxQNias; refresh=DF9l0XPqfGo7xNUH; _hjSession_2591420=eyJpZCI6ImQ3YTkxOWMwLWViMGQtNDIyYi04YTIxLTE2NDA4MmZlMjIzZCIsImNyZWF0ZWQiOjE2OTI3OTk3NDg1MjQsImluU2FtcGxlIjpmYWxzZX0=; _hjAbsoluteSessionInProgress=1; crisp-client%2Fsession%2F4c30fe75-b57c-4156-a5e4-58295a7880cf=session_c2b98322-489a-4baa-ab63-84b01f1a6ba6; mp_8801fa535d97939e4b9c500e5f0ddec9_mixpanel=%7B%22distinct_id%22%3A%20%22168518153296222%22%2C%22%24device_id%22%3A%20%2218a21e82def217-05b1b6586ea07a-1a525634-1aeaa0-18a21e82def217%22%2C%22%24initial_referrer%22%3A%20%22https%3A%2F%2Fdr.eka.care%2Fapp%2Flogout%22%2C%22%24initial_referring_domain%22%3A%20%22dr.eka.care%22%2C%22%24user_id%22%3A%20%22168518153296222%22%2C%22__timers%22%3A%20%7B%22PX_TIME%22%3A%201692800213409%7D%7D; _clsk=1nk28k9|1692800214547|4|1|s.clarity.ms/collect; mp_c4ca45144b52a8ba9c8cce38b36c07d4_mixpanel=%7B%22distinct_id%22%3A%20%22168518153296222%22%2C%22%24device_id%22%3A%20%2218a21e7fd522bd-01fd806863d9d9-1a525634-1aeaa0-18a21e7fd522bd%22%2C%22%24initial_referrer%22%3A%20%22%24direct%22%2C%22%24initial_referring_domain%22%3A%20%22%24direct%22%2C%22%24user_id%22%3A%20%22168518153296222%22%7D",
        "if-none-match": "W3a5905-4BVCyEtFgHy7YDCInzKNZuT3kgg",
        "sec-ch-ua": "Not/A)Brand\";v=\"99\", \"Google Chrome\";v=\"115\", \"Chromium\";v=\"115\"",
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": "macOS",
        "sec-fetch-dest": "document",
        "sec-fetch-mode": "navigate",
        "sec-fetch-site": "none",
        "sec-fetch-user": "?1",
        "upgrade-insecure-requests": "1",
        "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36",
      ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let errorDesc = error {
                print(errorDesc.localizedDescription)
            } else if let response = response {
                do {
                  let json = try JSONDecoder().decode(PatientDirResponse.self, from: data!) //JSONSerialization.jsonObject(with: data!) as? [String: AnyObject]
                    completion(json)
                } catch {
                    print("error")
                }
                
            }
            
        }.resume()
        
    }
    
}
