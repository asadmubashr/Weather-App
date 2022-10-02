//
//  UrlImageView.swift
//  Weather App
//
//  Created by Apple on 10/2/22.
//

import Foundation
import SwiftUI

///////////////////////////////////
struct UrlImageView: View {
    @ObservedObject var urlImageModel: UrlImageModel
    
    init(urlString: String?) {
        urlImageModel = UrlImageModel(urlString: urlString)
    }
    
    var body: some View {
        Image(uiImage: urlImageModel.image ?? UrlImageView.defaultImage!)
            .resizable()
            .scaledToFill()
            //.clipShape(Circle())
    }
    
    static var defaultImage = UIImage(named: "sun")
}


///////////////////////////////////
class UrlImageModel: ObservableObject {
    var imageCache = ImageCache.getImageCache()
    
    @Published var image: UIImage?
    var urlString: String?
        
    init(urlString: String?) {
        self.urlString = urlString
        loadImage()
    }
        
    func loadImageFromUrl() {
        guard let urlString = urlString else {
            return
        }
            
        let url = URL(string: urlString)!
        print(url)
        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
        task.resume()
    }
    
    // cache
    
    func loadImage() {
        if loadImageFromCache() {
            return
        }
        //print("Does not load image from cache")
        loadImageFromUrl()
    }
    
    func loadImageFromCache() -> Bool {
        guard let urlString = urlString else {
            return false
        }
        
        guard let cacheImage = imageCache.get(forKey: urlString) else {
            return false
        }
        
        image = cacheImage
        return true
    }
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        DispatchQueue.main.async {
            if let data = data {
                guard let loadedImage = UIImage(data: data) else {
                    return
                }
                self.imageCache.set(forKey: self.urlString!, image: loadedImage)
                self.image = loadedImage
            }
        }
    }
}

///////////////////////////////////
class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}

import Foundation
import SwiftUI

// Extension for adding rounded corners to specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

// Custom RoundedCorner shape used for cornerRadius extension above
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct BottomToastView: View {
    var message : String
    var isError : Bool = false
    var isTop: Bool = false
    var body: some View{
        
        ZStack{
            isError ? Color.red : Color.green
            VStack{
                if isTop {
                    Spacer()
                }
                Text(message)
                    .foregroundColor(.white)
                if !isTop {
                    Spacer()
                }
            }
            .padding([isTop ? .bottom : .top])
            
        }.frame(height: 80)
    }
}
