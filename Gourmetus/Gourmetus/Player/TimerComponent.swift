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
    @State var id: UUID
    
    let notificationCenter = NotificationCenter.default
    
    @State var notificationId: UUID? = nil
    
    init(initialTime: Int, id: UUID) {
           self._initialTime = State(initialValue: initialTime)
           self._remainingTime = State(initialValue: initialTime)
        self._id = State(initialValue:id)
        
       
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
            
            VStack {
                
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
                        if(isRunning){
                            stopTimer()
                            remainingTime = initialTime
                            startTimer()
                            
                        } else{
                            stopTimer()
                            remainingTime = initialTime
                            
                        }
                        
                        
                    }) {
                        Image(systemName: "repeat.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height:20)
                            .foregroundColor(Color.color_button_container_primary)
                        
                    }
                    
                }
                
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("enteredForeground"))) { _ in
                        custom()
                    }
            
        }.onDisappear{
            if(remainingTime != 0 && remainingTime != initialTime){
                saveData()
            }
            
        }
        .onAppear{
            let (date, integer) = retrieveData()
            
            var diff = 0
            
            if let oldDate = date{
                let newDate = Date()
                
                diff = secondsBetweenDates(oldDate, newDate)
                print(diff)
            }
            
                
            
            
            
            
            if integer != 0 {
                remainingTime = integer - diff - 1
                isRunning.toggle()
                startTimerNoNotification()
            }
        }
        .padding(0)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(5)
    }
    
    var timeFormatted: String {
        let hours = remainingTime / 3600
        let minutes = (remainingTime % 3600) / 60
        let seconds = remainingTime % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func custom(){
        let (date, integer) = retrieveData()
        
        var diff = 0
        
        if let oldDate = date{
            let newDate = Date()
            
            diff = secondsBetweenDates(oldDate, newDate)
            print(diff)
        }
        
        if integer != 0 {
            remainingTime = integer - diff - 1
           
        }
    }
    
    
    func secondsBetweenDates(_ startDate: Date, _ endDate: Date) -> Int {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.second], from: startDate, to: endDate)
            
            if let seconds = components.second {
                return seconds
            } else {
                return 0
            }
        }
    
    func startTimer() {
        notificationId = NotificationService.setTimer(time: remainingTime, title: "Notificacao", subtitle: "Funcionou")
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
                
            } else {
                stopTimer()
                isRunning = false
                remainingTime = initialTime
            }
        }
    }
    
    func startTimerNoNotification() {
       // print(remainingTime)
       
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
        let dateKey = "Date-\(id)"
        let integerKey = "Integer-\(id)"
        UserDefaults.standard.removeObject(forKey: dateKey)
        UserDefaults.standard.removeObject(forKey: integerKey)
    }
    
   
    
    
    func saveData() {
        
            let dateKey = "Date-\(id)"
            let integerKey = "Integer-\(id)"
        
            // Get the current date
            let currentDate = Date()

            // Create UserDefaults object
            let defaults = UserDefaults.standard

            // Save the current date with a specific key
            defaults.set(currentDate, forKey: dateKey)

            // Save the integer value (0 in this case) with a different key
            defaults.set(remainingTime, forKey: integerKey)

            // Synchronize UserDefaults
            defaults.synchronize()
        }
    
    func retrieveData() -> (Date?, Int) {
        let dateKey = "Date-\(id)"
        let integerKey = "Integer-\(id)"

        // Create UserDefaults object
        let defaults = UserDefaults.standard

        // Retrieve the saved date
        let savedDate: Date? = defaults.object(forKey: dateKey) as? Date

        // Retrieve the saved integer value
        let savedInteger = defaults.integer(forKey: integerKey)

        return (savedDate, savedInteger)
    }
}



#Preview {
   
    TimerView(initialTime: 300,id:UUID())
}
