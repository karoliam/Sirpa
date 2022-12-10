//
//  PicturesInTripsView.swift
//  Sirpa
//
//  Created by iosdev on 12/10/22.
//

import SwiftUI

struct PicturesInTripsView: View {
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    ScrollView{
                        VStack{
                            ForEach(0..<5){_ in
                                HStack(spacing: 4){
                                    ForEach(0..<1){_ in
                                        NavigationLink(destination: NotesOnPicture()) {
                                            Text("Notes")
                                                .frame(width: 390,height: 600)
                                                .background(Color.green)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }.navigationBarTitle("Country", displayMode: .inline)
        }
    }
}

struct PicturesInTripsView_Previews: PreviewProvider {
    static var previews: some View {
        PicturesInTripsView()
    }
}
