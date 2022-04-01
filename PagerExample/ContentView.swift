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
            pageCount: viewModel.pageCount,
            currentIndex: $viewModel.currentIndex,
            viewModel: viewModel) {
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
    }
}

protocol BasePagerViewType: ObservableObject {
    func movePage(_ goToNext: Bool,
                  gestureValue: GestureStateGesture<DragGesture, CGFloat>.Value,
                  proxyWidth: CGFloat)
    
    func showNextPage(_ goToNext: Bool,
                      gestureValue: GestureStateGesture<DragGesture, CGFloat>.Value,
                      proxyWidth: CGFloat)
    
    func showPreviousPage(gestureValue: GestureStateGesture<DragGesture, CGFloat>.Value,
                          proxyWidth: CGFloat)
}

final class ContentViewModel: BasePagerViewType {
    @Published var currentIndex: Int = 0
    @Published var pageCount: Int = 3
    
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
            let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
            self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
        }
    }
    
    func showPreviousPage(gestureValue: GestureStateGesture<DragGesture, CGFloat>.Value,
                          proxyWidth: CGFloat) {
        let offset = gestureValue.translation.width / proxyWidth
        let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
        self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
