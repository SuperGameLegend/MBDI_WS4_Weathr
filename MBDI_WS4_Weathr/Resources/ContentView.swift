//
//  ContentView.swift
//  MBDI_WS4_Weathr
//
//  Created by Emre Sağır on 14/02/2025.
//

import SwiftUI

struct ContentView: View {
    @State var weatherData: WeatherData?
    @State var test = ""
    @State var currentTemperature = "23"
    var body: some View {
        ZStack {
            

            Image("Lenticular_Cloud").resizable().ignoresSafeArea().aspectRatio(contentMode: .fill)
            VStack{
                Text(test).font(.custom("Helvetica Neue UltraLight",size:70))
                
                Text(currentTemperature).font(.custom("Helvetica Neue UltraLight",size:120))
            }

        }
        .padding().onAppear {
            loadData(urlString: "https://api.openweathermap.org/data/2.5/weather?q=Den%20Bosch&units=metric&appid=f54f13fa57c119e48d6e09992d6179ac")
        }
    }
    
    func loadData(urlString: String){
        var temperature = "?"
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
            self.weatherData = newWeatherData
            print("succes")
        }
        task.resume()
        
    }
    
    func getTemperatureString()->String{
        return ""
    }
    
}

#Preview {
    ContentView()
}
