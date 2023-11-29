//
//  SearchBarView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 16/11/23.
//

import SwiftUI

struct SearchBarView: View {
    var body: some View {
        ZStack{
            Rectangle()
                .cornerRadius(10)
                .frame(height: UIScreen.main.bounds.height*0.045)
                .foregroundColor(Color.color_card_container_stroke)
                
            HStack{
                HStack{
                    Text((Image(systemName: "magnifyingglass")))
                    Text(LocalizedStringKey("Search"))
                }
                    .padding(.horizontal,8)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .padding(.horizontal, default_spacing)
    }
}

#Preview {
    HomeView()
        .environmentObject(Constants.mockedCookbook)
}
