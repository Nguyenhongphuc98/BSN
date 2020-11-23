//
//  ResourceInfo.swift
//  Interface
//
//  Created by Phucnh on 10/29/20.
//

import Foundation

public enum ResourceInfo: String {
    case notfound
    case exists
    case success
    case getfailure
    case savefailure
    case invalid_empty
    case invalid_category
    
    public func des() -> String {
        switch self {
        case .notfound:
            return "Không tìm thấy dữ liệu"
        case .exists:
            return "Dữ liệu đã tồn tại"
        case .success:
            return "Xử lý thành công"
        case .getfailure:
            return "Lấy dữ liệu thất bại"
        case .savefailure:
            return "Lưu dữ liệu thất bại"
        case .invalid_empty:
            return "Nội dung không được để trống"
        case .invalid_category:
            return "Vui lòng chọn danh mục"
        }
    }
}
