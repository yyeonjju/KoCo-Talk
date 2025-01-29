//
//  ChattingListView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/28/25.
//

import SwiftUI

struct ChattingListView: View {
    var body: some View {
        ScrollView{
            LazyVStack {
                ForEach(0..<20) { item in
                    NavigationLink{
                        Text("\(item)")
                    } label  : {
                        ChattingListRowView()
                    }
                    .padding(.bottom, 4)
                }
            }
            .padding()

        }

    }
}
