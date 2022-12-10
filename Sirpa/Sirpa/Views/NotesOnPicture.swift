//
//  NotesOnPicture.swift
//  Sirpa
//
//  Created by iosdev on 12/10/22.
//

import Foundation
import SwiftUI

struct NotesOnPicture: View {
    var body: some View {
        VStack{
            HStack{
                VStack{
                    //PROFILEPIC JA DATE ADDED
                    Text("\(Date(), style: .date)")
                    Image(systemName:"person.fill")
                        .font(.system(size: 50))
                        .cornerRadius(500)
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
                //KARTTA
                Text("Map")
                    .frame(width: 200, height: 200)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(100)
            }
            Spacer()
            HStack {
                //NOTES
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
            }
            Spacer()
        }
    }
}
struct NotesOnPictures_Previews: PreviewProvider {
    static var previews: some View {
        NotesOnPicture()
    }
}
