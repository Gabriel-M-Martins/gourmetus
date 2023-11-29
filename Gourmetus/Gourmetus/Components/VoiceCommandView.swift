//
//  VoiceCommandView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 28/11/23.
//

import SwiftUI

struct VoiceCommandView: View {
    
    //    @Binding var speechStatus: Speech.Status
    @Binding var speechStatus: Speech.Status
    @Binding var text: String
    @Binding var showHelp: Bool
    //    @State var showCommandsList: Bool = false
    
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: 223, height: 42)
                .foregroundColor(Color.color_text_container_muted)
                .roundedCorner(20, corners: [.topLeft, .bottomLeft])
                .modifier(cardShadow())
            HStack(spacing: 0){
                ZStack{
                    Circle()
                        .stroke(lineWidth: 2)
                        .foregroundColor(Color.color_general_fixed_light)
                        .frame(width: 42, height: 42)
                    
                    if speechStatus != .commandAccepted {
                        Image(systemName: "waveform")
                            .frame(width: 25, height: 31)
                            .foregroundColor(Color.color_general_fixed_light)
                    } else {
                        Image(systemName: "checkmark")
                            .frame(width: 25, height: 31)
                            .foregroundColor(Color.color_general_fixed_light)
                    }
                    
                }
                
                Text("\(Image(systemName: "text.bubble.fill")) | \(text)")
                    .modifier(Paragraph())
                    .foregroundColor(Color.color_general_fixed_light)
                    .padding(.leading, 2)
                
                
                Spacer()
                
                Button {
                    showHelp.toggle()
                } label: {
                    Circle()
                        .foregroundColor(Color.color_button_container_primary)
                        .frame(width: 20, height: 20)
                        .overlay {
                            Image(systemName: "questionmark.circle")
                                .modifier(Paragraph())
                                .foregroundColor(Color.color_general_fixed_light)
                        }
                        .padding(.trailing, 5)
                }
            }
        }
        .frame(width: 223, height: 42)
        
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

#Preview {
    //    VoiceCommandView(speechStatus: Binding.constant(.speeking) , text: Binding.constant("Help"))
    VoiceCommandView(speechStatus: Binding.constant(.commandAccepted), text: Binding.constant("Help"), showHelp: Binding.constant(true))
}
