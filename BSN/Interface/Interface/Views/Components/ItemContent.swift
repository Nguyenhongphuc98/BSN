//
//  TabItemContent.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import SwiftUI

public struct ItemContent: View {
    
    // Handle current selected tab
    @Binding var selectedIndex: Int
    
    let type: TabItemType
    
    public init(selectedIndex: Binding<Int>, type: TabItemType) {
        self._selectedIndex = selectedIndex
        self.type = type
    }
    
    public var body: some View {
        VStack {
            if selectedIndex == type.rawValue {
                type.selectedImage
            } else {
                type.image
            }
        }
        
    }
}

// MARK: - Export image base on style
public extension ItemContent {
    
    enum TabItemType: Int {
        
        case news
        case search
        case chat
        case notify
        case profile
        
        var image: Image {
            switch self {
            case .news:
                return Image(systemName: "note")
            case .search:
                return Image(systemName: "books.vertical")
            case .chat:
                return Image(systemName: "bubble.left")
            case .notify:
                return Image(systemName: "bell.badge")
            case .profile:
                return Image(systemName: "person")
            }
        }
        
        var selectedImage: Image {
            switch self {
            case .news:
                return Image(systemName: "note.text")
            case .search:
                return Image(systemName: "books.vertical.fill")
            case .chat:
                return Image(systemName: "bubble.left.fill")
            case .notify:
                return Image(systemName: "bell.badge.fill")
            case .profile:
                return Image(systemName: "person.fill")
            }
        }
    }
}
