//
//  PostView.swift
//  Sirpa
//
//  Created by iosdev on 11.11.2022.
//

import SwiftUI

struct PostView: View {
    @State private var username: String = ""
    @State var choiceMade = "Trips"
    @State var chosenTripID = ""
    @ObservedObject var model = ViewModel()
    @State var tripName = ""
//    @State var tripNameList: Array<String>
    @State var tripID = ""
    @State private var selection = ""
    
    
    var body: some View {
        ZStack{
            Color.green.opacity(0.4)
            VStack{
                HStack{
                
                                        Menu{
                                            let tripNames = model.tripList.map{item in item.tripName + "#" + item.id}
                                            ForEach(tripNames, id: \.self) { item in
                                                Button(action: {
                                                    choiceMade = String(item.split(separator: "#")[0])
                                                    chosenTripID = String(item.split(separator: "#")[0])
                                                }, label: {
                                                    Text("\(String(item.split(separator: "#")[0]))")
                                                })
                                                       }
                                        } label: {
                                            Label(
                                                title: {Text("\(choiceMade)")}, icon: {Image.init(systemName: "plus")}
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
                        Button(action: {print("triplist \(model.tripList)")}, label: {
                            Text("triplist")
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
    init() {
    model.getTripNames()
    model.getPosts()
    }
    }


    struct PostView_Previews: PreviewProvider {
        static var previews: some View {
            PostView()
        }
    }

