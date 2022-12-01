//
//  FirstPage.swift
//  Sirpa
//
//  Created by Karoliina Multas on 1.12.2022.
//

import SwiftUI

struct FirstPage: View {
    var body: some View {
        VStack{
            Text("Sirpa")
                .font(
                    .custom(
                        "AmericanTypewriter",
                        fixedSize: 72)
                    .weight(.bold))
                .foregroundColor(.white)
            NavigationLink (destination: Login()) {
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


            }.background(
                Image("palm-tree")
            )
    }
}
    

struct FirstPage_Previews: PreviewProvider {
    static var previews: some View {
        FirstPage()
    }
}
