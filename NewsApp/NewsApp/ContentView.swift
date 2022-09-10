//
//  ContentView.swift
//  NewsApp
//
//  Created by Hasan Hasanov on 09.09.22.
//

import SwiftUI
struct ContentView: View {
    @State var selectedIndex = 0
    init (){
        UITabBar.appearance().backgroundColor = UIColor(named: "lightGray")
        
        UITabBar.appearance().itemSpacing = 20
    }
    var body: some View {
        TabView(selection: $selectedIndex){
            HomeView()
                .tabItem {
                    Image(systemName: selectedIndex == 0 ? "house.fill" : "house")
                }
                .tag(0)
            SaveView()
                .tabItem {
                    Image(systemName: selectedIndex == 1 ? "bookmark.fill" : "bookmark")
                }
                .tag(1)
        }
        .accentColor(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
