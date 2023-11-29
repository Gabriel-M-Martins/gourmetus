//
//  TimerComponent.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 01/11/23.
//

import SwiftUI

class TimerViewModel: ObservableObject {
    @Published var isRunning: Bool = false
    @Published var initialTime: Int
    @Published var remainingTime: Int
    @Published var timer: Timer?
    @Published var id: UUID
    @Published var notificationId: UUID? = nil
    
    let notificationCenter = NotificationCenter.default
    
    init(initialTime: Int, id: UUID) {
        self.initialTime = initialTime
        self.remainingTime = initialTime
        self.id = id
    }
    
    func resetVM(initialTime: Int, id: UUID){
        isRunning = false
        self.initialTime = initialTime
        self.remainingTime = initialTime
        self.id = id
        timer?.invalidate()
        timer = nil
    }
    
    func custom() {
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
    
    func toggleTimer() {
        if isRunning {
            stopTimer()
        } else {
            startTimer()
        }
        isRunning.toggle()
    }
    
    func resetTimer() {
        if(isRunning){
            stopTimer()
            remainingTime = initialTime
            startTimer()
            
        } else{
            stopTimer()
            remainingTime = initialTime
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
    
    func verifyLeft(){
        if(remainingTime != 0 && remainingTime != initialTime){
           // vm.saveData()
            print("saiu no meio")
        }
    }
    
    func startTimer() {
        notificationId = NotificationService.setTimer(time: remainingTime, title: "Notificacao", subtitle: "Funcionou")
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
                
            } else {
                self.stopTimer()
                self.isRunning = false
                self.remainingTime = self.initialTime
            }
        }
    }
    
    func startTimerNoNotification() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
                //print("rodando")
            } else {
                self.stopTimer()
                self.isRunning = false
                self.remainingTime = self.initialTime
            }
        }
    }
    
    func stopTimer() {
        if (notificationId != nil) {
            NotificationService.deleteTimer(id: notificationId!)
        }
        timer?.invalidate()
        timer = nil
//        let dateKey = "Date-\(id)"
//        let integerKey = "Integer-\(id)"
//        UserDefaults.standard.removeObject(forKey: dateKey)
//        UserDefaults.standard.removeObject(forKey: integerKey)
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

struct TimerView: View {
    @ObservedObject var vm: TimerViewModel
    
    init(vm: TimerViewModel) {
        self.vm = vm
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
                        vm.isRunning.toggle()
                        if vm.isRunning {
                            vm.startTimer()
                        } else {
                            vm.stopTimer()
                        }
                    }) {
                        Image(systemName: vm.isRunning ? "pause.circle" : "play.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height:20)
                            .foregroundColor(Color.color_button_container_primary)
                    }
                    
                    Button(action: {
                        if(vm.isRunning){
                            vm.stopTimer()
                            vm.remainingTime = vm.initialTime
                            vm.startTimer()
                            
                        } else{
                            vm.stopTimer()
                            vm.remainingTime = vm.initialTime
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
                vm.custom()
            }
            
        }
        .onDisappear{
//            if(vm.remainingTime != 0 && vm.remainingTime != vm.initialTime){
//               // vm.saveData()
//                print("saiu no meio")
//            }
            vm.stopTimer()
            
        }
//        .onAppear{
//            if($vm.recipe.steps[$vm.currentStepIndex].timer != 0){
//                vm.resetVM(initialTime: vm.recipe.steps[vm.currentStepIndex].timer!, id: vm.recipe.steps[vm.currentStepIndex].id)
//            }
//        }
//        .onAppear{
//            let (date, integer) = vm.retrieveData()
//            
//            var diff = 0
//            
//            if let oldDate = date{
//                let newDate = Date()
//                
//                diff = vm.secondsBetweenDates(oldDate, newDate)
//                print(diff)
//            }
//            
//            if integer != 0 {
//                vm.remainingTime = integer - diff - 1
//                vm.isRunning.toggle()
//                vm.startTimerNoNotification()
//            }
//            
//        }
        .padding(0)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(5)
    }
    
    var timeFormatted: String {
        let hours = vm.remainingTime / 3600
        let minutes = (vm.remainingTime % 3600) / 60
        let seconds = vm.remainingTime % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
//
//#Preview {
//    TimerView()
//}
