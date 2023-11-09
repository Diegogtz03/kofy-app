//
//  DoctorsViewModel.swift
//  Kofy
//
//  Created by Diego Gutierrez on 29/10/23.
//

import Foundation

class DoctorsViewModel : ObservableObject {
    @Published var doctors = [DoctorInfo]()
    
    init() {
        loadDoctors()
   }
    
    func loadDoctors() {
        self.doctors.append(DoctorInfo())
        self.doctors.append(DoctorInfo())
        self.doctors.append(DoctorInfo())
        self.doctors.append(DoctorInfo())
        self.doctors.append(DoctorInfo())
    }
}
