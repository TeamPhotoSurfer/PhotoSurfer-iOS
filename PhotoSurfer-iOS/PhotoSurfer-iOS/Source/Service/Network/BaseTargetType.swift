//
//  BaseTargetType.swift
//  PhotoSurfer-iOS
//
//  Created by κΉνμ on 2022/07/17.
//

import Moya

protocol BaseTargetType: TargetType { }

extension BaseTargetType {

    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var sampleData: Data {
        return Data()
    }
}
