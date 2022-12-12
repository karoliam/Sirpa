//
//  PicturesInTripsView.swift
//  Sirpa
//
//  Created by iosdev on 12/10/22.
//

import SwiftUI


struct PicturesInTripsView: View {
    @State var notesShown = false
    var body: some View {
        NavigationView {
            ZStack{
                ScrollView{
                        ForEach(1..<5){_ in
                            HStack(spacing: 4){
                                ForEach(0..<1){_ in
                                    if(notesShown == true) {
                                        Text("")
                                            .frame(width: 390,height: 600)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .overlay(notesOnPicture, alignment: .center)
                                            .onTapGesture(count: 1) {
                                                notesShown.toggle()
                                            }
                                    } else {
                                        Text("")
                                            .frame(width: 390,height: 600)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .onTapGesture(count: 1) {
                                                notesShown.toggle()
                                            }
                                    }
                                }
                            }
                        }

                }
            }.navigationBarTitle("Trip place", displayMode: .inline)
        }
    }
    
    private var notesOnPicture: some View {
        VStack{
            HStack{
                VStack{
                    //PROFILEPIC JA DATE ADDED
                    Text("\(Date(), style: .date)")
                }
                VStack{
                    //IF SHARED
                    Text("Shared")
                }
                .padding()
                VStack{
                    //TIMEADDED
                    Text("\(Date(), style: .time)")
                }
            }
            Spacer()
            HStack {
                Image(systemName:"person.fill")
                    .font(.system(size: 50))
                Circle()
                    .fill(Color.red)
                    .frame(width: 150, height: 150)
                    .padding(30)
            }
            Spacer()
            HStack {
                //NOTES
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
            } .frame(width: 350)
            Spacer()
        }
    }
}





struct PicturesInTripsView_Previews: PreviewProvider {
    static var previews: some View {
        PicturesInTripsView()
    }
}
