import SwiftUI
import NetworkModelGenerator

struct MealDetailView: View {
    @State private var mealDetail: MealDetail
    
    init(mealDetail: MealDetail) {
        _mealDetail = .init(initialValue: mealDetail)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                HStack {
                    if let name = mealDetail.categoryName {
                        Text(name)
                    }
                    Spacer()
                    if let name = mealDetail.originName {
                        Text(name)
                    }
                }
                .padding(.horizontal)
                
                
                
                AsyncCachedImage(url: mealDetail.thumnailURL, placeholder: Image(systemName: "carrot")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                //MARK: Ingredients
                if !mealDetail.ingredientMeasures.isEmpty {
                    Section {
                        PillStack(items: mealDetail.ingredientMeasures.map({ "\($0.name): \($0.measure)" })) { text in
                            Text(text)
                                .font(.callout)
                                .foregroundColor(.white)
                                .padding()
                        }
                    } header: {
                        Text("Ingredients")
                            .font(.headline)
                    }
                }
                
                //MARK: Instructions
                if let instructions = mealDetail.instructions {
                    Section {
                        Text(instructions)
                            .togglableTruncateLines(4)
                            .padding(.horizontal)
                    } header: {
                        Text("Instructions")
                            .font(.headline)
                    }
                }
                
                //MARK: Tags
                if !mealDetail.tags.isEmpty {
                    PillStack(items: mealDetail.tags) { text in
                        Text(text)
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                
            }
            
        }
        .navigationTitle(mealDetail.name)
        .task {
            guard
                mealDetail.isProbablyPlaceholder,
                let detail = await NetworkClient.fetchDetail(forMeal: mealDetail).first
            else { return }
            DispatchQueue.main.async {
                self.mealDetail = detail
            }
        }
    }
}

#if DEBUG
struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MealDetailView(mealDetail: PreviewData.mealDetails)
        }
    }
}
#endif
