import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        TabView {
            OverviewView()
                .tabItem {
                    Label("Overview", systemImage: "house")
                }
            
            PracticeView()
                .tabItem {
                    Label("Practice", systemImage: "function")
                }
            
            ProgressViewTab()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar")
                }
            
            ReferenceView()
                .tabItem {
                    Label("Reference", systemImage: "book")
                }
 
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
    
}
