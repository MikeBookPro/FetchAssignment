import SwiftUI
import NetworkModelGenerator

@main
struct FetchAssignmentApp: App {
    @State private var meals: [Meal] = []
    
    var body: some Scene {
        WindowGroup {
            MealList(meals: meals)
                .task {
                    let meals = await NetworkClient.fetchMeals(in: .dessert) // Could turn this into a filter later
                    DispatchQueue.main.async {
                        self.meals = meals
                    }
                    let thumbnailURLs = meals.compactMap(\.thumnailURL)
                    if !thumbnailURLs.isEmpty {
                        do {
                            try ImageDownloader.shared.prefetch(itemsFrom: thumbnailURLs)
                        }
                        catch {
                            print("Failed to prefetch thumbnail images")
                        }
                    }
                    
                }
        }
    }
}
