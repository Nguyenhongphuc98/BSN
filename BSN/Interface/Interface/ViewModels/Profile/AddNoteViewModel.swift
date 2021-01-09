//
//  AddNoteViewModel.swift
//  Interface
//
//  Created by Phucnh on 1/9/21.
//

import SwiftUI
import Business

class AddNoteViewModel: NetworkViewModel {
    
    private var noteManager: NoteManager
        
    @Published var photoUrl: String
    @Published var isUploading: Bool // upload image to s3
    @Published var uploadMessage: String
    
    override init() {
        noteManager = NoteManager()
        photoUrl = ""
        uploadMessage = ""
        isUploading = false
        
        super.init()
        observerChangeNote()
    }
    
    func processNote(note: Note) {
        isLoading = true
        // Undefine mean this is new note, we should save it
        if note.isUndefine() {
            noteManager.saveNote(note: ENote(
                userBookID: note.UBID,
                content: note.content,
                page: note.page,
                photo: photoUrl
            ))
        } else {
            noteManager.updateNote(note: ENote(
                id: note.id,
                content: note.content,
                page: note.page,
                photo: photoUrl
            ))
        }
    }
    
    /// Get save note info
    /// Using for Add note View, update a note
    private func observerChangeNote() {
        noteManager
            .changePublisher
            .sink {[weak self] (note) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if note.id == "undefine" {
                        self.resourceInfo = .savefailure
                    } else {
                        
                        self.resourceInfo = .success
                    }
                    self.showAlert = true
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - AWS Utils
extension AddNoteViewModel {
    func upload(image: UIImage) {
        print("start uploading image ...")
        isUploading = true
        objectWillChange.send()
        AWSManager.shared.uploadImage(image: image, progress: {[weak self] ( uploadProgress) in
                        
            print("uploading: \(uploadProgress)")
            
        }) {[weak self] (uploadedFileUrl, error) in
            
            guard let strongSelf = self else { return }
            if let finalPath = uploadedFileUrl as? String {
                strongSelf.photoUrl = finalPath
            } else {
                
                strongSelf.uploadMessage = "Tải lên thất bại, chọn và thử lại"
                print("\(String(describing: error?.localizedDescription))")
            }
            strongSelf.isUploading = false
            strongSelf.objectWillChange.send()
        }
    }
}
