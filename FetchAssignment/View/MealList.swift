import SwiftUI
import NetworkModelGenerator

extension MealDetail {
    static func placeholder(from meal: Meal) -> MealDetail {
        .init(id: meal.id, name: meal.name, thumnailURL: meal.thumnailURL?.absoluteString, categoryName: nil, originName: nil, instructions: nil, ingredientMeasures: [], tags: [], youtubeURL: nil, sourceURL: nil)
    }
    
    var isProbablyPlaceholder: Bool {
        categoryName == nil &&
        originName == nil &&
        instructions == nil &&
        ingredientMeasures.isEmpty &&
        tags.isEmpty &&
        youtubeURL == nil &&
        sourceURL == nil
    }
}

struct MealList: View {
    let meals: [Meal]
    
    var body: some View {
        NavigationView {
            List(meals) { meal in
                NavigationLink(meal.name) {
                    MealDetailView(mealDetail: MealDetail.placeholder(from: meal))
                }
            }
            .navigationTitle("Meals")
        }
    }
}

#if DEBUG
struct MealList_Previews: PreviewProvider {

    static var previews: some View {
        MealList(meals: PreviewData.meals)
    }
}
#endif
