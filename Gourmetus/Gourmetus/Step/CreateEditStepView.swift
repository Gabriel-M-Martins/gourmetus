//
//  CreateEditStepView.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 26/10/23.
//

import SwiftUI
import PhotosUI

struct CreateEditStepView: View {
    
    @Binding var editingStep: StepModel?
    @StateObject private var imageViewModel = PhotoPickerViewModel()
    @StateObject var stepViewModel =  CreateEditStepViewModel()
    @ObservedObject var recipeViewModel:  CreateEditRecipeViewModel
    @Binding var showSheet: Bool
 
    var body: some View {
        
        ScrollView{
            VStack(alignment: .leading, spacing:16) {
                
                if let image = imageViewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 200)
                        .foregroundColor(.red)
                        .background(Color.blue)
                } else {
                    Image(systemName: "placeholdertext.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 200)
                        .foregroundColor(.red)
                        .background(Color.blue)
                }
                
                PhotosPicker(selection: $imageViewModel.imageSelecion,
                             matching: .any(of: [.images, .not(.screenshots)])) {
                    Text("Select Photos")
                }
                


                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.headline)
                    TextField("Enter text", text: $stepViewModel.texto)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                VStack(alignment: .leading) {
                    Text("Tip")
                        .font(.headline)
                    TextField("Enter tip", text: $stepViewModel.tip)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                VStack(alignment: .leading) {
                    Text("Timer")
                        .font(.headline)
                    TimePicker(totalTime: $stepViewModel.totalTime)
                }
                
                if (editingStep != nil){
                    Button(action: {
                        stepViewModel.editStep(viewModel: recipeViewModel, imageViewModel: imageViewModel ,editingStep: editingStep!)
                        editingStep = nil
                        showSheet.toggle()
                    }) {
                        Text("Edit Step")
                    }
                } else {
                    Button(action: {
                        stepViewModel.addStep(viewModel: recipeViewModel, imageViewModel: imageViewModel)
                        showSheet.toggle()
                    }) {
                        Text("Add Step")
                    }
                }
            }
        }
        .padding()
        .onAppear(perform: {
           
            if (editingStep != nil){
                print("caiu")
                if let image = editingStep!.imageData{
                    imageViewModel.selectedImage = UIImage(data: image)
                }
                stepViewModel.editField(step: editingStep!)
            } else {
                stepViewModel.texto = ""
                stepViewModel.tip = ""
                imageViewModel.selectedImage = UIImage()
            }
        })
    }
    
}

#Preview {
    Text("tr")
}


struct TimePicker: View {
    @Binding var totalTime: Int?
    @State var selectedHour: Int = 0
    @State var selectedMinute: Int = 0
    @State private var isHourPickerVisible = false
    @State private var isMinutePickerVisible = false

    var body: some View {
        VStack {
            HStack {
                Text("Hour: \(selectedHour) hours")
                Spacer()
                Button(action: {
                    isHourPickerVisible.toggle()
                }) {
                    Text("Select Hour")
                }
            }
            .padding()
            .onTapGesture {
                isHourPickerVisible.toggle()
            }

            if isHourPickerVisible {
                Picker("", selection: $selectedHour) {
                    ForEach(0..<24, id: \.self) { i in
                        Text("\(i) hours").tag(i)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
            }

            HStack {
                Text("Minute: \(selectedMinute) min")
                Spacer()
                Button(action: {
                    isMinutePickerVisible.toggle()
                }) {
                    Text("Select Minute")
                }
            }
            .padding()
            .onTapGesture {
                isMinutePickerVisible.toggle()
            }

            if isMinutePickerVisible {
                Picker("", selection: $selectedMinute) {
                    ForEach(0..<60, id: \.self) { i in
                        Text("\(i) min").tag(i)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
        }
        .onChange(of: selectedHour, perform: { newHour in
            updateTotalTimeInMinutes()
        })
        .onChange(of: selectedMinute, perform: { newMinute in
            updateTotalTimeInMinutes()
        })
        .onAppear {
            if let timer = totalTime{
                selectedHour = totalTime! / 60
                selectedMinute = totalTime! % 60
            }
        }
    }

    private func updateTotalTimeInMinutes() {
        totalTime = (selectedHour * 60) + selectedMinute
    }
}
