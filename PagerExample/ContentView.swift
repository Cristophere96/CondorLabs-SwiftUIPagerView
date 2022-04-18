//
//  ContentView.swift
//  PagerExample
//
//  Created by Cristopher Escorcia on 25/03/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = ContentViewModel()
    
    var body: some View {
        BasePagerView(
            pageCount: viewModel.pagerState.pageCount,
            currentIndex: $viewModel.pagerState.currentIndex) {
            PagerItem() {
                VStack {
                    Text("View title #1")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("blackTextColor"))
                    
                    Spacer()
                    
                    HStack(alignment: .center) {
                        Text("Swipe to continue")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.forward")
                    }
                    .font(.title3)
                    .foregroundColor(.blue)
                }
            }
            
            PagerItem() {
                VStack {
                    Text("View title #2")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("blackTextColor"))
                    
                    Spacer()
                    
                    HStack(alignment: .center) {
                        Text("Swipe to continue")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.forward")
                    }
                    .font(.title3)
                    .foregroundColor(.blue)
                }
            }
            
            PagerItem() {
                VStack {
                    Text("View title #3")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("blackTextColor"))
                    
                    Spacer()
                    
                    Button(action: { print("Tapped") }) {
                        VStack {
                            Text("Save")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
            }
        }
            .onGestureEnded { gestureValue, proxyWidth in
                self.viewModel.movePage(true, gestureValue: gestureValue, proxyWidth: proxyWidth)
            }
    }
}

final class BasePagerViewState: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published var pageCount: Int = 3
}

protocol BasePagerViewType: ObservableObject {
    var pagerState: BasePagerViewState { get set }
    
    func movePage(_ goToNext: Bool,
                  gestureValue: GestureStateGesture<DragGesture, CGFloat>.Value,
                  proxyWidth: CGFloat)
    
    func showNextPage(_ goToNext: Bool,
                      gestureValue: GestureStateGesture<DragGesture, CGFloat>.Value,
                      proxyWidth: CGFloat)
    
    func showPreviousPage(gestureValue: GestureStateGesture<DragGesture, CGFloat>.Value,
                          proxyWidth: CGFloat)
}

extension BasePagerViewType {
    func movePage(_ goToNext: Bool,
                  gestureValue: GestureStateGesture<DragGesture, CGFloat>.Value,
                  proxyWidth: CGFloat) {
        if gestureValue.translation.width > 0 {
            showPreviousPage(gestureValue: gestureValue, proxyWidth: proxyWidth)
        } else {
            showNextPage(goToNext, gestureValue: gestureValue, proxyWidth: proxyWidth)
        }
    }
    
    func showNextPage(_ goToNext: Bool,
                      gestureValue: GestureStateGesture<DragGesture, CGFloat>.Value,
                      proxyWidth: CGFloat) {
        if goToNext {
            let offset = gestureValue.translation.width / proxyWidth
            let newIndex = (CGFloat(self.pagerState.currentIndex) - offset).rounded()
            self.pagerState.currentIndex = min(max(Int(newIndex), 0), self.pagerState.pageCount - 1)
        }
    }
    
    func showPreviousPage(gestureValue: GestureStateGesture<DragGesture, CGFloat>.Value,
                          proxyWidth: CGFloat) {
        let offset = gestureValue.translation.width / proxyWidth
        let newIndex = (CGFloat(self.pagerState.currentIndex) - offset).rounded()
        self.pagerState.currentIndex = min(max(Int(newIndex), 0), self.pagerState.pageCount - 1)
    }
}

final class ContentViewModel: BasePagerViewType {
    var pagerState: BasePagerViewState = .init()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
