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
					DayView(weather: viewModel.days[0],image: viewModel.iconImages[0])
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
		ContentView(viewModel: ViewModel())
    }
}

struct DayView: View {
	var weather: DailyWeather
	var image: UIImage
	var body: some View {
		GeometryReader{ geometry in
				VStack {
					CloudView(weather: self.weather, image: self.image)
					Text(self.weather.dateString)
						.font(.headline)
				}
				.frame(width: geometry.size.width/2, height: 185.0)
		}
	}
}

struct CloudView: View {
	var weather: DailyWeather
	var image: UIImage
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				ScaledBezier(bezierPath: .cloud)
					.stroke(Color.black, lineWidth:3)
				VStack {
					Text(self.weather.temperature)
						.font(.body)
					Image(uiImage: self.image)
					Text(self.weather.description)
					.frame(width: 150)
					.font(.footnote)
					.lineLimit(2)
				}
			}
		}
	}
}
struct ScaledBezier: Shape {
    let bezierPath: UIBezierPath

    func path(in rect: CGRect) -> Path {
        let path = Path(bezierPath.cgPath)

        // Figure out how much bigger we need to make our path in order for it to fill the available space without clipping.
		let scaleX = rect.width / bezierPath.bounds.width
		let scaleY = rect.height / bezierPath.bounds.height

        // Create an affine transform that uses the multiplier for both dimensions equally.
        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)

        // Apply that scale and send back the result.
        return path.applying(transform)
    }
}
