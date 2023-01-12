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
                                //.frame(width: 60, height: 60)
                                //.scaledToFill()
                                .cornerRadius(8)
                                .padding()
                        case .empty:
                            EmptyView()
                        case .failure(_):
                            EmptyView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                    Text(viewModel.recipes[index].title)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                .background(Color.gray)
            }
            
//            .frame(maxWidth: .infinity)
//            .cornerRadius(8)
//            .background(Color.gray.opacity(0.7))
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
