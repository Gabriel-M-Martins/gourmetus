//
//  DeletePopUp.swift
//  Gourmetus
//
//  Created by Lucas Cunha on 25/10/23.
//

import SwiftUI

enum TapType {
    case none, cancel, delete
}

struct DeletePopUp<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var showingAlert = false
    @State var tapType: TapType = .none
    @State var msgErreor : String
    @ViewBuilder let visualContent: Content
    @Binding var answer : Bool
    var deletable : Bool = false
    
    var body: some View {
        VStack{
            Button(action: {
                showingAlert = true
            }, label: {
                visualContent
            }).alert(msgErreor, isPresented: $showingAlert) {
                Button("Confirm",role: deletable ? .destructive : .none) {
                    answer = true
                    self.dismiss()
                }
                Button("Cancel",role: .cancel){
                    answer = false
                    self.dismiss()
                }
            }
        }
        .onChange(of: tapType) { oldValue, newValue in
            
        }
    }
}

#Preview {
    DeletePopUp(msgErreor: "Are you sure you want delete this recipe?", visualContent: {Text("Delete Recipe")
            .frame(width: 350, height: 64)
            .background(.red)
            .foregroundColor(.white)
            .cornerRadius(16)
            .padding(.bottom,100)
    },answer: .constant(false))
}
