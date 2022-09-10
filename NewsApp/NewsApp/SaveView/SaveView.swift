//
//  SaveView.swift
//  NewsApp
//
//  Created by Hasan Hasanov on 10.09.22.
//

import SwiftUI

struct SaveView: View {
    @State var savedNews: [SearchArticle] = []
    @State var selectedNews: SearchArticle?
    @State var showDescription = false
    func getSaved(){
        if let data = UserDefaults.standard.data(forKey: "Saved"){
            var decoded = try! JSONDecoder().decode([SearchArticle?].self, from: data)
            decoded.removeAll { article in
                return article == nil
            }
            savedNews = decoded.map({ article in
                return article!
            })
        }
    }
    var body: some View {
        List($savedNews, selection: $selectedNews){ item in
            
            Button{
                showDescription = true
                selectedNews = item.wrappedValue
            } label: {
                ListCell(type: item.source, title: item.title, date: item.publishedAt, author: item.author, image: item.urlToImage)
                
            }
            .foregroundColor(.black)
            .buttonStyle(PlainButtonStyle())
            
        }
        .listStyle(.inset)
        .onAppear {
            self.getSaved()
        }
        .fullScreenCover(isPresented: $showDescription) {
            DescriptionView(news: $selectedNews)
        }
    }
}

struct SaveView_Previews: PreviewProvider {
    static var previews: some View {
        SaveView()
    }
}
