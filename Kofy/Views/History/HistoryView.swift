//
//  HistoryView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 14/10/23.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var profileInfo: ProfileViewModel
    @EnvironmentObject var authInfo: VerificationViewModel
    @EnvironmentObject var sessionInfo: SummariesViewModel
    
    var namespace: Namespace.ID
    @Binding var shown: Bool
    @Binding var disabledTouch: Bool
    
    @State var content: History
    var cardColors = ["CardColor0", "CardColor1", "CardColor2", "CardColor3", "CardColor4", "CardColor5"]
    @State var waveformPercentage = 0.0
    @State var rotationAngle = 0.0
    @State var animationsRunning = false
    
    @State private var prescriptionIsDismissed = false
    
    @Binding var prescriptionViewIsShown: Bool

    var body: some View {
        GeometryReader { geometry in
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            VStack {
                ZStack(alignment: .leading) {
                    LinearGradient(colors: [Color(cardColors[content.sessionColor]), Color("BackgroundColor")],
                                   startPoint: .top,
                                   endPoint: .bottom)
                    .matchedGeometryEffect(id: "colorHeader", in: namespace)
                    
                    HStack {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                shown.toggle()
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                disabledTouch.toggle()
                            }
                        }) {
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .bold()
                                .foregroundStyle(.gray)
                        }
                        .padding([.leading])
                        .offset(y: -15)
                        
                        VStack(alignment: .leading) {
                            Text(content.sessionName)
                                .font(Font.system(size: 35, weight: .bold))
                                .matchedGeometryEffect(id: "title", in: namespace)
                            
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text(content.sessionDescription)
                                        .font(Font.system(size: 15))
                                        .matchedGeometryEffect(id: "description", in: namespace, properties: .size)
                                }
                                
                                HStack {
                                    Image(systemName: "person")
                                    Text(content.sessionDoctor)
                                        .font(Font.system(size: 15))
                                        .matchedGeometryEffect(id: "doctor", in: namespace, properties: .size)
                                }
                                
                                HStack {
                                    Image(systemName: "calendar")
                                    Text(content.sessionDate)
                                        .font(Font.system(size: 15))
                                        .foregroundStyle(.yellow)
                                        .matchedGeometryEffect(id: "date", in: namespace, properties: .size)
                                }
                            }
                            .offset(x: 10)
                        }
                        .padding([.top], 30)
                    }
                }
                .frame(height: 200)
                
                VStack(alignment: .leading) {
                    HStack(spacing: 15) {
                        Image(systemName: "waveform.circle.fill")
                        Text("Sesión de escucha")
                            .font(Font.system(.title2))
                            .bold()
                    }
                    .padding([.leading, .trailing])
                    .frame(width: geometry.size.width, alignment: .leading)
                    
                    if (content.isProcessing) {
                        HStack(spacing: 10) {
                            ZStack {
                                Image(systemName: "circle.dotted")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28)
                                    .rotationEffect(.degrees(rotationAngle))
                                    .onAppear {
                                        withAnimation(.linear(duration: 20)
                                                .repeatForever(autoreverses: false)) {
                                                    rotationAngle = 360.0
                                        }
                                    }
                                Image(systemName: "waveform", variableValue: waveformPercentage)
                                    .bold()
                                    .foregroundStyle(Color(cardColors[content.sessionColor]))
                                    .symbolEffect(.variableColor.reversing.cumulative, options: .repeat(10).speed(0.5), value: animationsRunning)
                                    .onAppear {
                                        animationsRunning.toggle()
                                    }
                            }
                            Text("Procesando")
                                .bold()
                                .foregroundStyle(.white)
                        }
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.leading)
                    } else {
                        if (content.summary.summaries.count > 0) {
                            ScrollView {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(content.summary.summaries, id:\.self) { summary in
                                        Text(summary)
                                            .foregroundStyle(.white)
                                            .padding()
                                            .frame(width: geometry.size.width - 50, alignment: .leading)
                                            .background(.thinMaterial)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .padding([.leading, .trailing])
                                    }
                                }
                            }
                            .padding([.leading, .trailing])
                            .frame(width: geometry.size.width)
                            .frame(maxHeight: 250)
                        } else {
                            NavigationLink {
                                SpeechSessionView(sessionName: content.sessionName)
                                    .environmentObject(sessionInfo)
                                    .environmentObject(authInfo)
                                    .onAppear {
                                        sessionInfo.sessionData = SessionData(access_id: content.accessId)
                                        content.isProcessing = true
                                        
                                        withAnimation(.easeInOut(duration: 0.35)) {
                                            shown.toggle()
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                            disabledTouch.toggle()
                                        }
                                    }
                            } label: {
                                AddButtonContent(name: "sesión de escucha")
                            }
                            .padding(.leading)
                        }
                    }
                }
                .frame(width: geometry.size.width)
                
                VStack {
                    Color(red: 0.313, green: 0.313, blue: 0.313)
                        .frame(width: geometry.size.width / 1.3, height: 4)
                        .cornerRadius(.infinity)
                }
                .padding([.leading, .trailing], 15)
                .padding([.top, .bottom], 10)
                
                VStack(alignment: .leading) {
                    HStack(spacing: 15) {
                        Image(systemName: "doc.text")
                        Text("Receta")
                            .font(Font.system(.title2))
                            .bold()
                    }
                    .padding([.leading, .trailing])
                    .frame(width: geometry.size.width, alignment: .leading)
                    
                    if (content.prescription.explanations.count > 0) {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(content.prescription.explanations, id:\.self) { explanation in
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(explanation.name)
                                            .bold()
                                            .font(Font.system(.title3))
                                            .foregroundStyle(Color(cardColors[content.sessionColor]))
                                            .underline()
                                        
                                        VStack(alignment: .leading, spacing: 5) {
                                            ForEach(explanation.explanation, id:\.self) { bullet in
                                                HStack {
                                                    Text("·")
                                                        .bold()
                                                    Text(bullet)
                                                }
                                            }
                                        }
                                    }
                                    .foregroundStyle(.white)
                                    .padding()
                                    .frame(width: geometry.size.width - 50, alignment: .leading)
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .padding([.leading, .trailing])
                                }
                            }
                        }
                        .padding([.leading, .trailing])
                        .frame(width: geometry.size.width)
                        .frame(maxHeight: 300)
                    } else {
                        // ADD PRESCRIPTION
                        NavigationLink {
                            PrescriptionPreviewView(currentContent: [content], isDismissed: $prescriptionIsDismissed, prescriptionIsShown: $prescriptionViewIsShown)
                                .environmentObject(profileInfo)
                                .environmentObject(sessionInfo)
                                .environmentObject(authInfo)
                                .onAppear {
                                    sessionInfo.sessionData.access_id = content.accessId
                                    withAnimation(.easeInOut(duration: 0.35)) {
                                        shown.toggle()
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                        disabledTouch.toggle()
                                    }
                                }
                        } label: {
                            AddButtonContent(name: "receta")
                        }
                        .padding(.leading)
                    }
                }
                .padding([.leading, .trailing])
                .frame(width: geometry.size.width)
                
                Spacer()
            
            }
            .ignoresSafeArea()
        }
        .mask(
            RoundedRectangle(cornerRadius: 25.0)
                .matchedGeometryEffect(id: "roundedShape", in: namespace)
        )
        .ignoresSafeArea()
        .onChange(of: shown) { oldValue, newValue in
            if (newValue) {
                if (content.isProcessing && content.summary.summaries.count == 0) {
                    sessionInfo.validateSpeechSesssion(token: authInfo.userInfo.token, userId: authInfo.userInfo.userId, accessId: content.accessId, content: content)
                }
            }
        }
        }
    }
}

struct AddButtonContent: View {
    @State var name: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "plus")
                .bold()
            Text("Nueva \(name)")
        }
        .foregroundStyle(.white)
        .bold()
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}


#Preview {
    @Namespace var namespace
    @State var authInfo = VerificationViewModel(userService: UserService())
    @State var sessionInfo = SummariesViewModel(userService: UserService())
    
    return HistoryView(namespace: namespace, shown: .constant(true), disabledTouch: .constant(true), content: History(accessId: "aE3RsA", sessionName: "", sessionDescription: "", sessionDate: "2023-11-12", sessionDoctor: "", summary: .init(summaries: []), prescription: .init(explanations: [], reminders: [PrescriptionReminder(drugName: "", dosis: "", everyXHours: 1)]), sessionColor: 2, isProcessing: true), prescriptionViewIsShown: .constant(true))
        .environmentObject(authInfo)
        .environmentObject(sessionInfo)
        .modelContainer(for: [History.self])
}
