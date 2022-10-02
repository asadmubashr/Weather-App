//
//  HomeView.swift
//  Weather App
//
//  Created by Apple on 10/2/22.
//

import SwiftUI
import ExytePopupView

struct HomeView: View {
    @ObservedObject private var homeViewModel = HomeViewModel()
    @ObservedObject var locationManager = LocationManager()
    
    @State private var now = Date()
    @State private var nextDate = Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
    
    @State private var searchField: String = ""
    @State private var location: String = "San Francisco"
    @State private var tempLocation: String = ""
    @State private var condition_url: String = "//cdn.weatherapi.com/weather/64x64/night/296.png"
    @State private var temp_f: String = "82.4°F"
    @State private var condition_text: String = "It’s a sunny day."
    @State private var wind_mph: String = "3 mph"
    @State private var humidity: String = "60%"
    
    @State private var forecast_day1_condition_url: String = "//cdn.weatherapi.com/weather/64x64/night/296.png"
    @State private var forecast_day1_temp: String = "82.4°/86°F"
    
    @State private var forecast_day2_condition_url: String = "//cdn.weatherapi.com/weather/64x64/night/296.png"
    @State private var forecast_day2_temp: String = "82.4°/86°F"
    
    @State private var forecast_day3_condition_url: String = "//cdn.weatherapi.com/weather/64x64/night/296.png"
    @State private var forecast_day3_temp: String = "82.4°/86°F"
    
