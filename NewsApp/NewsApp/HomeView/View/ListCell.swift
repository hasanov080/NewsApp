//
//  ListCell.swift
//  NewsApp
//
//  Created by Hasan Hasanov on 10.09.22.
//

import SwiftUI

struct ListCell: View{
    @Binding var type: Source?
    @Binding var title: String?
    @Binding var date: String?
    @Binding var author: String?
    @Binding var image: String?
    var body: some View{
        HStack{
            VStack(alignment: .leading, spacing: 8){
                Text(type?.id ?? "")
                    .frame(width: 100, height: 20, alignment: .center)
                    .background(Color("lightGray"))
                    .cornerRadius(10)
                    .font(.system(size: 14, weight: .regular, design: .default))
                
                Text(title ?? "-")
                HStack{
                    Text(date?.split(separator: "T").first ?? "-")
                        .font(.system(size: 12, weight: .light, design: .default))
                    Spacer()
                    if URL(string: author ?? "-") != nil{
                        Text(author ?? "-")
                            .font(.system(size: 12, weight: .bold, design: .default))
                            .textContentType(.URL)
                    }else{
                        Text(author ?? "-")
                            .font(.system(size: 12, weight: .bold, design: .default))
                    }
                    
                }
                
            }
            AsyncImage(url: URL(string: image ?? "")) { contnet in
                (contnet.image ?? Image("noImage"))
                    .resizable()
                    .scaledToFit()
            }
        }
        
    }
}

struct ListCell_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
