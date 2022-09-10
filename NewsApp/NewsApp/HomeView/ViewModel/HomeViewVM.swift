//
//  HomeViewVM.swift
//  NewsApp
//
//  Created by Hasan Hasanov on 09.09.22.
//

import Foundation
import SwiftUI
class HomeViewVM: ObservableObject{
    @Published var articlesArray: [SearchArticle] = []
    @Published var searchedArticles: [SearchArticle] = []
    func getCurrentDate() -> String{
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: Date()))
        let date = Date(timeInterval: seconds, since: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    func getTopHeadlines(){
        let urlstring = "https://newsapi.org/v2/top-headlines?country=us&apiKey=0901a7d75c3b410b8c5bf38ac3ba8621"
        let url = URL(string: urlstring)!
        var urlReq =  URLRequest(url: url)
        urlReq.httpMethod = "GET"
        let session = URLSession.shared.dataTask(with: urlReq) { data, res, err in
            
            if let err = err {
                return
            }
            if let data = data {
                let decoded = try! JSONDecoder().decode(TopHeadLines<[SearchArticle]>.self, from: data)
                DispatchQueue.main.async {
                    self.articlesArray = decoded.articles ?? []
                }
                
            }
        }
        session.resume()
    }
    func searchNews(withTitle: String){
        if withTitle == ""{
            self.searchedArticles = []
        }else{
            let urlstring = "https://newsapi.org/v2/everything?q=\(withTitle.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")&apiKey=0901a7d75c3b410b8c5bf38ac3ba8621"
            let url = URL(string: urlstring)!
            var urlReq =  URLRequest(url: url)
            urlReq.httpMethod = "GET"
            let session = URLSession.shared.dataTask(with: urlReq) { data, res, err in
                
                if let err = err {
                    return
                }
                if let data = data {
                    let decoded = try! JSONDecoder().decode(TopHeadLines<[SearchArticle]>.self, from: data)
                    DispatchQueue.main.async {
                        if decoded.status?.lowercased() != "ok"{
                            
                        }
                        self.searchedArticles = decoded.articles ?? []
                    }
                }
            }
            session.resume()
        }
        
    }
}
