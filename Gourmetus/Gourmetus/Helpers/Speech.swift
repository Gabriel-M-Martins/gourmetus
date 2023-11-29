import Foundation
import SwiftUI
import Speech
import AVFoundation

//1 speech delegate
protocol SpeechViewDelegate {
    func next()
    func previous()
    func finish()
    func quit()
    func first()
    func last()
    func mode()
    func timer()
    func timerReset()
    func tip()
    func help()
}

class Speech: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    
    enum Status {
        case inactive
        case speeking
        case waiting
        case commandAccepted
        
    }
    
    @Published var status: Status = Status.inactive
    
    @Published var recognizedText = ""
    @Published var isRecording = false
    @Published var isNextViewActive: Bool = false
    @Published var showOverlay: Bool = false
    
    //Comando principal
    var commandsChef: [String] = Constants.commandsChefEN + Constants.commandsChefPT
    var commandsNext: [String] = Constants.commandsNextEN + Constants.commandsNextPT
    var commandsPrevious: [String] = Constants.commandsPreviousEN + Constants.commandsPreviousPT
    var commandsQuit: [String] = Constants.commandsQuitEN + Constants.commandsQuitPT
    var commandsFirstStep: [String] = Constants.commandsFirstStepEN + Constants.commandsFirstStepPT
    var commandsLastStep: [String] = Constants.commandsLastStepEN + Constants.commandsLastStepPT
    var commandsFinish: [String] = Constants.commandsFinishEN + Constants.commandsFinishPT
    var commandsMode: [String] = Constants.commandsModeEN + Constants.commandsModePT
    var commandsTimer: [String] = Constants.commandsTimerEN + Constants.commandsTimerPT
    var commandsTimerReset: [String] = Constants.commandsTimerResetEN + Constants.commandsTimerResetPT
    var commandsTip: [String] = Constants.commandsTipEN + Constants.commandsTipPT
    var commandsHelp: [String] = Constants.commandsHelpEN + Constants.commandsHelpPT
    
    var allOneWordCommands: [String] {
        var aux: [String] = []
        aux.append(contentsOf: commandsNext)
        aux.append(contentsOf: commandsPrevious)
        aux.append(contentsOf: commandsQuit)
        aux.append(contentsOf: commandsFirstStep)
        aux.append(contentsOf: commandsLastStep)
        aux.append(contentsOf: commandsFinish)
        aux.append(contentsOf: commandsMode)
        aux.append(contentsOf: commandsTimer)
        aux.append(contentsOf: commandsTimerReset)
        aux.append(contentsOf: commandsTip)
        aux.append(contentsOf: commandsHelp)
        return aux
    }
    
    private var dispatchCancelChef: DispatchWorkItem?
    private var dispatchOverlay: DispatchWorkItem?
    private var dispatchExecuteCommand: DispatchWorkItem?
    private var isListening: Bool = false
    
