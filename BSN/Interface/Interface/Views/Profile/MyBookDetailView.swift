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
    
    @Environment(\.presentationMode) var presentationMode
    
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
                            destination: UpdateUBView(),
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
            Image(systemName: "chevron.backward")
                .foregroundColor(.gray)
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
                //Image(model.cover!, bundle: interfaceBundle)
                BSNImage(urlString: model.cover, tempImage: "book_cover")
                    .frame(width: 80, height: 100)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    
                    Text(model.title)
                        .roboto(size: 17)
                    
                    Text(model.author)
                        .robotoLight(size: 14)
                    
                    BookStatusText(status: model.status)
                    
                    BookStateText(state: model.state)
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
