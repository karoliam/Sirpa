//
//  FirstPage.swift
//  Sirpa
//
//  Created by Karoliina Multas on 1.12.2022.
//

import SwiftUI
import CoreData
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct FirstPage: View {
//    @FetchRequest(sortDescriptors: [SortDescriptor(\.userID, order: .reverse)]) var cdUserID:
//    FetchedResults<OnlineUser>
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.userID)]) var cdUserID:
    FetchedResults<OnlineUser>
    @State var localUserID = ""

    
    var body: some View {
        ZStack{
            if(localUserID != ""){
                ContentView().environment(\.managedObjectContext, self.viewContext)
            } else {
                VStack{
                    Text("Sirpa")
                        .font(
                            .custom(
                                "AmericanTypewriter",
                                fixedSize: 72)
                            .weight(.bold))
                        .foregroundColor(.white)
                    NavigationLink (destination: Login().environment(\.managedObjectContext, self.viewContext)) {
                        Text("Start your journey")
                            .font(
                                .custom(
                                    "AmericanTypewriter",
                                    fixedSize: 24)
                                .weight(.bold))
                            .foregroundColor(.white)
                        
                            .padding(16)
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 16, height: 20)
                            .foregroundColor(.white)
                            .offset(x: -12)
                        
                    }
                    
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.white))
                    .offset(y:250)
                    
                    
                }
                
                .background(
                    Image("palm-tree")
                )
            }
        }
        .onAppear{
            getUserID()
        }
    }
        
    func getUserID() {
        for item in cdUserID {
            localUserID = item.userID!
        }
        print("\(localUserID)")
    }
}
    

struct FirstPage_Previews: PreviewProvider {
    static var previews: some View {
        FirstPage().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