//    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "pt-BR"))
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: deviceLanguageBR() ? "pt-BR" : "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()

    //2 declare delegate
    var delegateView: SpeechViewDelegate?
    
    override init() {
        super.init()
        speechRecognizer?.delegate = self
        self.dispatchCancelChef = DispatchWorkItem {
            print("passou 5 segundos")
            self.isListening = false
        }
        self.dispatchOverlay = DispatchWorkItem {
            self.showOverlay = false
        }
    
        
    }

    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == .authorized {
                print("Autorização concedida para reconhecimento de voz")
            } else {
                print("Autorização negada para reconhecimento de voz")
            }
        }
    }

    private func startRecording() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.record, mode: .measurement, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Erro ao configurar sessão de áudio: \(error)")
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode as? AVAudioInputNode else {
            fatalError("O nó de entrada de áudio não está disponível")
        }

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Não foi possível criar a solicitação de reconhecimento")
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [ weak self ] result, error in
            var isFinal = false

            if let result = result {
                
//                self?.resultHandler(result: result.bestTranscription.formattedString.lowercased())
                guard let palavra = result.bestTranscription.segments.last?.substring.lowercased() else { return }
                self?.resultHandler(result: palavra )
                self?.recognizedText = palavra

                isFinal = result.isFinal
            }

            if error != nil || isFinal {
                self?.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self?.recognitionRequest = nil
                self?.recognitionTask = nil
                self?.isRecording = false
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        do {
            try audioEngine.start()
            isRecording = true
            status = .waiting
        } catch {
            print("Erro ao iniciar a engine de áudio: \(error)")
        }
    }
    
    //Verificar a palavra que foi falada
    private func resultHandler(result: String) {
        if commandsChef.contains(result){
            print("- command - chefe")
            dispatchCancelChef?.cancel()
            dispatchOverlay?.cancel()
            
            self.dispatchCancelChef = DispatchWorkItem {
                print("passou 5 segundos")
                self.isListening = false
                self.status = .inactive
            }
            self.dispatchOverlay = DispatchWorkItem {
                self.showOverlay = false
                self.status = .inactive
            }
            status = .speeking
            isListening = true
            showOverlay = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: dispatchCancelChef!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: dispatchOverlay!)
            
        } else if allOneWordCommands.contains(result) && isListening == true{
            commandHandler(result: result)
        }
    }
    
    private func commandHandler(result: String) {
        isListening = false
        status = .commandAccepted
        dispatchCancelChef?.cancel()
        dispatchOverlay?.cancel()
        self.dispatchOverlay = DispatchWorkItem {
            self.showOverlay = false
            self.status = .inactive
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: dispatchOverlay!)
        
        if commandsNext.contains(result) {
            print("- command - next")
            self.dispatchExecuteCommand = DispatchWorkItem {
                self.delegateView?.next()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: dispatchExecuteCommand!)
        }else if commandsPrevious.contains(result) {
            print("- command - previous")
            self.dispatchExecuteCommand = DispatchWorkItem {
                self.delegateView?.previous()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: dispatchExecuteCommand!)
        }else if commandsFinish.contains(result) {
            print("- command - finish")
            self.dispatchExecuteCommand = DispatchWorkItem {
                self.delegateView?.finish()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: dispatchExecuteCommand!)
        }else if commandsQuit.contains(result) {
            print("- command - quit")
            self.dispatchExecuteCommand = DispatchWorkItem {
                self.delegateView?.quit()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: dispatchExecuteCommand!)
        }else if commandsFirstStep.contains(result) {
            print("- command - first")
            self.dispatchExecuteCommand = DispatchWorkItem {
                self.delegateView?.first()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: dispatchExecuteCommand!)
        }else if commandsLastStep.contains(result) {
            print("- command - last")
            self.dispatchExecuteCommand = DispatchWorkItem {
                self.delegateView?.last()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: dispatchExecuteCommand!)
        }else if commandsMode.contains(result) {
            print("- command - mode")
            self.dispatchExecuteCommand = DispatchWorkItem {
                self.delegateView?.mode()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: dispatchExecuteCommand!)
        }else if commandsTimer.contains(result) {
            print("- command - timer")
            self.dispatchExecuteCommand = DispatchWorkItem {
                self.delegateView?.timer()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: dispatchExecuteCommand!)
        }else if commandsTimerReset.contains(result) {
            print("- command - timerReset")
            self.dispatchExecuteCommand = DispatchWorkItem {
                self.delegateView?.timerReset()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: dispatchExecuteCommand!)
        }else if commandsTip.contains(result) {
            print("- command - tip")
            self.dispatchExecuteCommand = DispatchWorkItem {
                self.delegateView?.tip()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: dispatchExecuteCommand!)
        }else if commandsHelp.contains(result) {
            print("- command - help")
            self.dispatchExecuteCommand = DispatchWorkItem {
                self.delegateView?.help()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: dispatchExecuteCommand!)
        }
        self.status = .commandAccepted
    }

    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("Reconhecimento de voz disponível")
        } else {
            print("Reconhecimento de voz não está disponível no momento.")
        }
    }
    
    
    

}

func deviceLanguageBR() -> Bool{
    let locale = NSLocale.current.languageCode
    if locale == "pt" {
        return true
    } else {
        return false
    }
}
