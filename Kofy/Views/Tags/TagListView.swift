//
//  TagListView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 28/10/23.
//

import SwiftUI

struct TagListView: View {
    @Binding var tags: [String]
    @Binding var tagNum: Int
    
    @State var title: String
    @State var inputDescription: String
    @State var tagField = ""
    
    @Environment(\.dismiss) var dismiss
    
    @State var refreshTagList = false;
    
    
    func addTag() {
        if !tags.contains(tagField.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()) {
            withAnimation {
                tags.append(tagField.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
            }
            
            tagField = ""
            tagNum += 1
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black)
                    .ignoresSafeArea()
                VStack {
                    
                    HStack {
                        Image(systemName: "chevron.left")
                            .padding([.leading], 10)
                            .bold()
                            .onTapGesture {
                                dismiss()
                            }
                        Text(title)
                            .font(Font.system(.largeTitle, weight: .bold))
                    }
                    .frame(width: geometry.size.width ,alignment: .leading)
                    
                    HStack(spacing: 15) {
                        TextField(inputDescription, text: $tagField)
                            .padding()
                            .textInputAutocapitalization(.never)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                            .padding([.leading])
                            .onSubmit {
                                addTag()
                            }
                        
                        Button {
                            addTag()
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                                .bold()
                                .background(.ultraThinMaterial)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        }
                        .padding([.trailing])
                    }
                    
                    ScrollView {
                        FlowLayout(mode: .vstack, binding: $refreshTagList, items: $tags, itemSpacing: 4, viewMapping: { tag in
                            IndividualTag(tags: $tags, refreshTagList: $refreshTagList, tagNum: $tagNum, tagContent: tag)
                        }) 
                        .frame(width: geometry.size.width - 35)
                    }
                    .padding()
                
                    Button {
                        dismiss()
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
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    @State var tags = ["Cacahuates", "Gluten", "Aceite"]
    
    return TagListView(tags: $tags, tagNum: .constant(0), title: "Alergias", inputDescription: "Escribe tu alergia")
}
