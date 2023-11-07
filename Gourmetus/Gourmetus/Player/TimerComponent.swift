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
    @State var remainingTime: Int
    @State var timer: Timer?
    
    @State var notificationId: UUID? = nil
    
    var body: some View {
        VStack {
            Text(" Timer")
                .font(.headline)
            
            HStack{
                Text(timeFormatted)
                    .font(.title)
                
                Button(action: {
                    isRunning.toggle()
                    if isRunning {
                        startTimer()
                    } else {
                        stopTimer()
                    }
                }) {
                    Text(isRunning ? "Pause" : "Start")
                        .font(.headline)
                        .padding(5)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
        }
        .padding(10)
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
