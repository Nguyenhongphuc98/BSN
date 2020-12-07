//
//  PersonalizeView.swift
//  Interface
//
//  Created by Phucnh on 12/6/20.
//

import SwiftUI

// Using for onBoard screen
// Or in settings
public struct PersonalizeView: View {
    
    @StateObject var viewModel: PersonalizeViewModel = .shared
    
    @Environment(\.presentationMode) var presentationMode
    
    var onboard: Bool
    
    public init(onboard: Bool) {
        self.onboard = onboard
    }
    
    public var body: some View {
        VStack(spacing: 10) {
            
            // In onboard view, user have to select interest category
            // then we can suggest newfeeds
            if !onboard {
                closeLabel
            } else {
                Spacer(minLength: 35)
            }
            
            title
            
            categoriesContent()
                .embededLoadingFull(isLoading: $viewModel.isLoading)
               
            submitLabel()            
        }
        .background(Color(hex: 0xFCFFFD))
        .alert(isPresented: $viewModel.showAlert, content: alert)
        .onAppear(perform: viewAppeared)
    }
    
    private var closeLabel: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 35))
            }

            Spacer()
        }
    }
    
    private var title: some View {
        VStack(spacing: 5) {
            Text("Chọn thể loại yêu thích")
                .robotoBold(size: 25)
            
            Text("Giúp chúng tôi đưa ra gợi ý phù hợp")
                .robotoBold(size: 15)
                .foregroundColor(.init(hex: 0xBDBDBD))
        }
    }
    
    private func categoriesContent() -> some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(viewModel.chunks, id: \.self) { categories in
                    HStack {
                        ForEach(categories) { c in
                            CategoryCard(category: c, selected: c.interested)
                        }
                    }
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 10)
        }
    }
    
    private func submitLabel() -> some View {
        VStack {
            Text(description)
                .robotoBold(size: 15)
                .multilineTextAlignment(.center)
                .foregroundColor(.init(hex: 0x606060))
           
            Button(action: {
                viewModel.didClickupdate(isOnboard: onboard)
            }, label: {
                Text("     \(onboard ? "  Tiếp tục  " : "Lưu thay đổi")     ")
                    .robotoBold(size: 15)
            })
            .buttonStyle(BaseButtonStyle(size: .largeH))
            .disabled(viewModel.numSelected == 0)
            .padding()
            .padding(.bottom, 30)            
        }
    }
    
    private var description: String {
        viewModel.numSelected > 0 ? "Đã chọn (\(viewModel.numSelected))" : "Chọn ít nhất 1 thể loại để tiếp tục.\n Bạn có thể thiết lập lại trong phần cài đặt"
    }
    
    func alert() -> Alert {
        return Alert(
            title: Text("Kết quả"),
            message: Text(viewModel.resourceInfo.des()),
            primaryButton: .default(Text("Thử lại")) {
                viewModel.didClickupdate(isOnboard: onboard)
            },
            secondaryButton: .cancel(Text("Huỷ bỏ")) {
                dismiss()
            })
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func viewAppeared() {
        viewModel.didUpdateUserCategories = {
            if onboard {
                setupData()
                AppManager.shared.appState = .inapp
            } else {
                dismiss()
            }
        }
    }
}

struct CategoryCard: View {
    
    @StateObject var category: Category
    
    @State var selected: Bool = false
    
    var body: some View {
        Button {
            selected.toggle()
            category.interested = selected
            PersonalizeViewModel.shared.objectWillChange.send()
        } label: {
            HStack {
                Image(systemName: selected ? "checkmark.circle" : "plus")
                    .font(.system(size: 20))
                
                Text(category.name)
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(background)
            .foregroundColor(forceground)
            .clipShape(Capsule())
        }
    }
    
    var background: Color {
        selected ? Color(hex: 0x14D9C5) : Color(hex: 0xE8F1FD)
    }
    
    var forceground: Color {
        selected ? .white : .black
    }
}


