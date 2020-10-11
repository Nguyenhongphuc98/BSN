//
//  MyBookDetail.swift
//  Interface
//
//  Created by Phucnh on 10/10/20.
//

import SwiftUI

struct MyBookDetailView: View {
    
    @StateObject var viewModel: MyBookDetailViewModel = MyBookDetailViewModel()
    
    @State private var showAddNoteView: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ZStack(alignment: .topTrailing) {
                    MyBookDetailViewHeader(model: viewModel.model)
                        .padding(.top, 10)
                    
                    Button(action: {
                        print("did click new note")
                    }, label: {
                        Image(systemName: "pencil")
                            .font(.system(size: 25))
                            .padding(10)
                            .background(Color.init(hex: 0xEFEFEF))
                            .cornerRadius(25)
                            .shadow(radius: 3)
                    })
                }
                
                notes
                
                bookStatus
            }
            .padding()
        }
    }
    
    private var notes: some View {
        DisclosureGroup(
            content: {
                VStack {
                    ForEach(viewModel.notes) { note in
                        NoteCard(model: note)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 5)
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            print("did click new note")
                            showAddNoteView.toggle()
                        }, label: {
                            Image(systemName: "plus")
                                .font(.system(size: 35))
                                .padding(10)
                                .background(Color.init(hex: 0xEFEFEF))
                                .cornerRadius(25)
                                .shadow(radius: 3)
                        })
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .sheet(isPresented: $showAddNoteView, content: {
                        AddNoteView().environmentObject(viewModel)
                    })
                }
            },
            label: {
                Text("Bài học rút ra")
                    .robotoBold(size: 19)
            }
        )
        .padding(.trailing, 5)
    }
    
    private var bookStatus: some View {
        DisclosureGroup(
            content: {
                Text(viewModel.model.statusDes)
                    .robotoItalic(size: 15)
                    .foregroundColor(.init(hex: 0x404040))
                    .multilineTextAlignment(.center)
                    .padding()
            },
            label: {
                Text("Tình trạng sách")
                    .robotoBold(size: 19)
            }
        )
        .padding(.trailing, 5)
    }
}

struct MyBookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MyBookDetailView()
    }
}

// MARK: - Sub compoent
struct MyBookDetailViewHeader: View {
    
    var model: MyBookDetail
    
    @State var expandDes: Bool = false
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image(model.photo, bundle: interfaceBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 100)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    
                    Text(model.name)
                        .roboto(size: 15)
                    
                    Text(model.author)
                        .robotoLight(size: 14)
                    
                    BookStatusText(status: model.status)
                    
                    BookStateText(state: model.state)
                }
                
                Spacer()
            }
            
            // Description
            Group {
                Text(model.description)
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
    
    var actionText: String {
        expandDes ? " (Thu gọn)" : " (Mở rộng)"
    }
}