import SwiftUI
import CoreData
import Firebase
import FirebaseStorage

struct BottomTab: View {
    @ObservedObject var model = ViewModel()

    // tabs
    @State private var selectedTab = 0
        @State private var oldSelectedTab = 0
        @State private var isPostingVisible = false
        let tabsTotal = 2
        let minDragTranlationForSwipe: CGFloat = 50
    
        @FetchRequest(sortDescriptors: [SortDescriptor(\.userID, order: .reverse)]) var cdUserID:
        FetchedResults<OnlineUser>
    var body:some View{
            VStack{
                NavigationView{
                    TabView(selection : $selectedTab){
                        HomeView()
                        .tabItem(){
                            Image(systemName: "globe.americas")
                            Text("Home")
                        }
                        .toolbar(.visible, for: .tabBar)
                        .toolbarBackground(Color.black, for: .tabBar)
                        .tag(0)
                            .highPriorityGesture(DragGesture().onEnded(({
                                self.handleSwipe(translation: $0.translation.width)
                            })))
                        PostView()
                            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                            .tabItem(){
                                Image(systemName: "plus")
                            }
                            .tag(2)
                        ProfileView()
                            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                        .tabItem(){
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                        .toolbar(.visible, for: .tabBar)
                        .toolbarBackground(Color.black, for: .tabBar)
                        .tag(1)
                            .highPriorityGesture(DragGesture().onEnded(({
                                self.handleSwipe(translation: $0.translation.width)
                            })))


                    }
                }

            }
        }

    init() {
        model.retreiveAllPostPhotos()
    }

        private func handleSwipe(translation: CGFloat){
            if translation > minDragTranlationForSwipe && selectedTab > 0{
                selectedTab -= 1
            } else if translation < -minDragTranlationForSwipe && selectedTab < tabsTotal-1{
                selectedTab+=1
            }
        }
    }




private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct BottomTab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BottomTab().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
