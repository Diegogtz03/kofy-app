//
//  RegistrationPopup.swift
//  Kofy
//
//  Created by Diego Gutierrez on 18/10/23.
//

import SwiftUI
import HealthKit

struct RegistrationPopup: View {
    @EnvironmentObject var authInfo: VerificationViewModel
    @EnvironmentObject var profileInfo: ProfileViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @State var isUpdating: Bool
    
    let profilePictureCount = 5
    
    // Personal data state variables
    @State private var names = ""
    @State private var lastNames = ""
    @State private var birthday = Date()
    @State private var gender = "Seleccionar"
    @State private var profilePicture = 0
    
    // Medical Stats state variables
    @State private var bloodType = "Seleccionar"
    @State private var height = 120
    @State private var weight: Float = 60.0
    @State private var allergies:[String] = []
    @State private var allergiesCount = 0
    @State private var diseases:[String] = []
    @State private var diseasesCount = 0
    
    // Popup variables
    @Binding var popupIsShown: Bool
    @State var cardSlideOffset = 0
    
    // Option variables
    let genders = ["Seleccionar", "Hombre", "Mujer", "Otro"]
    let bloodTypes = ["Seleccionar", "AB+", "AB-", "A+", "A-", "B+", "B-", "O+", "O-"]
    
    @State private var toast: Toast? = nil
    
    // HEALTH KIT
    @State private var hasRequestedHealthData = false
    var healthStore = HKHealthStore()
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    func checkInputs() -> Bool {
        // Check Names
        if (names == "") {
            toast = Toast(style: .warning, appearPosition: .bottom, message: "Nombre(s) vacíos", width: 350, topOffset: -40)
            return false
        }
        
        // Check last names
        if (lastNames == "") {
            toast = Toast(style: .warning, appearPosition: .bottom, message: "Apellido(s) vacíos", width: 350, topOffset: -40)
            return false
        }
        
        // Check Birthday
        if (birthday == Date() || Calendar.current.dateComponents([.year, .month, .day], from: birthday, to: Date()).year ?? 0 < 13) {
            toast = Toast(style: .warning, appearPosition: .bottom, message: "Fecha de nacimiento inválida", topOffset: -40)
            return false
        }
        
        // Check Gender
        if (gender == "Seleccionar") {
            toast = Toast(style: .warning, appearPosition: .bottom, message: "Selecciona un género", width: 350, topOffset: -40)
            return false
        }
        
        // Check bloodType
        if (bloodType == "Seleccionar") {
            toast = Toast(style: .warning, appearPosition: .bottom, message: "Selecciona tipo de sangre", width: 350, topOffset: -40)
            return false
        }
        
        return true
    }
    
    func updateFieldData() {
        if (isUpdating) {
            // Personal data state variables
            names = profileInfo.profileInfo.names
            lastNames = profileInfo.profileInfo.lastNames
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            birthday = dateFormatter.date(from: profileInfo.profileInfo.birthday)!
            gender = profileInfo.profileInfo.gender
            profilePicture = profileInfo.profileInfo.profilePicture
            
            // Medical Stats state variables
            bloodType = profileInfo.profileInfo.bloodType
            height = profileInfo.profileInfo.height
            weight = profileInfo.profileInfo.weight
            
            allergies = profileInfo.profileInfo.allergies == "" ? [] : profileInfo.profileInfo.allergies.components(separatedBy: ",")
            allergiesCount = allergies.count
            diseases = profileInfo.profileInfo.diseases == "" ? [] : profileInfo.profileInfo.diseases.components(separatedBy: ",")
            diseasesCount = diseases.count
        }
    }
    
    func setUpHealthRequest() {
        if HKHealthStore.isHealthDataAvailable() {
            let infoToRead = Set([
                            HKCharacteristicType.init(HKCharacteristicTypeIdentifier.dateOfBirth),
                            HKCharacteristicType.init(HKCharacteristicTypeIdentifier.biologicalSex),
                            HKCharacteristicType.init(HKCharacteristicTypeIdentifier.bloodType),
                            HKQuantityType.init(HKQuantityTypeIdentifier.height),
                            HKQuantityType.init(HKQuantityTypeIdentifier.bodyMass),
                            ])

            healthStore.requestAuthorization(toShare: nil, read: infoToRead, completion: { (success, error) in

                if let error = error {
                    print("HealthKit Authorization Error: \(error.localizedDescription)")
                } else {
                    if success {
                        if self.hasRequestedHealthData {
                            print("You've already requested access to health data. ")
                        } else {
                            print("HealthKit authorization request was successful! ")
                        }
                        self.hasRequestedHealthData = true
                    } else {
                        print("HealthKit authorization did not complete successfully.")
                    }
                }
            })
        
            readData()
            readMostRecentSample()
        }
    }
    
