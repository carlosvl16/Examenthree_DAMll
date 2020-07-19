//
//  ContentView.swift
//  Examenthree
//
//  Created by DAMII on 7/18/20.
//  Copyright © 2020 Cibertec. All rights reserved.
//

import SwiftUI

    

struct PhotosResponse: Decodable {
    let photos: Photos
}
struct Photos: Decodable{
    let photo: [Photo]
}
struct Photo: Identifiable, Decodable {
    let id = UUID().uuidString
    let title: String
    let datetaken: String
}

class PhotoViewModel: ObservableObject {
    var page = 0
 
    
    @Published var photos = [Photo]()
    

    func getPhotos() {
        
   
        let stringUrl = "https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=a6d819499131071f158fd740860a5a88&extras=url_z,date_taken&format=json&nojsoncallback=1"

        let url = URL(string: stringUrl)!
    
         let session = URLSession.shared
        session.dataTask(with: url){
            (data, response, error) in
            DispatchQueue.main.async {
                self.photos = try! JSONDecoder().decode(PhotosResponse.self, from: data!).photos.photo
                self.page += 20
            }
        }.resume()
    }
}

struct PhotoRowView: View {
    let photo: Photo
    var body: some View {
        VStack(alignment: .center ){
            Text(photo.title.capitalized)
            Text(photo.datetaken.capitalized)
           
        }
    }
}

struct ContentView: View {
    
    @ObservedObject var photoVM = PhotoViewModel()
    
    var body: some View {
        NavigationView{
            List{
                ForEach(photoVM.photos) { photo in
                    PhotoRowView(photo: photo)
                }
            }.navigationBarTitle(Text("Fotos"))
            
        }.onAppear{
            self.photoVM.getPhotos()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
