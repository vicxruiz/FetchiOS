//
//  LoadingViewModifier.swift
//  FetchiOSApp
//
//  Created by Victor Ruiz on 11/13/23.
//

import Foundation
import SwiftUI

struct LoadingViewModifier: ViewModifier {
    @Binding var isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isLoading {
                ProgressView()
            }
        }
    }
}

extension View {
    @ViewBuilder
    func loading(
        show: Binding<Bool>
    ) -> some View {
        modifier(LoadingViewModifier(isLoading: show))
    }
}