    func readData() {
        var sex : HKBiologicalSex?
        var finalBlood : HKBloodType?
        
        // GET BIRTHDAY
        do {
            let birthdayData = try healthStore.dateOfBirthComponents().date!
            birthday = birthdayData
        } catch{}
        
        
        // GET SEX
        do {
            let getSex = try healthStore.biologicalSex()
            sex = getSex.biologicalSex
            if let data = sex {
                let sexData = self.getReadableBiologicalSex(biologicalSex: data)
                gender = sexData
            }
        } catch{}
        
        // Get blood Type
        do {
            let bloodTypeHK = try healthStore.bloodType()
            finalBlood = bloodTypeHK.bloodType
            if let data = finalBlood {
                let bloodData = self.getReadableBloodType(bloodType: data)
                bloodType = bloodData
            }
        } catch{}
    }
    
    func getReadableBiologicalSex(biologicalSex: HKBiologicalSex?) -> String {
        var biologicalSexTest = "Not Retrived"

        if biologicalSex != nil {
            switch biologicalSex!.rawValue{
                case 0:
                    biologicalSexTest = "Seleccionar"
                case 1:
                    biologicalSexTest = "Mujer"
                case 2:
                    biologicalSexTest = "Hombre"
                case 3:
                    biologicalSexTest = "Otro"
                default:
                    biologicalSexTest = "Seleccionar"
            }
        }

        return biologicalSexTest
    }
    
    func getReadableBloodType(bloodType: HKBloodType?) -> String {
        var bloodTypeFinal = "Seleccionar"

        if bloodType != nil {
            switch bloodType!.rawValue {
                case 0:
                    bloodTypeFinal = "Seleccionar"
                case 1:
                    bloodTypeFinal = "A+"
                case 2:
                    bloodTypeFinal = "A-"
                case 3:
                    bloodTypeFinal = "B+"
                case 4:
                    bloodTypeFinal = "B-"
                case 5:
                    bloodTypeFinal = "AB+"
                case 6:
                    bloodTypeFinal = "AB-"
                case 7:
                    bloodTypeFinal = "O+"
                case 8:
                    bloodTypeFinal = "O-"
                default:
                    bloodTypeFinal = "Seleccionar"
            }
        }

        return bloodTypeFinal
    }
    
