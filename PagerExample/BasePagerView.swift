//
//  BasePagerView.swift
//  PagerExample
//
//  Created by Cristopher Escorcia on 31/03/22.
//

import SwiftUI

struct BasePagerView<Content, ViewModel>: View where Content: View, ViewModel: BasePagerViewType {
    let pageCount: Int
    @Binding var currentIndex: Int
    let content: Content
    @GestureState private var translation: CGFloat = 0
    @ObservedObject private var viewModel: ViewModel
    
    init(pageCount: Int,
         currentIndex: Binding<Int>,
         viewModel: ViewModel,
         @ViewBuilder content: () -> Content
    ) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.viewModel = viewModel
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                self.content.frame(width: proxy.size.width)
            }
            .frame(width: proxy.size.width, alignment: .leading)
            .offset(x: -CGFloat(self.currentIndex) * proxy.size.width)
            .offset(x: self.translation)
            .animation(.interactiveSpring(), value: currentIndex)
            .animation(.interactiveSpring(), value: translation)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.width
                }.onEnded { value in
                    let randomBool = Bool.random()
                    print(randomBool)
                    self.viewModel.movePage(false, gestureValue: value, proxyWidth: proxy.size.width)
                }
            )
        }
    }
}
