//
//  MyBookDetail.swift
//  Interface
//
//  Created by Phucnh on 10/10/20.
//

import SwiftUI

struct MyBookDetailView: View {
    
    @StateObject var viewModel: MyBookDetailViewModel = .init()
    
    @State private var showAddNoteView: Bool = false
    @State private var expansedNotes: Bool = true
    @State private var expansedStatusDes: Bool = true
    
    @Environment(\.presentationMode) var presentationMode
    
    // Pass note to edit view
    @ObservedObject private var passthroughtNote: Note = Note()
    
    var ubid: String
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ZStack(alignment: .topTrailing) {
                    MyBookDetailViewHeader(model: viewModel.model)
                        .padding(.top, 10)
                    
                    Button(action: {
                        print("did click edit book")
                    }, label: {
                        NavigationLink(
                            destination: UpdateUBView().environmentObject(viewModel.model),
                            label: {
                                Image(systemName: "pencil")
                                    .font(.system(size: 25))
                                    .padding(10)
                                    .background(Color.init(hex: 0xEFEFEF))
                                    .cornerRadius(25)
                                    .shadow(radius: 3)
                            })
                    })
                }
                
                notes
                
                bookStatus
            }
            .padding()
        }
        .embededLoading(isLoading: $viewModel.isLoading)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des())
            )
        }
        .onAppear(perform: viewAppeared)
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            BackWardButton()
        }
    }
    
    private var notes: some View {
        DisclosureGroup(isExpanded: $expansedNotes) {
            VStack {
                ForEach(viewModel.notes) { note in
                    ZStack(alignment: .topTrailing) {

                        NoteCard(model: note)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 5)
                        
                        Menu {
                            Button {
                                viewModel.deleteNote(note: note)
                            } label: {
                                Text("Xoá bài học")
                            }
              
                            Button {
                                passthroughtNote.clone(note: note)
                                showAddNoteView.toggle()
                            } label: {
                                Text("Sửa bài học")
                            }
                        }
                        label: {
                            // More button
                            Image(systemName: "ellipsis").padding()
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        // When create new, we just need ubid
                        passthroughtNote.UBID = viewModel.model.id!
                        showAddNoteView.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .font(.system(size: 35))
                            .padding(10)
                            .background(Color.init(hex: 0xEFEFEF))
                            .cornerRadius(25)
                            .shadow(radius: 3)
                            .padding(3)
                    })
                }
                .padding(.horizontal)
                .padding(.bottom)
                .sheet(isPresented: $showAddNoteView, content: {
                    AddNoteView(didRating: {
                        viewModel.reloadNotes()
                    })
                        .environmentObject(viewModel)
                        .environmentObject(passthroughtNote)
                })
            }
        } label: {
            Text("Bài học rút ra").robotoBold(size: 19)
        }
        .padding(.trailing, 5)
    }
    
    private var bookStatus: some View {
        DisclosureGroup(isExpanded: $expansedStatusDes) {
            Text(viewModel.model.statusDes)
                .robotoItalic(size: 15)
                .foregroundColor(.init(hex: 0x404040))
                .multilineTextAlignment(.center)
                .padding()
        }
        label: {
            Text("Tình trạng sách").robotoBold(size: 19)
        }
        .padding(.trailing, 5)
    }
    
    private func viewAppeared() {
        viewModel.prepareData(ubid: ubid)
    }
}

//struct MyBookDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyBookDetailView()
//    }
//}

// MARK: - Sub compoent
struct MyBookDetailViewHeader: View {
    
    @StateObject var model: BUserBook
    
    @State var expandDes: Bool = false
    
    var showDes: Bool = true
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                BSNImage(urlString: model.cover, tempImage: "book_cover")
                    .frame(width: 80, height: 110)
                    .background(Color.white)
                    .id(model.cover!)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    
                    Text(model.title)
                        .roboto(size: 17)
                    
                    Text(model.author)
                        .robotoLight(size: 14)
                    
                    BookStatusText(status: model.status!)
                    
                    BookStateText(state: model.state!)
                }
                
                Spacer()
            }
            
            if showDes {
                des
            }
        }
    }
    
    var actionText: String {
        expandDes ? " (Thu gọn)" : " (Mở rộng)"
    }
    
    var des: some View {
        // Description
        Group {
            Text(model.description!)
                .robotoItalic(size: 15)
                .foregroundColor(.init(hex: 0x404040))
            +
            Text(actionText)
                .robotoMedium(size: 14)
                .foregroundColor(._primary)
        }
        .frame(maxHeight: expandDes ? 200 : 100)
        .onTapGesture(perform: {
            expandDes.toggle()
        })
    }
}
