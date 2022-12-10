//
//  ProfileView.swift
//  Sirpa
//
//  Created by iosdev on 11.11.2022.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack{
            VStack{
                VStack{
                    HStack{
                        Image(systemName:"person.fill.turn.down")
                            .font(.system(size: 100))
                        
                        
                        VStack{
                            Text("10")
                            Text("trips")
                        }
                        VStack{
                            Text("10")
                            Text("followers")
                        }
                        .padding()
                        VStack{
                            Text("10")
                            Text("following")
                        }
                    }
                    Button(action: {print("moi")}){
                        Text("follow")
                            .frame(width: 100, height: 40)
                            .background(Color.red)
                        
                    }
                    
                    
                }
                
                ScrollView{
                    VStack{
                        ForEach(0..<5){_ in
                            HStack(spacing: 4){
                                ForEach(0..<2){_ in
                                    NavigationLink(destination: PicturesInTripsView()){
                                        Text("Open image")
                                            .frame(width: 200, height: 200)
                                            .background(Color.yellow)
                                            .foregroundColor(.red)
                                        
                                    }

                                }
                                
                            }
                        }
                    }
                    Spacer()
                }
            }
        }.navigationBarBackButtonHidden(true)

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
