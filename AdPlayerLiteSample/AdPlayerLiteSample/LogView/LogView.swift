//
//  LogView.swift
//  AdPlayerQA-SwiftUI
//
//  Created by Pavel Yevtukhov on 18.01.2024.
//

import SwiftUI

struct LogView: View {
    @ObservedObject var viewModel: LogViewModel

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.items) {
                    Text($0.text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: fontSize($0.context)))
                        .foregroundStyle(color($0.context))
                }
            }
        }
    }

    private func fontSize(_ context: LogViewModel.Context) -> CGFloat {
        switch context {
        case .debug:
            return 14
        case .highlight, .warning, .error:
            return 16
        }
    }

    private func color(_ context: LogViewModel.Context) -> Color {
        switch context {
        case .debug:
            return .black
        case .warning:
            return .orange
        case .error:
            return .red
        case .highlight:
            return .accentColor
        }
    }
}
