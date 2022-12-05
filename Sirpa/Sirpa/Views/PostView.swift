//
//  PostView.swift
//  Sirpa
//
//  Created by iosdev on 11.11.2022.
//

import SwiftUI

struct PostView: View {
    @State private var username: String = ""
    @State var choiseMade = "Trips"
    var body: some View {
        ZStack{
            Color.green.opacity(0.4)
            VStack{
                HStack{
                    Menu{
                        Button(action: {
                            choiseMade="First option"
                        }, label: {
                            
                            Text("First option")
                        })
                        Button(action: {
                            choiseMade="Second option"
                        }, label: {
                            Text("Seocnd option")
                        })
                        Button(action: {
                            choiseMade="Third option"
                        }, label: {
                            Text("Third option")
                        })
                        Button(action: {
                            choiseMade="Fourth option"
                        }, label: {
                            Text("Fourth option")
                        })
                    } label: {
                        Label(
                            title: {Text("\(choiseMade)")}, icon: {Image.init(systemName: "plus")}
                        )
                    }
                    .frame(width: 200, height: 30)
                    .border(Color.black, width:2)
                    .padding(.leading, 60)
                    Spacer()
                    Image(systemName: "plus").font(.system(size:90)).background(Color.red)
                        .padding(30)
                }
                TextField("text field", text: $username)
                    .onSubmit {
                        print(username)
                    }
                    .padding(.leading, 60)
                    .frame(width: 300, height: 200)
                    .foregroundColor(Color.white)
                    .border(Color.black, width: 5)
                    
                HStack{
                    Button(action: {}, label: {
                        Text("button")
                    })
                    .padding(60)
                    Spacer()
                    Button(action: {}, label: {
                        Text("button")
                    })
                    .padding(60)
                
                }
                }
            
        }
        
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
