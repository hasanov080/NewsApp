//
//  WebView.swift
//  NewsApp
//
//  Created by Hasan Hasanov on 10.09.22.
//

import SwiftUI
import WebKit
struct WebView: UIViewRepresentable{
    var url: URL
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct WebSearchView: View {
    var urlString: String?
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack{
            HStack{
                Button{
                    dismiss.callAsFunction()
                }label: {
                    Image(systemName: "arrow.left")
                        .padding()
                        .foregroundColor(.black)
                }
                Spacer()
            }
            WebView(url: URL(string: urlString ?? "https://www.youtube.com/watch?v=waAlgFq9Xq8")!)
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebSearchView()
    }
}
