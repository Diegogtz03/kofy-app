//
//  SpeechSessionView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 11/10/23.
//

import SwiftUI

struct SpeechSessionView: View {
    @State var sessionName = "Nueva Sesión"
    @EnvironmentObject var authInfo: VerificationViewModel
    @EnvironmentObject var sessionInfo: SummariesViewModel
    
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isListening = false
    @State private var sessionStarted = false
    
    @State private var sessionIsFinished = false
    @State private var showingAlert = false
    
    @StateObject var speechModel = ContentViewModel(
        speechSynthesizer: SpeechSynthesizer()
    )
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black)
                    .ignoresSafeArea()
                VStack(alignment: .leading) {
                    HStack {
                        Text(sessionName)
                            .font(Font.system(size: 35))
                            .bold()
                            .foregroundStyle(.gray)
                            .padding([.bottom], -1)
                        
                        Spacer()
                        
                        Text(sessionInfo.sessionData.access_id)
                            .font(Font.system(size: 20))
                            .bold()
                            .foregroundStyle(.gray)
                            .padding([.bottom], -1)
                    }
                    .padding([.leading, .trailing, .top])
                    
                    VStack {
                        Color(red: 0.313, green: 0.313, blue: 0.313)
                            .frame(width: geometry.size.width / 1.3, height: 4)
                            .cornerRadius(.infinity)
                    }
                    .padding([.leading], 15)
                    .padding([.bottom], 2)
                    
                    ScrollViewReader { proxy in
                        ScrollView {
                            Text(speechRecognizer.finalTranscript + speechRecognizer.ongoingTranscript)
                                .font(Font.system(size: 28))
                                .lineSpacing(6)
                                .bold()
                                .padding()
                                .id(1)
                        }
                        .onChange(of: speechRecognizer.finalTranscript) { oldValue, newValue in
                            proxy.scrollTo(1, anchor: .bottom)
                        }
                        .onChange(of: speechRecognizer.ongoingTranscript) { oldValue, newValue in
                            proxy.scrollTo(1, anchor: .bottom)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        if (!sessionStarted) {
                            Button() {
                                AudioSessionManager.shared.activateRecognitionSession()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    speechRecognizer.transcribe(givenAudioSession: AudioSessionManager.shared.recognitionAudioSession)
                                }
                                
                                isListening.toggle()
                                
                                withAnimation {
                                    sessionStarted = true
                                }
                            } label: {
                                ZStack {
                                    Color(.white)
                                    Image(systemName: "play.fill")
                                        .foregroundStyle(.black)
                                }
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .frame(width: 50)
                            }
                            .frame(height: 60)
                        } else {
                            Button {
                                let finalTranscript = speechRecognizer.finalTranscript + speechRecognizer.ongoingTranscript;
                                
                                if (finalTranscript != "") {
                                    speechRecognizer.stopTranscribing()
                                    AudioSessionManager.shared.deactivateAudioSessions()
                                    withAnimation {
                                        sessionIsFinished.toggle()
                                    }
                                    
                                    sessionInfo.sendSpeechSession(token: authInfo.userInfo.token, userId: authInfo.userInfo.userId, sessionText: finalTranscript)
                                } else {
                                    showingAlert = true
                                }
                            } label: {
                                Text("Guardar")
                                    .foregroundStyle(.white)
                                    .bold()
                                    .padding()
                                    .background(.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .opacity(sessionIsFinished ? 0 : 1)
                            }
                            .alert("La sesión está vacía", isPresented: $showingAlert) {
                                Button("OK", role: .cancel) { }
                            }
                        }
                        
                        HStack {
                            ZStack {
                                Color(red: 0.16, green: 0.16, blue: 0.16)
                                    .cornerRadius(.infinity)
                                TextField("Respuesta", text: $speechModel.text)
                                    .padding()
                            }
                            .padding()
                            
                            Button {
                                speechRecognizer.stopTranscribing()
                                AudioSessionManager.shared.activatePlaybackSession()
                                isListening = false
                                speechModel.textToSpeech() {
                                    AudioSessionManager.shared.activateRecognitionSession()
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        speechRecognizer.resumeTranscribing(givenAudioSession: AudioSessionManager.shared.recognitionAudioSession)
                                    }
                                }
                                speechRecognizer.finalTranscript += "\n\(speechModel.text)\n"
                                speechModel.text = ""
                                
                                isListening.toggle()
                            } label: {
                                ZStack {
                                    Color(.blue)
                                    Image(systemName: "text.bubble")
                                        .foregroundStyle(.white)
                                }
                                .clipShape(Circle())
                                .frame(width: 40)
                            }
                            .padding([.trailing])
                        }
                        .frame(height: 60)
                    }
                    .frame(maxWidth: geometry.size.width)
                }
                .blur(radius: sessionIsFinished ? 4 : 0)
                .navigationBarBackButtonHidden()
                .onAppear() {
                    AudioSessionManager.shared.configureRecognitionAudioSession()
                    AudioSessionManager.shared.configurePlaybackAudioSession()
                    AudioSessionManager.shared.activatePlaybackSession()
                }
                
                if (sessionIsFinished) {
                    finishScreen(accessId: sessionInfo.sessionData.access_id)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
        }
    }
}


struct finishScreen: View {
    @State var accessId: String
    @State private var opacity = 0.0
    @State private var isRotating = 0.0
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black)
                    .opacity(0.7)
                VStack {
                    Spacer()
                    
                    VStack {
                        ZStack {
                            Image(systemName: "circle.dotted")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60)
                                .rotationEffect(.degrees(isRotating))
                                .onAppear {
                                    withAnimation(.linear(duration: 20)
                                            .repeatForever(autoreverses: false)) {
                                        isRotating = 360.0
                                    }
                                }
                            Image(systemName: "checkmark")
                                .foregroundStyle(.green)
                                .bold()
                        }
                        .padding([.bottom], 10)
                        
                        Text("Tu información se está procesando.")
                            .font(Font.system(.title3))
                            .bold()
                            .padding(3)
                        
                        Text("Los resultados verificados se encontrarán en tu historial.")
                            .font(Font.system(.callout))
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .padding(4)
                        
                        Text("Recuerda compartir el siguiente código con tu médico:")
                            .font(Font.system(.callout))
                            .foregroundStyle(.gray)
                            .padding(4)
                            .multilineTextAlignment(.center)
                        
                        Text(accessId)
                            .bold()
                    }
                    .padding()
                    .font(Font.system(size: 30))
                    
                    Spacer()
                    
                    Button() {
                        dismiss()
                    } label: {
                        Text("De acuerdo")
                            .foregroundStyle(.white)
                            .bold()
                            .padding()
                            .font(Font.system(.title2))
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    .padding(.bottom, 40)
                }
                .opacity(opacity)
                .frame(width: .infinity, height:  .infinity)
            }
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation {
                        opacity = 1
                    }
                }
            }
        }
    }
}

#Preview {
    SpeechSessionView()
}
