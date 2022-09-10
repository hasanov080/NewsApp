//
//  HomeView.swift
//  NewsApp
//
//  Created by Hasan Hasanov on 09.09.22.
//

import SwiftUI

private struct GridCell: View{
    
    @Binding var image: String?
    @Binding var description: String?
    var body: some View{
        AsyncImage(url: URL(string: image ?? "")) { imageView in
            (imageView.image ?? Image("noImage"))
                .resizable()
                .cornerRadius(20)
                .colorMultiply(.gray)
                .scaledToFit()
                .overlay {
                    VStack{
                        HStack{
                            Color.gray.frame(width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.height/27, alignment: .center)
                                .opacity(0.9)
                                .cornerRadius(10)
                                .overlay {
                                    Text("News")
                                        .font(Font.system(size: 12, weight: .semibold, design: .serif))
                                }
                            Spacer()
                        }
                        Spacer()
                        Text(description ?? "")
                            .foregroundColor(.white)
                            .frame(width: nil, height: UIScreen.main.bounds.height/20, alignment: .center)
                    }.padding()
                    
                }
        }
            
    }
}

private struct HeaderView: View{
    var date: String
    
    
    var body: some View{
        VStack(alignment: .center, spacing: 0){
            Spacer()
            HStack{
                Color.black
                    .frame(width: 20, height: 20, alignment: .center)
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 5))
                Text("News Catcher")
                    .font(Font.system(size: 20, weight: .bold, design: .default))
                Spacer()
            }
            HStack{
                Text(date)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 5))
                Spacer()
            }
            
        }
    }
}

struct HomeView: View {
    @State var searchText = ""
    @State var contents: [GridItem] = [
        .init(.fixed(UIScreen.main.bounds.height/5), spacing: 8, alignment: .center),
    ]
    @State var newsData: [SearchArticle] = []
    @ObservedObject var vm = HomeViewVM()
    @State var searchNews: [SearchArticle] = []
    @State var selectedSearchNews: SearchArticle?
    @State var showDescription = false
    init (){
        vm.getTopHeadlines()
    }
    func search(){
        vm.searchNews(withTitle: searchText)
    }
    var body: some View {
        VStack{
            HeaderView(date: vm.getCurrentDate())
                .ignoresSafeArea()
                .frame(width: nil, height: UIScreen.main.bounds.height/10, alignment: .bottom)
            ScrollView(.horizontal, showsIndicators: false){
                LazyHGrid(rows: contents, content: {
                    ForEach($newsData){ value in
                        Button{
                            selectedSearchNews = value.wrappedValue
                            showDescription = true
                        } label: {
                            GridCell(image: value.urlToImage, description: value.articleDescription)
                        }
                        .foregroundColor(.black)
                        
                    }
                    
                })
            }
            .scaledToFit()
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            .frame(width: UIScreen.main.bounds.width, height: nil, alignment: .center)
            TextField("Search...", text: $searchText)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
                .onSubmit {
                    search()
                }
                
            HStack{
                Spacer()
                Button {
                    
                } label: {
                    Text("EN")
                        .foregroundColor(.black)
                        .padding()
                    Image("langButton")
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                }
                .frame(width: 90, height: 30, alignment: .center)
                .background(Color("lightGray"))
                .cornerRadius(20)
                .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 10))
                
                

            }
            List($searchNews, selection: $selectedSearchNews){ item in
                
                Button{
                    showDescription = true
                    selectedSearchNews = item.wrappedValue
                } label: {
                    ListCell(type: item.source, title: item.title, date: item.publishedAt, author: item.author, image: item.urlToImage)
                }
                
            }
            .listStyle(.plain)
            .onChange(of: vm.articlesArray) { newValue in
                self.newsData = newValue
            }
            .onChange(of: vm.searchedArticles) { newValue in
                
                self.searchNews = newValue
                
            }
            .fullScreenCover(isPresented: $showDescription) {
                DescriptionView(news: $selectedSearchNews)
            }
            Spacer()
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
