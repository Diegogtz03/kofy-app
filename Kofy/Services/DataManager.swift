//
//  DataManager.swift
//  Kofy
//
//  Created by Diego Gutierrez on 22/11/23.
//

import Foundation
import SwiftData

// 1. HISTORIALES
@Model
class History {
    @Attribute(.unique) var id: UUID
    var accessId: String
    var sessionName: String
    var sessionDescription: String
    var sessionDate: String
    var sessionDoctor: String
    var sessionColor: Int
    var isProcessing: Bool = false
    
    var summary: Summary
    var prescription: Prescription
    
    init(accessId: String, sessionName: String, sessionDescription: String, sessionDate: String, sessionDoctor: String, summary: Summary, prescription: Prescription, sessionColor: Int, isProcessing: Bool) {
        self.id = UUID()
        self.accessId = accessId
        self.sessionName = sessionName
        self.sessionDescription = sessionDescription
        self.sessionDate = sessionDate
        self.sessionDoctor = sessionDoctor
        self.summary = summary
        self.prescription = prescription
        self.sessionColor = sessionColor
        self.isProcessing = isProcessing
    }
}

// 2. RESUMENES
@Model
class Summary {
    var summaries: [String]
    
    init(summaries: [String]) {
        self.summaries = summaries
    }
}

// 3. EXPLICACIONES DE MEDICAMENTOS y RECORDATORIOS
@Model
class Prescription {
    var explanations: [ExplanationModel]
    var reminders: [PrescriptionReminder]
    
    init(explanations: [ExplanationModel], reminders: [PrescriptionReminder]) {
        self.explanations = explanations
        self.reminders = reminders
    }
}


@Model
class ExplanationModel {
    var name: String
    var explanation: [String]
    
    init(name: String, explanation: [String]) {
        self.name = name
        self.explanation = explanation
    }
}

@Model
class RegisteredReminders {
    var identifier: String
    var reminder: PrescriptionReminder
    
    init(identifier: String, reminder: PrescriptionReminder) {
        self.identifier = identifier
        self.reminder = reminder
    }
}

@Model
class PrescriptionReminder {
    var drugName: String
    var dosis: String
    var everyXHours: Int
    
    init(drugName: String, dosis: String, everyXHours: Int) {
        self.drugName = drugName
        self.dosis = dosis
        self.everyXHours = everyXHours
    }
}
