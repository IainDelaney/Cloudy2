//
//  ContentView.swift
//  Cloudy2
//
//  Created by Iain Delaney on 2020-05-13.
//  Copyright © 2020 IainDelaney. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var viewModel:ViewModel
	var body: some View {
		VStack {
			HStack {
				Text("Weather for \(viewModel.city)")
					.font(.title)
			}
			.frame(height: 30.0)
			VStack{
				HStack{
                    GeometryReader { geometry in
                    DayView(weather: viewModel.days[0],image: viewModel.iconImages[0])
                            .frame(width: geometry.size.width * 0.5)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
					}
				HStack{
					DayView(weather: viewModel.days[1],image: viewModel.iconImages[1])
					DayView(weather: viewModel.days[2],image: viewModel.iconImages[2])
				}
				HStack{
					DayView(weather: viewModel.days[3],image: viewModel.iconImages[3])
					DayView(weather: viewModel.days[4],image: viewModel.iconImages[4])
				}
			}
		}.onAppear {
			self.viewModel.getLocation()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
        ContentView(viewModel: ViewModel(city: "City", days: Array(repeating: DailyWeather(temperature: "10", description: "Warm", dateString: "Today", iconName: "01d"), count: 5) , icons: Array(repeating: UIImage(named:"preview_icon")!, count: 5) ))
	}
}
