//
//  CloudView.swift
//  Cloudy2
//
//  Created by Iain Delaney on 2022-11-02.
//  Copyright © 2022 IainDelaney. All rights reserved.
//

import SwiftUI

struct CloudView: View {
    var weather: DailyWeather
    var image: UIImage
    var body: some View {
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

struct CloudView_Previews: PreviewProvider {
    static var previews: some View {
        CloudView(weather: DailyWeather(), image: UIImage(named:"preview_icon")!)
    }
}
