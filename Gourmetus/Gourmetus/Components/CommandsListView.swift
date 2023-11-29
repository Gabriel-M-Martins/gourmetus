//
//  CommandsListView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 28/11/23.
//

import SwiftUI

struct CommandsListView: View {
    
    @Binding var showHelp: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.color_background_container_primary)
                .cornerRadius(smooth_radius)
                .modifier(cardShadow())
            
            ScrollView {
                VStack(alignment: .leading, spacing: half_spacing){
                    HStack{
                        Spacer()
                        Button {
                            showHelp = false
                        } label: {
                            Text("CLOSE")
                                .foregroundColor(.orange)
                                .underline()
                                .modifier(Link())
                        }
                    }
                    .padding(.vertical, 8)
                    
                    Text("Call chef")
                        .padding(.top, 8)
                        .modifier(Header())
                        .foregroundColor(Color.color_text_container_highlight)
                    if deviceLanguageBR() {
                        Text(Constants.commandsChefPT.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    } else {
                        Text(Constants.commandsChefEN.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    }
                    
                    Text("Next step")
                        .padding(.top, 8)
                        .modifier(Header())
                        .foregroundColor(Color.color_text_container_highlight)
                    if deviceLanguageBR() {
                        Text(Constants.commandsNextPT.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    } else {
                        Text(Constants.commandsNextEN.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    }
                    
                    Text("Previous step")
                        .padding(.top, 8)
                        .modifier(Header())
                        .foregroundColor(Color.color_text_container_highlight)
                    if deviceLanguageBR() {
                        Text(Constants.commandsPreviousPT.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    } else {
                        Text(Constants.commandsPreviousEN.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    }
                    
                    Text("Close recipe player")
                        .padding(.top, 8)
                        .modifier(Header())
                        .foregroundColor(Color.color_text_container_highlight)
                    if deviceLanguageBR() {
                        Text(Constants.commandsQuitPT.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    } else {
                        Text(Constants.commandsQuitEN.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    }
                    
                    Text("Go to first step")
                        .padding(.top, 8)
                        .modifier(Header())
                        .foregroundColor(Color.color_text_container_highlight)
                    if deviceLanguageBR() {
                        Text(Constants.commandsFirstStepPT.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    } else {
                        Text(Constants.commandsFirstStepEN.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    }
                    
                    Text("Go to last step")
                        .padding(.top, 8)
                        .modifier(Header())
                        .foregroundColor(Color.color_text_container_highlight)
                    if deviceLanguageBR() {
                        Text(Constants.commandsLastStepPT.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    } else {
                        Text(Constants.commandsLastStepEN.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    }
                    
                    Text("Finish recipe")
                        .padding(.top, 8)
                        .modifier(Header())
                        .foregroundColor(Color.color_text_container_highlight)
                    if deviceLanguageBR() {
                        Text(Constants.commandsFinishPT.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    } else {
                        Text(Constants.commandsFinishEN.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    }
                    
                    Text("Change presentation mode")
                        .padding(.top, 8)
                        .modifier(Header())
                        .foregroundColor(Color.color_text_container_highlight)
                    if deviceLanguageBR() {
                        Text(Constants.commandsModePT.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    } else {
                        Text(Constants.commandsModeEN.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    }
                    
                    Text("Start/Stop timer")
                        .padding(.top, 8)
                        .modifier(Header())
                        .foregroundColor(Color.color_text_container_highlight)
                    if deviceLanguageBR() {
                        Text(Constants.commandsTimerPT.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    } else {
                        Text(Constants.commandsTimerEN.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    }
                    
                    Text("Reset timer")
                        .padding(.top, 8)
                        .modifier(Header())
                        .foregroundColor(Color.color_text_container_highlight)
                    if deviceLanguageBR() {
                        Text(Constants.commandsTimerResetPT.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    } else {
                        Text(Constants.commandsTimerResetEN.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    }
                    
                    Text("Open/Close tip")
                        .padding(.top, 8)
                        .modifier(Header())
                        .foregroundColor(Color.color_text_container_highlight)
                    if deviceLanguageBR() {
                        Text(Constants.commandsTipPT.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    } else {
                        Text(Constants.commandsTipEN.joined(separator: ", ") + ".")
                            .multilineTextAlignment(.trailing)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_text_container_primary)
                    }
                    
                }
                .padding(default_spacing)
                
            }
            
        }
//        .padding(default_spacing)
        .frame(width: 358)
    }
}

#Preview {
    CommandsListView(showHelp: Binding.constant(true))
}
