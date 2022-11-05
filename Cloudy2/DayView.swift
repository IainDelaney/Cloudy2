//
//  DayView.swift
//  Cloudy2
//
//  Created by Iain Delaney on 2022-11-02.
//  Copyright © 2022 IainDelaney. All rights reserved.
//

import SwiftUI

struct DayView: View {
    var weather: DailyWeather
    var image: UIImage
    var body: some View {
            VStack(spacing: 0) {
                CloudView(weather: self.weather, image: self.image)
                Text(self.weather.dateString)
                    .font(.headline)
        }
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(weather:DailyWeather(temperature: "11", description: "Warm", dateString: "Today", iconName: "10d") , image: UIImage(named:"preview_icon")!)
    }
}
