//
//  RadarView.swift
//  Palpi
//
//  Created by  on 9/1/22.
//


import SwiftUI
import Accelerate


struct Arc: Shape {
    let startAngle: Angle = .degrees(0)
    let endAngle: Angle = .degrees(360)
    let clockwise: Bool = false

  func path(in rect: CGRect) -> Path {
    var path = Path()
    let radius = max(rect.size.width, rect.size.height) / 2
    path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: clockwise)
    return path
  }
}


struct BlinkingView: View {
    // Timer will publish every 3.2 seconds on main thread.
    let name: String
    let size: CGFloat
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()

    // Think of this @State var as a light switch.
    // When OFF, what should your users see?
    // When ON, what should your users see?
    // This is DECLARATIVE programming. DECLARE what your views will be.
    @State private var animate = true

    var body: some View {
       let animation = animate ? Animation.default.repeatForever(autoreverses: false) : Animation.easeOut(duration: 0.5)
        Image(systemName: name ).resizable()
            .frame(width: size, height: size)
            .font(.largeTitle.bold())
            .foregroundColor(.red).opacity(animate ? 0.2 : 0.8)
            // OFF: Users see image at 0 offset
            // ON: Users see image at -15 offset
            // Animation takes care off all the in between views! Cool beans!
           // .offset(x: animate ? -15.0 : 0.0)
            // OFF: Background circle opacity 0.4
            // ON: Background circle opacity 0.2
            // In between on and off? My buddy SwiftUI will figure it out! Awesome!
          //  .background( Circle().foregroundColor(.blue).opacity(animate ? 0.2 : 0.4) )
            .onAppear{  DispatchQueue.main.async {
                withAnimation(animation) {
                    self.animate.toggle()                }
            }
}
    }
}

struct NonBlinkingView: View {
    // Timer will publish every 3.2 seconds on main thread.
    let name: String
    let size: CGFloat
   

    var body: some View {
        Image(systemName: name ).resizable()
            .frame(width: size, height: size).padding(.horizontal)
            .font(.largeTitle.bold())
            .foregroundColor(.red).opacity( 0.9)



    }}


struct Polar:  View {
   // @State var connections = 0;
    @Binding var connections: Int;
    
    var body: some View {

            GeometryReader { geometry in
                if geometry.size != .zero {
                    ZStack(alignment: .center) {
                        Arc().stroke(Color.pink, lineWidth: 3).frame(maxWidth: geometry.size.width).zIndex(0)
                        BlinkingView(name: "heart.circle.fill",size: geometry.size.width/10/*50*/)//.alignmentGuide(VerticalAlignment.center)
                        
                        //Add functionality to keep adding Circles to view and done based on relative distance
                        if connections >= 1{
                            ForEach((1...connections), id: \.self) { connection in
                                NonBlinkingView(name: "heart.fill",size: geometry.size.width/14/*25*/).offset(x: CGFloat.random(in: 1..<geometry.size.width/4),y: CGFloat.random(in: 1..<geometry.size.width/4))
                            }
                        }
                        
                    }
                }
        }.scaledToFit()
        
       // .border(Color.blue, width: 3)
    
    }
   
}

//struct RadarView_Previews: PreviewProvider {
//    static var previews: some View {
//
//           Polar(connections: 2)
//    }
//}
