//
//  ContentView.swift
//  MBDI_WS4_Weathr
//
//  Created by Emre Sağır on 14/02/2025.
//

import SwiftUI

struct ContentView: View {
    @State var weatherData: WeatherData?
    @State var currentTemperature = "?"
    @State var input = ""
    @State var city = "Utrecht"
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("Lenticular_Cloud")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height) // Ensure it takes full screen size
                    .ignoresSafeArea()
            }
            VStack{
                Text(getTemperatureString()).font(.custom("Helvetica Neue UltraLight",size:95))
                
                TextField("Enter something", text: $input)
                     .padding()
                     .textFieldStyle(RoundedBorderTextFieldStyle())
                     .onSubmit {
                         // Action when Enter key is pressed
                         city = input
                         input = ""
                         loadData(urlString: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=f54f13fa57c119e48d6e09992d6179ac")
                     }
            }

        }
        .padding().onAppear {
            loadData(urlString: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=f54f13fa57c119e48d6e09992d6179ac")
        }
    }
    
    func loadData(urlString: String){
        guard let url = URL(string:urlString) else {
            print("ERROR: failed to construct a URL from string"); return}
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            if let error = error{
                print("ERROR: fetch failed: \(error.localizedDescription)")
                return
            }
            guard let data = data else{
                print("ERROR: no data returned from API call")
                return
            }
            var newWeatherData: WeatherData?
            do{
                newWeatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            } catch let error as NSError{
                print("ERROR: decodig. In domain = \(error.domain), description = \(error.localizedDescription)")
            }
            if newWeatherData == nil{
                print("ERROR: read or decoding failed")
                return
            }
            
            DispatchQueue.main.async {
                self.weatherData = newWeatherData
            }
        }
        task.resume()
        
    }
    
    func getTemperatureString()->String{
        guard let temp = weatherData?.main.temp else{
            return "?"
        }
        return "\(temp)" + " C°"
    }
    
}

#Preview {
    ContentView()
}
