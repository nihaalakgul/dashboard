//
//  ContentView.swift
//  dashboard
//
//  Created by Nihal Akgül on 12.09.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home() // uygulama acılınca direkt home gösterilir
        
    }
}

struct Home : View {
    
    
    @State var selected = 0 // hangi günü seçtiğini tutuyorum secilen sütunun rengini değiştirmek icin
    var columns = Array(repeating: GridItem(.flexible(),spacing: 20), count: 2)
    var colors = [Color("Color1"),Color("Color")]
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false){ // dikey kaydırma ve göstergeler:kapalı
            
            
            
            VStack {
                
                HStack {
                    
                    Text("Result Screen")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {}){
                        Image("menu")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                        
                    }
                }
                .padding()
                
                // bar chart
                
                VStack(alignment: .leading, spacing: 25){
                    
                    Text("Daily Workout in Hrs")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    
                    HStack(spacing :15){
                        ForEach(workoutData){work in // her gün icin bar ciziyorum
                            
                            VStack{
                                VStack{
                                    
                                    
                                    Spacer(minLength: 0)
                                    
                                    if selected == work.id {
                                        Text(getHrs(value: work.workoutInMin))
                                            .foregroundColor(Color("Color"))
                                            .padding(.bottom,5)
                                    }
                                    
                                    
                                    RoundedShape()
                                        .fill(LinearGradient(gradient: .init(colors: selected == work.id ? colors : [Color.white.opacity(0.06)]), startPoint: .top, endPoint: .bottom))
                                    
                                    // maksimum yükseklik 200
                                        .frame(height: getHeight(value: work.workoutInMin))
                                    
                                }
                                .frame(height: 220)
                                .onTapGesture {
                                    
                                    withAnimation(.easeOut){
                                        selected = work.id
                                    }
                                    
                                }
                                
                                
                                Text(work.day)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                
                                
                            }
                            
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.06))
                .cornerRadius(10)
                .padding()
                
                HStack {
                    
                    Text("Statistics")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {}){
                        Image("menu")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                        
                    }
                }
                .padding()
                
                LazyVGrid(columns: columns,spacing: 30){
                    
                    ForEach(statsData){stat in
                        
                        VStack(spacing :22){
                            
                            HStack{
                                
                                Text(stat.title)
                                    .font(.system(size: 22))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Spacer(minLength: 0)
                                
                                
                                
                            }
                            
                            //ring
                            
                            ZStack{
                                Circle()
                                    .trim(from: 0, to: 1)
                                    .stroke(stat.color.opacity(0.05), lineWidth: 10)
                                    .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                Circle()
                                    .trim(from: 0, to: (stat.currentData / stat.goal))
                                    .stroke(stat.color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                    .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                            
                                Text(getPercent(current: stat.currentData, goal: stat.goal) + " %")
                                                                   .font(.system(size: 22))
                                                                   .fontWeight(.bold)
                                                                   .foregroundColor(stat.color)
                                                                   .rotationEffect(.degrees(90))
                                
                            }
                            .rotationEffect(.degrees(-90))
                                            
                            Text(getDecimal(val: stat.currentData) + " " + getType(val: stat.title))
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            
                        }
                        .padding()
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(15)
                        .shadow(color: Color.white.opacity(0.1), radius: 10, x: 0, y: 0)
                    }
                    
                }
                .padding()
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .preferredColorScheme(.dark)
            
        }
    }
    
    
    func getType(val: String) -> String {
            switch val {
            case "Water":
                return "L"
            case "Sleep":
                return "Hrs"
            case "Running":
                return "Km"
            case "Cycling":
                return "Km"
            case "Steps":
                return "stp"
            default:
                return "Kcal"
            }
        }
    
    
    func getDecimal(val: CGFloat) -> String {
            let format = NumberFormatter()
            format.numberStyle = .decimal
            
            return format.string(from: NSNumber.init(value: Float(val)))!
        }
    
    func getPercent(current : CGFloat,goal : CGFloat)-> String{
            let per = (current / goal) * 100
            return String(format: "%.1f",per)
        
    }
    
    //calculating hrs for height
    
    func getHeight(value : CGFloat)->CGFloat{
        
        
        
        
        
        let hrs = CGFloat(value / 1440) * 200
        
        return hrs
        
    }
    
    func getHrs(value: CGFloat)->String{
        let hrs = value / 60
        
        return String(format: "%.1f",hrs)
    }
    
}

struct RoundedShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topLeft,.topRight], cornerRadii: CGSize(width: 5, height: 5))
        
        
        return Path(path.cgPath)
        
    }
    
}


// Sample Data
struct Daily: Identifiable {
    var id: Int
    var day: String
    var workoutInMin: CGFloat
}

var workoutData = [
    Daily(id: 0, day: "Day 1", workoutInMin: 480),
    Daily(id: 1, day: "Day 2", workoutInMin: 880),
    Daily(id: 2, day: "Day 3", workoutInMin: 250),
    Daily(id: 3, day: "Day 4", workoutInMin: 360),
    Daily(id: 4, day: "Day 5", workoutInMin: 1220),
    Daily(id: 5, day: "Day 6", workoutInMin: 750),
    Daily(id: 6, day: "Day 7", workoutInMin: 950)
]

struct Stats: Identifiable {
    var id: Int
    var title: String
    var currentData: CGFloat
    var goal: CGFloat
    var color: Color
}

var statsData = [
    Stats(id: 0, title: "Running", currentData: 6.8, goal: 15, color: Color("running")),
    
    Stats(id: 1, title: "Water", currentData: 3.5, goal: 5, color: Color("water")),
    
    Stats(id: 2, title: "Energy Burn", currentData: 585, goal: 1000, color: Color("energy")),
    
    Stats(id: 3, title: "Sleep", currentData: 6.2, goal: 10, color: Color("sleep")),
    
    Stats(id: 4, title: "Cycling", currentData: 12.5, goal: 25, color: Color("cycle")),
    
    Stats(id: 5, title: "Steps", currentData: 16889, goal: 20000, color: Color("steps")),
]









#Preview {
    ContentView()
}
