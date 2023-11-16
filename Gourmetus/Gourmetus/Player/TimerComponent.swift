//
//  TimerComponent.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 01/11/23.
//

import SwiftUI

import Foundation

struct TimerView: View {
    @State private var isRunning = false
    @State private var initialTime: Int
    @State var remainingTime: Int
    @State var timer: Timer?
    
    @State var notificationId: UUID? = nil
    
    init(remainingTime: Int) {
           self._initialTime = State(initialValue: remainingTime)
           self._remainingTime = State(initialValue: remainingTime)
       }
    
    var body: some View {
        VStack (spacing: 4){
            HStack(spacing: 0){
                Image(systemName: "timer")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:10)
                Text(" Timer")
                    .modifier(Span())
            }
            .foregroundColor(Color.color_text_container_muted)
//        VStack {
//            Text("Timer")
//                .font(.headline)
            
            HStack{
                Text(timeFormatted)
                    .modifier(Title())
                
                Button(action: {
                    isRunning.toggle()
                    if isRunning {
                        startTimer()
                    } else {
                        stopTimer()
                    }
                }) {
                    Image(systemName: isRunning ? "pause.circle" : "play.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height:20)
                        .foregroundColor(Color.color_button_container_primary)
                    
                    
                   
                }
                
                
                    Button(action: {
                        stopTimer()
                        remainingTime = initialTime
                        startTimer()
                 
                            
                        
                    }) {
                        Image(systemName: "repeat.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height:20)
                            .foregroundColor(Color.color_button_container_primary)
          
                    }
                
                
                
            }
            
        }
        .padding(0)
        .background(Color.white)
        .cornerRadius(5)
    }
    
    var timeFormatted: String {
        let hours = remainingTime / 3600
        let minutes = (remainingTime % 3600) / 60
        let seconds = remainingTime % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func startTimer() {
       // print(remainingTime)
        notificationId = NotificationService.setTimer(time: remainingTime, title: "Notificacao", subtitle: "Funcionou")
        print(notificationId)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
                //print("rodando")
            } else {
                stopTimer()
                isRunning = false
                remainingTime = initialTime
            }
        }
    }
    
    func stopTimer() {
        if (notificationId != nil) {
            NotificationService.deleteTimer(id: notificationId!)
        }
        timer?.invalidate()
        timer = nil
    }
}



#Preview {
   
    TimerView(remainingTime: 300)
}
