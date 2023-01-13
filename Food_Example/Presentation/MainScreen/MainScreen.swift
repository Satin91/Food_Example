//
//  ContentView.swift
//  Food_Example
//
//  Created by Артур Кулик on 11.01.2023.
//

import SwiftUI

struct MainScreen: View {
    @ObservedObject var viewModel = MainViewModel()
    @State var recipes: String = ""
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                recipeCell
                    .padding()
            }
        }
    }
    
    var recipeCell: some View {
        VStack(alignment: .leading) {
            ForEach(0..<viewModel.recipes.count, id: \.self) { index in
                HStack {
                    AsyncImage(url: URL(string: viewModel.recipes[index].image)) { image in
                        switch image {
                        case .success(let image):
                            image
                                .resizable()
                                .padding()
                        case .empty:
                            EmptyView()
                        case .failure:
                            EmptyView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                    Text(viewModel.recipes[index].title)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
