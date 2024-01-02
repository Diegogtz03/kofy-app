//
//  DoctorsViewModel.swift
//  Kofy
//
//  Created by Diego Gutierrez on 29/10/23.
//

import SwiftUI
import Combine

struct requestBody : Encodable {
    var userId : Int
    
    init(userId: Int) {
        self.userId = userId
    }
}

struct newDoctorBody : Encodable {
    var userId : Int
    var doctorName : String
    var doctorFocus : String
    var doctorPhone : String
    var doctorEmail : String
    
    init(userId: Int, doctorName: String, doctorFocus: String, doctorPhone: String, doctorEmail: String) {
        self.userId = userId
        self.doctorName = doctorName
        self.doctorFocus = doctorFocus
        self.doctorPhone = doctorPhone
        self.doctorEmail = doctorEmail
    }
}

class DoctorsViewModel : ObservableObject {
    @Published var doctors: [DoctorInfo]
    
    private var cancellables = Set<AnyCancellable>()
    let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
        self.doctors = []
   }
    
    func getDoctors(token: String, userId: Int) {
        let bodyData = requestBody(userId: userId)
        
        userService.getDoctors(headers: ["Authorization": "Bearer \(token)"], params: bodyData)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
                switch data {
                    case .finished:
                        break
                    case .failure:
                        print("ERROR, GETTING DOCTORS")
                }
        }, receiveValue: {[weak self] data in
            self?.doctors = data;
        }).store(in: &cancellables)
    }
    
    func createDoctor(token: String, userId: Int, bodyData: newDoctorBody, selectedDoctor: Binding<Int>, toast: Binding<Toast?>) {
        print(bodyData)
        
        userService.createDoctor(headers: ["Authorization": "Bearer \(token)"], params: bodyData)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
                switch data {
                    case .finished:
                        break
                    case .failure:
                        toast.wrappedValue = Toast(style: .warning, appearPosition: .top, message: "Error registrando doctor", topOffset: 0)
                }
        }, receiveValue: {[weak self] data in
            self?.doctors.append(data)
            selectedDoctor.wrappedValue = (self?.doctors.count ?? 0) - 1
        }).store(in: &cancellables)
    }
    
    func updateDoctor(token: String, userId: Int, bodyData: DoctorInfo, currentDoctor: Binding<DoctorInfo>, toast: Binding<Toast?>) {
        userService.updateDoctor(headers: ["Authorization": "Bearer \(token)"], params: bodyData)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
                switch data {
                    case .finished:
                        break
                    case .failure:
                        toast.wrappedValue = Toast(style: .error, appearPosition: .bottom, message: "Error guardando doctor", width: 650)
                }
        }, receiveValue: { data in
            currentDoctor.wrappedValue = data
            toast.wrappedValue = Toast(style: .success, appearPosition: .bottom, message: "Guardado correctamente", width: 350)
        }).store(in: &cancellables)
    }
}
