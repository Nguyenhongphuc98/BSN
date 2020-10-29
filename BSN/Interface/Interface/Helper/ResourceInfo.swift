//
//  ResourceInfo.swift
//  Interface
//
//  Created by Phucnh on 10/29/20.
//

import Foundation

enum ResourceInfo: String {
    case notfound
    case exists
    case success
    
    func des() -> String {
        switch self {
        case .notfound:
            return "Không tìm thấy dữ liệu"
        case .exists:
            return "Dữ liệu đã tồn tại"
        case .success:
            return "Xử lý thành công"
        }
    }
}
