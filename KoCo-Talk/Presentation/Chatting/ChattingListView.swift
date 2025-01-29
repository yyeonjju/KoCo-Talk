//
//  ChattingListView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/28/25.
//

import SwiftUI

struct ChattingListView: View {
    var body: some View {
        VStack{
            Text("ChattingListView")
            
            NavigationLink{
                ChattingRoomView()
            } label  : {
                Text("채팅룸")
            }
        }

    }
}
