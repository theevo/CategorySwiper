//
//  ReceiptView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/5/24.
//

import SwiftUI

struct ReceiptView: View {
    var transaction: CardViewModel
    let reduction: CGFloat = 0.5
    
    var width: CGFloat {
        PreviewScreen.size.width * reduction
    }
    
    var height: CGFloat {
        PreviewScreen.size.height * reduction
    }
    
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading) {
                    Text(transaction.merchant)
                        .font(.title2)
                    Text(transaction.date)
                }
                .frame(width: width, alignment: .leading)
                HStack {
                    Text("Total")
                    Text(transaction.amount, format: .currency(code: transaction.currency))
                        .fontWeight(.semibold)
                }
                .frame(width: width, alignment: .trailing)
            }
            .frame(width: width)
            .padding(25.0)
        }
        .frame(width: width)
        .padding()
        .background(
            TornRectangle(tornEdges: .bottom)
                .fill(Color(uiColor: .lightGray))
                .border(width: 0.25, edges: [.top, .leading, .trailing], color: .black)
        )
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}

#Preview {
    ReceiptView(transaction: CardViewModel.example)
}
