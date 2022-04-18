//
//  BasePagerView.swift
//  PagerExample
//
//  Created by Cristopher Escorcia on 31/03/22.
//

import SwiftUI

struct BasePagerView<Content: View>: View {
    typealias OnMovePageParams = ((_ gestureValue: GestureStateGesture<DragGesture, CGFloat>.Value,
                                   _ proxyWidth: CGFloat) -> Void)
    
    let pageCount: Int
    let content: Content
    private var onMovePage: OnMovePageParams?
    @Binding var currentIndex: Int
    @GestureState private var translation: CGFloat = 0
    
    init(pageCount: Int,
         currentIndex: Binding<Int>,
         @ViewBuilder content: () -> Content
    ) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
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
                        self.onMovePage?(value, proxy.size.width)
                    }
                )
                
                HStack {
                    ForEach(0..<pageCount, id: \.self) { index in
                        Circle()
                            .foregroundColor( index == currentIndex ? Color.blue.opacity(0.7) : Color.gray )
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
    }
}

extension BasePagerView {
    func onGestureEnded(_ callback: @escaping (OnMovePageParams)) -> Self {
        var copy = self
        copy.onMovePage = callback
        return copy
    }
}
