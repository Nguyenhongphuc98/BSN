//
//  MessageItem.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI

// Instance fo an message: sender - content
struct MessageItem: View {
    
    @StateObject var message: Message
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if message.isSendByMe() {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 30)
                    .layoutPriority(-1)
                Spacer()
               
            } else {
                CircleImage(image: message.sender.avatar, diameter: 35)
            }

            if message.type == .text {
                TextMessage(isMe: message.isSendByMe(), text: message.content)
            }
            else if message.type == .sticker {
                Image(message.sticker!, bundle: interfaceBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
            }

            if !message.isSendByMe() {
                Spacer()
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 30)
                    .layoutPriority(-1)
            }
        }
        .padding(.init(top: 8, leading: 12, bottom: 8, trailing: 12))
    }
}

struct MessageItem_Previews: PreviewProvider {
    static var previews: some View {
        MessageItem(message: Message())
    }
}

// MARK: - Main content message
private struct TextMessage: View {
    let isMe: Bool
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            if !isMe { Arrow(isMe: isMe) }
            
            Text(text)
                .robotoLight(size: 13)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(background)
            
            if isMe { Arrow(isMe: isMe) }
        }
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: 4)
            .foregroundColor(isMe ? Color._sendMessage : Color._receiveMessage)
    }
}

// MARK: - Decorate message
private struct Arrow: View {
    let isMe: Bool
    
    var body: some View {
        Path { path in
            path.move(to: .init(x: isMe ? 0 : 6, y: 14))
            path.addLine(to: .init(x: isMe ? 0 : 6, y: 26))
            path.addLine(to: .init(x: isMe ? 6 : 0, y: 20))
            path.addLine(to: .init(x: isMe ? 0 : 6, y: 14))
        }
        .fill(isMe ? Color._sendMessage : Color._receiveMessage)
        .frame(width: 6, height: 30)
    }
}

// MARK: - View Extension (fileprivate)
extension View {
    fileprivate func addPadding(isMe: Bool) -> some View {
        if isMe {
            return self.padding(.trailing, 0)
        } else {
            return self.padding(.leading, 0)
        }
    }
}
