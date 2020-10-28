//
//  MyBookDetailViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/10/20.
//

import SwiftUI

class MyBookDetailViewModel: ObservableObject {
    
    var model: BUserBook
    
    @Published var notes: [Note]
    
    init() {
        model = BUserBook()
        notes = [Note(), Note()]
    }
    
    func addNewNote(content: String, complete: @escaping (Bool) -> Void) {
        notes.append(Note(content: content))
        complete(true)
    }
}
