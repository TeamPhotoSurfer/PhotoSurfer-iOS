//
//  NetworkConstant.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/20.
//

import Foundation

struct NetworkConstant {
    
    static let noTokenHeader = ["Content-Type": "application/json"]
    static var hasTokenHeader = ["Content-Type": "application/json",
                                 "Authorization": NetworkConstant.accessToken]
    static var hasMultipartHeader = ["Content-Type": "multipart/form-data; boundary=<calculated when request is sent>",
                                 "Authorization": NetworkConstant.accessToken]
    
    static var accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjo1NH0sImlhdCI6MTY1ODUwMDM4NywiZXhwIjozNzY1ODUwMDM4N30.1ol1wposSyh2atwpFbDXm-ubnCbvJ4JFIFHgXfV38uc"
    static var fcmToken = ""
}