    func readMostRecentSample() {
        let weightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let heightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!

        let queryWeight = HKSampleQuery(sampleType: weightType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in

            if let result = results?.last as? HKQuantitySample {
                weight = Float(result.quantity.doubleValue(for: HKUnit.gram()) / 1000)
            }
        }

        let queryHeight = HKSampleQuery(sampleType: heightType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in

            if let result = results?.last as? HKQuantitySample {
                // STORE TO VARIABLE
                height = Int(result.quantity.doubleValue(for: HKUnit.meter()) * 100)
            }
        }

        healthStore.execute(queryWeight)
        healthStore.execute(queryHeight)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    VStack {
                        HStack {
                            Text("Tu perfil")
                                .foregroundStyle(.gray)
                                .padding()
                                .padding([.leading], 8)
                                .font(Font.system(size: 28))
                                .bold()
                                .onChange(of: popupIsShown, { oldValue, newValue in
                                    if (!newValue) {
                                        names = ""
                                        cardSlideOffset = 0
                                    } else {
                                        updateFieldData()
                                    }
                                })
                            
                            Spacer()
                            
                            if (isUpdating) {
                                Button {
                                    dismissKeyboard()
                                    popupIsShown.toggle()
                                } label: {
                                    Image(systemName: "x.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.gray)
                                        .frame(width: 30)
                                        .padding([.trailing])
                                }
                            }
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        
                        VStack {
                            ZStack {
                                Image("profile\(profilePicture)")
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
                                    .frame(width: 100)
                                
                                Button {
                                    if (profilePicture + 1 <= profilePictureCount) {
                                        withAnimation {
                                            profilePicture += 1
                                        }
                                    } else {
                                        withAnimation {
                                            profilePicture = 0
                                        }
                                    }
                                } label: {
                                    ZStack {
                                        Color(.blue)
                                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                        Image(systemName: "sparkles")
                                            .resizable()
                                            .foregroundStyle(.white)
                                            .bold()
                                            .scaledToFit()
                                            .frame(width: 15)
                                            .padding(10)
                                    }
                                    .frame(width: 10)
                                    .position(x: 90, y: 85)
                                }
                            }
                            .frame(width: 30, height: 100)
                            
                            HStack {
                                TextField("Nombres", text: $names, prompt: Text("Nombres").foregroundStyle(.gray))
                                    .foregroundStyle(.black)
                                    .padding()
                                    .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                TextField("Apellidos", text: $lastNames, prompt: Text("Apellidos").foregroundStyle(.gray))
                                    .foregroundStyle(.black)
                                    .padding()
                                    .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            HStack {
                                Text("Fecha de Nacimiento")
                                Spacer()
                                if (colorScheme == .dark) {
                                    DatePicker("Fecha de Nacimiento", selection: $birthday, displayedComponents: [.date])
                                        .labelsHidden()
                                        .colorInvert()
                                } else {
                                    DatePicker("Fecha de Nacimiento", selection: $birthday, displayedComponents: [.date])
                                        .labelsHidden()
                                }
                            }
                            .foregroundStyle(.gray)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                            HStack {
                                Text("Genero")
                                Spacer()
                                Picker("Genero", selection: $gender) {
                                    ForEach(genders, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .tint(.black)
                                .background(Color(red: 0.85, green: 0.85, blue: 0.86))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .foregroundStyle(.gray)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onChange(of: gender) { oldValue, newValue in
                                if (newValue == genders[0]) {
                                    gender = genders[1]
                                }
                            }
                            
                            HStack {
                                Text("Tipo de Sangre")
                                Spacer()
                                Picker("Tipo de Sangre", selection: $bloodType) {
                                    ForEach(bloodTypes, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .tint(.black)
                                .background(Color(red: 0.85, green: 0.85, blue: 0.86))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .foregroundStyle(.gray)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onChange(of: bloodType) { oldValue, newValue in
                                if (newValue == bloodTypes[0]) {
                                    bloodType = bloodTypes[1]
                                }
                            }
                            
                            HStack {
                                Text("Altura")
                                Spacer()
                                CustomInputStepper(value: $height, lowerRange: 70, upperRange: 250)
                            }
                            .foregroundStyle(.gray)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            
                            HStack(spacing: 10) {
                                NavigationLink {
                                    TagListView(tags:$allergies, tagNum: $allergiesCount, title: "Alergias", inputDescription: "Escribe tu alergia")
                                } label: {
                                    ZStack {
                                        Color(.white)
                                        Text("Alergias")
                                            .bold()
                                    }
                                    .ignoresSafeArea(.keyboard)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(radius: 3)
                                    .overlay(alignment: .topTrailing, content: {
                                        NumberOverlay(value: $allergiesCount)
                                            .offset(x: 8, y: -8)
                                    })
                                }
                                
                                Spacer()
                                
                                NavigationLink {
                                    TagListView(tags: $diseases, tagNum: $diseasesCount, title: "Enfermedades", inputDescription: "Escribe tu enfermedad")
                                } label: {
                                    ZStack {
                                        Color(.white)
                                        Text("Enfermedades")
                                            .bold()
                                    }
                                    .ignoresSafeArea(.keyboard)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(radius: 3)
                                    .overlay(alignment: .topTrailing, content: {
                                        NumberOverlay(value: $diseasesCount)
                                            .offset(x: 8, y: -8)
                                    })
                                }
                            }
                            .ignoresSafeArea(.keyboard)
                            .foregroundStyle(.gray)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            
                        }
                        .padding()
                    
                        Button {
                            dismissKeyboard()
                            
                            if checkInputs() {
                                let allergiesFormatted = allergies.map{String($0)}.joined(separator: ",")
                                let diseasesFormatted = diseases.map{String($0)}.joined(separator: ",")
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                let formattedBirthday = dateFormatter.string(from: birthday)
                                
                                let bodyData = ProfileInformation(userId: authInfo.userInfo.userId, names: names, last_names: lastNames, birthday: formattedBirthday, gender: gender, profile_picture: profilePicture, blood_type: bloodType, height: height, weight: weight, allergies: allergiesFormatted, diseases: diseasesFormatted)
                                
                                if (!isUpdating) {
                                    profileInfo.setProfileInfo(bodyData: bodyData, token: authInfo.userInfo.token, userId: authInfo.userInfo.userId, toast: $toast, popupIsShown: $popupIsShown)
                                } else {
                                    profileInfo.updateProfileInfo(bodyData: bodyData, token: authInfo.userInfo.token, userId: authInfo.userInfo.userId, toast: $toast, popupIsShown: $popupIsShown)
                                }
                            }
                        } label: {
                            VStack {
                                Text("Guardar")
                                    .bold()
                                    .foregroundStyle(.white)
                                    .font(Font.system(.title2))
                                    .padding([.top, .bottom], 10)
                            }
                            .frame(width: geometry.size.width / 2)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .ignoresSafeArea(.keyboard)
                        .padding(.bottom, geometry.safeAreaInsets.bottom)
                        
                    }
                    .frame(width: geometry.size.width)
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
                    .background(.white)
                    .clipShape(RoundedCornersShape(radius: 16, corners: [.topLeft, .topRight]))
                    .offset(y: CGFloat(cardSlideOffset))
                }
                .shadow(color: .gray, radius: 15, x: 0,  y: 8)
                .edgesIgnoringSafeArea([.bottom])
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if (isUpdating) {
                                if (value.translation.height > 0 && popupIsShown) {
                                    cardSlideOffset = Int(value.translation.height)
                                }
                                
                                if value.translation.height > 100 {
                                    dismissKeyboard()
                                    popupIsShown = false
                                } else if (popupIsShown) {
                                    withAnimation(Animation.easeInOut(duration: 0.2)) {
                                        cardSlideOffset = 0
                                    }
                                }
                            }
                        }
                )
            }
            .onAppear {
                if (!isUpdating) {
                    setUpHealthRequest()
                }
            }
            .toastView(toast: $toast)
        }
    }
}

#Preview {
    ZStack {
        Color(.red)
            .ignoresSafeArea()
        RegistrationPopup(isUpdating: true, popupIsShown: .constant(true))
    }
}
