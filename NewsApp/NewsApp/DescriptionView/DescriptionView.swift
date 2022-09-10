//
//  DescriptionView.swift
//  NewsApp
//
//  Created by Hasan Hasanov on 09.09.22.
//

import SwiftUI


struct DescriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @State var showOptions = false
    @State var openWebView = false
    @State var showAfterDark = false
    @State var isSaved = false
    @Binding var news: SearchArticle?
    init(news: Binding<SearchArticle?>){
        self._news = news
        
    }
    func shareURL(){
        guard let urlShare = URL(string: news?.url ?? "https://developer.apple.com/xcode/swiftui/") else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.keyWindow?.visibleViewController?.present(activityVC, animated: true, completion: nil)
    }
    func saveNews(){
        if isSaved{
            if let data = UserDefaults.standard.data(forKey: "Saved"){
                var decoded = try! JSONDecoder().decode([SearchArticle?].self, from: data)
                decoded.removeAll { article in
                    return article == news
                }
                let encode = try? JSONEncoder().encode(decoded)
                UserDefaults.standard.set(encode, forKey: "Saved")
            }
            withAnimation(.easeIn(duration: 0.3)){
                self.isSaved = false
            }
            
        }else{
            if UserDefaults.standard.data(forKey: "Saved") == nil{
                let dataToStore = [news]
                let encoded = try? JSONEncoder().encode(dataToStore)
                UserDefaults.standard.set(encoded, forKey: "Saved")
            }else{
                if let data = UserDefaults.standard.data(forKey: "Saved"){
                    var decoded = try! JSONDecoder().decode([SearchArticle?].self, from: data)
                    decoded.append(news)
                    let encode = try? JSONEncoder().encode(decoded)
                    UserDefaults.standard.set(encode, forKey: "Saved")
                }
            }
            withAnimation(.easeIn(duration: 0.3)){
                self.isSaved = true
            }
        }
        
    }
    var body: some View {
        VStack{
            AsyncImage(url: URL(string: news?.urlToImage ?? "")) { imageView in
                (imageView.image ?? Image("noImage"))
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3.5, alignment: .center)
                    .overlay {
                        VStack{
                            HStack(alignment: .top, spacing: 8){
                                Button{
                                    self.dismiss.callAsFunction()
                                }label: {
                                    Image(systemName: "arrow.left")
                                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                                        .foregroundColor(.black)
                                    Text(news?.title ?? "Hello")
                                        .font(.system(size: 13, weight: .regular, design: .default))
                                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                                        .foregroundColor(.black)
                                }
                                .background(Color("lightGray"))
                                .cornerRadius(10)
                                .frame(width: UIScreen.main.bounds.width/3, height: 40, alignment: .center)
                                
                                
                                
                                Spacer()
                                VStack(alignment: .trailing, spacing: 5){
                                    Circle().overlay {
                                        VStack{
                                            Button{
                                                withAnimation(.easeInOut) {
                                                    self.showOptions.toggle()
                                                }
                                                
                                                
                                            } label: {
                                                Image(systemName: "ellipsis")
                                                    .foregroundColor(.black)
                                                    .padding()
                                            }
                                            
                                            
                                        }
                                        
                                        
                                    }
                                    .foregroundColor(Color("lightGray"))
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .rotationEffect(.degrees(90))
                                    if showOptions{
                                        List{
                                            Button{
                                                self.saveNews()
                                            }label: {
                                                HStack{
                                                    
                                                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                                                    Text(isSaved ? "Saved" : "Save")
                                                    
                                                }.scaledToFit()
                                                
                                            }
                                            
                                            Button{
                                                DispatchQueue.main.async {
                                                    self.shareURL()
                                                }
                                                
                                            }label: {
                                                HStack{
                                                    Image(systemName: "square.and.arrow.up")
                                                    Text("Share")
                                                }
                                                
                                                
                                            }
                                        }
                                        .cornerRadius(15)
                                        .frame(width: 110, height: 90, alignment: .center)
                                        .listStyle(.plain)
                                        .onAppear {
                                            if let data = UserDefaults.standard.data(forKey: "Saved"){
                                                let decoded = try! JSONDecoder().decode([SearchArticle?].self, from: data)
                                                if decoded.contains(where: { item in
                                                    return item == news
                                                }){
                                                    isSaved = true
                                                }else{
                                                    isSaved = false
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                
                                
                            }
                            .offset(x: 0, y: 30)
                            .padding()
                            Spacer()
                        }
                        
                    }
                    
            }
                
                
            Color.white
                .cornerRadius(40, corners: [.topLeft, .topRight])
                .offset(x: 0, y: -45)
                .overlay{
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .center, spacing: 5){
                            Spacer()
                            Spacer()
                            HStack{
                                Text(news?.source?.id ?? "")
                                    .frame(width: 120, height: 30, alignment: .center)
                                    .background(Color("lightGray"))
                                    .cornerRadius(15)
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                    .offset(x: 0, y: -20)
                                Spacer()
                            }
                            
                            Text(news?.title ?? "")
                                .padding()
                                .font(.system(size: 24, weight: .bold, design: .default))
                            HStack{
                                Spacer()
                                Text(news?.author ?? "")
                                    .foregroundColor(.blue)
                                .padding()
                            }
                            VStack(alignment: .leading, spacing: 24){
                                Text(news?.articleDescription ?? "")
                                    .padding(.horizontal, 30.0)
                                    .font(.system(size: 20, weight: .semibold, design: .default))
                                Text(news?.content ?? "")
                                    .padding(.horizontal, 30.0)
                                    .font(.system(size: 18, weight: .thin, design: .default))
                                HStack{
                                    Spacer()
                                    Button{
                                        self.openWebView = true
                                    } label: {
                                        Text("Read more...")
                                            .padding()
                                    }
                                }
                            }
                            
                            Spacer()
                            
                        }
                        .frame(width: UIScreen.main.bounds.width, height: nil, alignment: .leading)
                        Spacer()
                        
                    }
                    
                    
                    
                }
                
            
            Spacer()
            Button{
                self.showAfterDark = true
            }label: {
                Text("After dark")
                    .foregroundColor(Color.clear)
                    .padding()
                    .offset(x: 0, y: -10)
                    
            }
        }
        .background(.clear)
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $openWebView) {
            
            WebSearchView(urlString: news?.url)
            
        }
        .fullScreenCover(isPresented: $showAfterDark) {
            WebSearchView(urlString: nil)
        }
        .onAppear {
            self.showAfterDark = false
        }
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
