//
//  PagerItem.swift
//  PagerExample
//
//  Created by Cristopher Escorcia on 25/03/22.
//

import SwiftUI

struct PagerItem<Content: View>: View {
    var content: () -> Content
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    GeometryReader { proxy in
                        ScrollView(showsIndicators: false) {
                            VStack {
                                self.content()
                            }
                            .frame(width: proxy.size.width, height: proxy.size.height)
                        }
                    }
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(5)
                .shadow(color: .gray, radius: 2, x: 0, y: 2)
            }
            .padding()
        }
    }
}

struct PagerItem_Previews: PreviewProvider {
    static var previews: some View {
        PagerItem() {
            Text("View #1")
        }
    }
}