    @State private var isApiCalled: Bool = false
    @State var showingPopup = false
    
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    @FocusState private var focusedField: FocusField?
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .top){
            
            ZStack {}
            .frame( maxWidth: .infinity, maxHeight: .infinity)
            .background(Image("background").resizable())
            .ignoresSafeArea()
            
            ZStack {}
                .frame( maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("bg_color"))
                .opacity(0.83)
            
            GeometryReader { geo in
                VStack {
                    // top
                    VStack {
                        HStack {
                            Text("")
                                .frame(width: geo.size.width * 0.30)
                            Text("\(MethodHandler.getDateformatter(date: now, formatter: "hh:mm:ss aa"))")
                                .foregroundColor(Color.white)
                                .font(.system(size: 16))
                                .frame(width: geo.size.width * 0.30)
                                .onReceive(timer) { _ in
                                    now = Calendar.current.date(byAdding: .second, value: 1, to: now) ?? now
                                }
                            
                            HStack {
                                Spacer()
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Color.white)
                                    //.frame(width: geo.size.width * 0.30)
                                    .onTapGesture(perform: {
                                        showingPopup = true
                                    })
                            }
                            .frame(width: geo.size.width * 0.30)
                            
                            
                        }
                        Spacer()
                        
                        VStack(spacing: 5) {
                            Text(location)
                                .foregroundColor(Color.white)
                                .font(.system(size: 32))
                                .bold()
//                                .onTapGesture(perform:  {
//                                    if userLatitude != "0.0" && userLongitude != "0.0" {
//                                        location = userLatitude + "," + userLongitude
//                                    }
//                                    getWeatherForecast()
//                                })
                            
                            Text("\(MethodHandler.getDateformatter(date: now, formatter: "EEEE, dd MMM YYYY"))")
                                .foregroundColor(Color.white)
                                .font(.system(size: 16))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.20)
                    //.border(Color.red)
                    
                    
                    // Center
                    VStack(spacing: 10) {
                        if isApiCalled {
                            UrlImageView(urlString: "https:" + condition_url)
                                .frame(width: 60, height: 60)
                        }
                        else {
                            Image("sun")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        
                        
                        Text(temp_f)
                            .foregroundColor(Color.white)
                            .font(.system(size: 56))
                        
                        VStack {
                            Text(condition_text)
                                .foregroundColor(Color.white)
                                .font(.system(size: 16))
                            
                            HStack {
                                HStack {
                                    Image("wind_mph")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    Text(wind_mph)
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 12))
                                }
                                
                                HStack {
                                    Image("humidity")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    Text(humidity)
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 12))
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.40)
                    //.border(Color.yellow)
                    
                    
                    // Bottom
                    
                    HStack {
                        VStack {
                            if isApiCalled {
                                UrlImageView(urlString: "https:" + forecast_day1_condition_url)
                                    .frame(width: 20, height: 20)
                            }
                            else {
                                Image("sun")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                            
                            Text(forecast_day1_temp)
                                .foregroundColor(Color.white)
                                .font(.system(size: 12))
                            
                            Text("Today")
                                .foregroundColor(Color.white)
                                .font(.system(size: 12))
                                .bold()
                        }
                        .frame(maxWidth: geo.size.width * 0.30)
                        
                        VStack {
                            if isApiCalled {
                                UrlImageView(urlString: "https:" + forecast_day2_condition_url)
                                    .frame(width: 20, height: 20)
                            }
                            else {
                                Image("sun")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                            
                            Text(forecast_day2_temp)
                                .foregroundColor(Color.white)
                                .font(.system(size: 12))
                            
                            Text("Tomorrow")
                                .foregroundColor(Color.white)
                                .font(.system(size: 12))
                                .bold()
                        }
                        .frame(maxWidth: geo.size.width * 0.30)
                        
                        
                        VStack {
                            if isApiCalled {
                                UrlImageView(urlString: "https:" + forecast_day3_condition_url)
                                    .frame(width: 20, height: 20)
                            }
                            else {
                                Image("sun")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                            
                            Text(forecast_day3_temp)
                                .foregroundColor(Color.white)
                                .font(.system(size: 12))
                            
                            Text("\(MethodHandler.getDateformatter(date: nextDate, formatter: "EEEE"))")
                                .foregroundColor(Color.white)
                                .font(.system(size: 12))
                                .bold()
                        }
                        .frame(maxWidth: geo.size.width * 0.30)
                    }
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.40)
                    //.border(Color.green)
                }
                .popup(isPresented: $showingPopup, type: .toast, position: .top, animation: .easeIn, closeOnTap: false, closeOnTapOutside: true, dismissCallback: {
                    print("dismissed")
                    if searchField != "" {
                        location = searchField
                        getWeatherForecast()
                    }
                }) {
                    ZStack {
                        Color.white
                        VStack {
                            Spacer()
                            HStack {
                                Image(systemName: "arrow.backward")
                                    .foregroundColor(Color.black)
                                    .onTapGesture(perform: {
                                        showingPopup = false
                                    })
                                
                                TextField("City", text: $searchField, onCommit: {
                                    print("on commit")
                                    if searchField != "" {
                                        location = searchField
                                        getWeatherForecast()
                                    }
                                })
                                .padding()
                                .border(Color.blue)
                                .cornerRadius(5)
                                .focused($focusedField, equals: .field)
                                .onAppear {
                                    self.focusedField = .field
                                }
                            }
                            .padding()
                            
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 120)
                    .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
                    
                }
                .popup(isPresented: $homeViewModel.isError, type: .toast, position: .bottom, animation: .easeIn, autohideIn: 3.0, closeOnTap: false, closeOnTapOutside: true){
                    BottomToastView(message: "Response not found", isError: true, isTop: false)
                }
            }
        }
        .onAppear(perform: {
            //locationManager.requestLocation()
            if userLatitude != "0.0" && userLongitude != "0.0" {
                location = userLatitude + "," + userLongitude
            }
            getWeatherForecast()
        })
        
    }
    
    private func getWeatherForecast() {
        showingPopup = false
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    
        homeViewModel.getWeatherForecast(city: location) { response in
            if response {
                
                location = homeViewModel.location?.name ?? location
                condition_url = homeViewModel.current?.condition?.icon ?? condition_url
                temp_f = String(homeViewModel.current?.temp_f ?? 82.4) + "°F"
                condition_text = homeViewModel.current?.condition?.text ?? condition_text
                wind_mph = String(homeViewModel.current?.wind_mph ?? 3) + " mph"
                humidity = String(homeViewModel.current?.humidity ?? 60) + "%"
                
                print(homeViewModel.location?.localtime)
                now = inputFormatter.date(from: homeViewModel.location?.localtime ?? "2022-9-01") ?? now
                forecast_day1_condition_url = homeViewModel.forecast?.forecastday?[0].day?.condition?.icon ?? forecast_day1_condition_url
                forecast_day1_temp = String(homeViewModel.forecast?.forecastday?[0].day?.mintemp_f ?? 82.4) + "/" + String(homeViewModel.forecast?.forecastday?[0].day?.maxtemp_f ?? 86) + "°F"
                
                forecast_day2_condition_url = homeViewModel.forecast?.forecastday?[1].day?.condition?.icon ?? forecast_day2_condition_url
                forecast_day2_temp = String(homeViewModel.forecast?.forecastday?[1].day?.mintemp_f ?? 82.4) + "/" + String(homeViewModel.forecast?.forecastday?[1].day?.maxtemp_f ?? 86) + "°F"
                
                nextDate = inputFormatter.date(from: homeViewModel.forecast?.forecastday?[2].date ?? "2022-9-01") ?? nextDate
                forecast_day3_condition_url = homeViewModel.forecast?.forecastday?[2].day?.condition?.icon ?? forecast_day3_condition_url
                forecast_day3_temp = String(homeViewModel.forecast?.forecastday?[2].day?.mintemp_f ?? 82.4) + "/" + String(homeViewModel.forecast?.forecastday?[2].day?.maxtemp_f ?? 86) + "°F"
                
                isApiCalled = true
                print("api called successfully")
            }
            else {
                print("something went wrong: \(location)")
                //location = tempLocation
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

enum FocusField: Hashable {
    case field
  }
