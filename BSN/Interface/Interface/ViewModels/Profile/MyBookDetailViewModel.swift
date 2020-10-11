//
//  MyBookDetailViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/10/20.
//

import SwiftUI

class MyBookDetailViewModel: ObservableObject {
    
    var model: MyBookDetail
    
    @Published var notes: [Note]
    
    init() {
        model = MyBookDetail()
        notes = [Note(), Note()]
    }
    
    func addNewNote(content: String, complete: @escaping (Bool) -> Void) {
        notes.append(Note(content: content))
        complete(true)
    }
}
