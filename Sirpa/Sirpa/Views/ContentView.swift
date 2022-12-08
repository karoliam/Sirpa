//
//  ContentView.swift
//  Sirpa
//
//  Created by Karoliina Multas on 6.12.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    let coreDM: CoreDataManager
    //Saa textfieldistä arvon
    @State private var onlineUserID: String = ""
    
    @State private var onlineUsers: [OnlineUser] = [OnlineUser]()
    
    private func populateUsers() {
        onlineUsers = coreDM.getAllOnlineUsers()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Userid", text: $onlineUserID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Save") {
//                    coreDM.saveUserID(userID: onlineUserID)
//                    populateUsers()
                    print("lol")
                }
                
                List(onlineUsers, id: \.self) { user in
                    Text(user.userID ?? "")
                }
                Spacer()
            }.padding()
                .navigationTitle("userIDs")
                .onAppear(perform:{
                    onlineUsers = coreDM.getAllOnlineUsers()
                    populateUsers()
                })
        }
    }
}
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView(coreDM: CoreDataManager())
        }
    }

