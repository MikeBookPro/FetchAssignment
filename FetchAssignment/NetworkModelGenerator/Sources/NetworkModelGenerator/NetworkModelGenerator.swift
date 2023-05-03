import Foundation

public protocol MealRepresentable: Identifiable {
    var id: String { get }
    var name: String { get }
    var thumnailURL: URL? { get }
}

public protocol MealDetailRepresentable: MealRepresentable {
    var categoryName: String? { get }
    var originName: String? { get }
    var instructions: String? { get }
    var ingredientMeasures: [IngredientMeasure] { get }
    var tags: [String] { get }
    var youtubeURL: URL? { get }
    var sourceURL: URL? { get }
}

public struct Meal: MealRepresentable {
    public let id: String
    public let name: String
    public let thumnailURL: URL?
    
    public init(id: String?, name: String?, thumnailURL: String?) {
        self.id = id ?? UUID().uuidString
        self.name = name ?? "No name available"
        self.thumnailURL = (thumnailURL == nil) ? nil : URL(string: thumnailURL!)
    }
    
    static func generate(fromNetwork meal: NetworkModel.Meal) -> Meal {
        return self.init(id: meal.idMeal, name: meal.strMeal, thumnailURL: meal.strMealThumb)
    }
}

public struct MealDetail: MealDetailRepresentable {
    public let id: String
    public let name: String
    public let thumnailURL: URL?
    public let categoryName: String?
    public let originName: String?
    public let instructions: String?
    public let ingredientMeasures: [IngredientMeasure]
    public let tags: [String]
    public let youtubeURL: URL?
    public let sourceURL: URL?
    
    public init(id: String?, name: String?, thumnailURL: String?, categoryName: String?, originName: String?, instructions: String?, ingredientMeasures: [IngredientMeasure], tags: [String], youtubeURL: String?, sourceURL: String?) {
        self.id = id ?? UUID().uuidString
        self.name = name ?? "No name available"
        self.thumnailURL = (thumnailURL == nil) ? nil : URL(string: thumnailURL!)
        self.categoryName = categoryName
        self.originName = originName
        self.instructions = instructions
        self.ingredientMeasures = ingredientMeasures
        self.tags = tags
        self.youtubeURL = (youtubeURL == nil) ? nil : URL(string: youtubeURL!)
        self.sourceURL = (sourceURL == nil) ? nil : URL(string: sourceURL!)
    }
    
    static func generate(fromNetwork mealDetail: NetworkModel.MealDetail) -> MealDetail {
        self.init(
            id: mealDetail.idMeal,
            name: mealDetail.strMeal,
            thumnailURL: mealDetail.strMealThumb,
            categoryName: mealDetail.strCategory,
            originName: mealDetail.strArea,
            instructions: mealDetail.strInstructions,
            ingredientMeasures: IngredientMeasure.generate(fromMeal: mealDetail),
            tags: (mealDetail.strTags ?? "").split(separator: ",").compactMap({ $0.isEmpty ? nil : String($0) }),
            youtubeURL: mealDetail.strYoutube,
            sourceURL: mealDetail.strSource
        )
    }
}

public struct IngredientMeasure: Hashable {
    public let name: String
    public let measure: String
    
    public init(name: String, measure: String) {
        self.name = name
        self.measure = measure
    }
    
    static func generate(fromMeal details: NetworkModel.MealDetail) -> [IngredientMeasure] {
        [
            (details.strIngredient1, details.strMeasure1),
            (details.strIngredient2, details.strMeasure2),
            (details.strIngredient3, details.strMeasure3),
            (details.strIngredient4, details.strMeasure4),
            (details.strIngredient5, details.strMeasure5),
            (details.strIngredient6, details.strMeasure6),
            (details.strIngredient7, details.strMeasure7),
            (details.strIngredient8, details.strMeasure8),
            (details.strIngredient9, details.strMeasure9),
            (details.strIngredient10, details.strMeasure10),
            (details.strIngredient11, details.strMeasure11),
            (details.strIngredient12, details.strMeasure12),
            (details.strIngredient13, details.strMeasure13),
            (details.strIngredient14, details.strMeasure14),
            (details.strIngredient15, details.strMeasure15),
            (details.strIngredient16, details.strMeasure16),
            (details.strIngredient17, details.strMeasure17),
            (details.strIngredient18, details.strMeasure18),
            (details.strIngredient19, details.strMeasure19),
            (details.strIngredient20, details.strMeasure20),
        ].compactMap { (name, measure) in
            guard let name, let measure, !name.isEmpty, !measure.isEmpty else { return nil }
            return IngredientMeasure(name: name, measure: measure)
        }
    }
}

public enum FoodCategory: String {
    case beef
    case breakfast
    case chicken
    case dessert
    case goat
    case lamb
    case miscellaneous
    case pasta
    case pork
    case seafood
    case side
    case starter
    case vegan
    case vegetarian
    
}

public enum NetworkClient {
    public static func fetchMeals(in category: FoodCategory) async -> [Meal] {
        let result = try? await NetworkAPI.fetchCategoryMeals(c: NetworkModel.MealCategory(rawValue: category.rawValue) ?? .dessert)
        return (result?.meals ?? [NetworkModel.Meal]()).map(Meal.generate(fromNetwork:))
    }
    
    public static func fetchDetail(forMeal meal: some MealRepresentable) async -> [MealDetail] {
        guard let id = Int32(meal.id) else { return [MealDetail]() }
        let result = try? await NetworkAPI.fetchMealDetails(i: id)
        return (result?.meals ?? [NetworkModel.MealDetail]()).map(MealDetail.generate(fromNetwork:))
    }
}
