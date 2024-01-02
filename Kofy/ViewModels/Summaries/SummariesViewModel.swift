//
//  SummariesViewModel.swift
//  Kofy
//
//  Created by Diego Gutierrez on 17/11/23.
//

import SwiftUI
import Combine
import SwiftData

struct SessionData: Encodable, Decodable {
    var access_id: String
    
    init() {
        self.access_id = ""
    }
    
    init(access_id: String) {
        self.access_id = access_id
    }
}

struct SessionBodyData: Encodable, Decodable {
    var session: String
    var accessId: String
    
    init(session: String, accessId: String) {
        self.session = session
        self.accessId = accessId
    }
}

struct GenericResult: Encodable, Decodable {
    var message: String
    
    init(message: String) {
        self.message = message
    }
}

struct SummariesResult: Encodable, Decodable {
    var isValid: Bool
    var result: [String]
    
    init(isVerified: Bool, summaries: [String]) {
        self.isValid = isVerified
        self.result = summaries
    }
    
    init() {
        self.isValid = false
        self.result = []
    }
}

struct PrescriptionBodyData: Encodable, Decodable {
    var prescription: String
    var patientInfo: String
    
    init(prescription: String, patientInfo: String) {
        self.prescription = prescription
        self.patientInfo = patientInfo
    }
}

struct PrescriptionResult: Encodable, Decodable {
    var explanations: [PrescriptionSummaryResult]
    var reminders: [ReminderResult]
    
    init(explanations: [PrescriptionSummaryResult], reminders: [ReminderResult]) {
        self.explanations = explanations
        self.reminders = reminders
    }
}

struct ReminderResult: Encodable, Decodable {
    var drugName: String
    var dosis: String
    var everyXHours: Int
    
    init(drugName: String, dosis: String, everyXHours: Int) {
        self.drugName = drugName
        self.dosis = dosis
        self.everyXHours = everyXHours
    }
}

struct PrescriptionSummaryResult: Encodable, Decodable {
    var name: String
    var explanation: [String]
    
    init(name: String, explanation: [String]) {
        self.name = name
        self.explanation = explanation
    }
}

class SummariesViewModel : ObservableObject {
    var modelContext: ModelContext?
    
    @Published var sessionData: SessionData
    @Published var summaries: SummariesResult
    @Published var prescriptionResults: PrescriptionResult
    @Published var drugExplanations: [DoctorInfo]
    @Published var reminders: [DoctorInfo]
    
    private var cancellables = Set<AnyCancellable>()
    let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
        self.sessionData = SessionData()
        self.summaries = SummariesResult()
        self.drugExplanations = []
        self.reminders = []
        self.prescriptionResults = PrescriptionResult(explanations: [], reminders: [])
    }
    
    func updateModelContext(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func registerSession(token: String, userId: Int, newHistory: History) {
        userService.registerSession(headers: ["Authorization": "Bearer \(token)"])
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
                switch data {
                    case .finished:
                        break
                    case .failure:
                        print("ERROR, REGISTERING SESSION")
                }
        }, receiveValue: {[weak self] data in
            self?.sessionData = data
            newHistory.accessId = (self?.sessionData.access_id)!
            self?.modelContext!.insert(newHistory)
        }).store(in: &cancellables)
    }
    
    func sendSpeechSession(token: String, userId: Int, sessionText: String) {
        let bodyData = SessionBodyData(session: sessionText, accessId: self.sessionData.access_id)
        
        userService.sendSpeechSession(headers: ["Authorization": "Bearer \(token)"], params: bodyData)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
                switch data {
                    case .finished:
                        break
                    case .failure:
                        print("ERROR, SENDING SESSION")
                }
        }, receiveValue: { data in
        }).store(in: &cancellables)
    }
    
    func validateSpeechSesssion(token: String, userId: Int, accessId: String, content: History) {
        let bodyData = SessionBodyData(session: "", accessId: accessId)
        
        userService.getSpeechSession(headers: ["Authorization": "Bearer \(token)"], params: bodyData)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
                switch data {
                    case .finished:
                        break
                    case .failure:
                        print("ERROR, GETTING SESSION")
                }
        }, receiveValue: { data in
            self.summaries = data
            
            if (self.summaries.isValid) {
                // UPDATE IN SWIFT DATA WHERE accessId = given
                content.isProcessing = false
                content.summary.summaries = self.summaries.result
                
                // REQUEST TO DELETE FROM DATABASE
                self.endSpeechSession(token: token, userId: userId, bodyData: bodyData)
            }
        }).store(in: &cancellables)
    }
    
    
    func endSpeechSession(token: String, userId: Int, bodyData: SessionBodyData) {
        userService.deleteSpeechSession(headers: ["Authorization": "Bearer \(token)"], params: bodyData)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
                switch data {
                    case .finished:
                        break
                    case .failure:
                        print("ERROR, DELETING SESSION")
                }
        }, receiveValue: { data in
        }).store(in: &cancellables)
    }
    
    
    func getPrescriptionData(token: String, userId: Int, prescriptionText: String, patientInfo: String, accessId: String) {
        let bodyData = PrescriptionBodyData(prescription: prescriptionText, patientInfo: patientInfo)
        var content = getHistory(accessId: accessId)
        
        userService.getPrescriptionSummary(headers: ["Authorization": "Bearer \(token)"], params: bodyData)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
                switch data {
                    case .finished:
                        break
                    case .failure:
                        print("ERROR, GETTING PRESCRIPTION")
                }
        }, receiveValue: { data in
            self.prescriptionResults = data
            self.prescriptionResults.reminders.forEach { reminder in
                content[0].prescription.reminders.append(PrescriptionReminder(drugName: reminder.drugName, dosis: reminder.dosis, everyXHours: reminder.everyXHours))
            }
            self.prescriptionResults.explanations.forEach { explanation in
                content[0].prescription.explanations.append(ExplanationModel(name: explanation.name, explanation: explanation.explanation))
            }
        }).store(in: &cancellables)
    }
    
    
    private func getHistory(accessId: String) -> [History] {
        
        print(accessId)
        
        var content: [History]
        let fetchDescriptor = FetchDescriptor<History>(sortBy: [SortDescriptor(\History.id)])
        
        do {
            content = try modelContext!.fetch(fetchDescriptor)
            content = content.filter { history in
                history.accessId == accessId
            }
            return content
        } catch {
             return []
        }
    }
}
