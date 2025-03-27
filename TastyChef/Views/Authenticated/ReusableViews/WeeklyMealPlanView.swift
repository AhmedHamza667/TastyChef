import SwiftUI
import SDWebImageSwiftUI

struct WeeklyMealPlanView: View {
    let mealPlan: MealPlan
    @Environment(\.dismiss) private var dismiss
    
    private var daysOfWeek: [(name: String, day: Day)] {
        [
            ("Monday", mealPlan.week.monday),
            ("Tuesday", mealPlan.week.tuesday),
            ("Wednesday", mealPlan.week.wednesday),
            ("Thursday", mealPlan.week.thursday),
            ("Friday", mealPlan.week.friday),
            ("Saturday", mealPlan.week.saturday),
            ("Sunday", mealPlan.week.sunday)
        ]
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(daysOfWeek, id: \.name) { dayInfo in
                    Section(header: Text(dayInfo.name)) {
                        DayNutrientsView(nutrients: dayInfo.day.nutrients)
                        
                        ForEach(dayInfo.day.meals) { meal in
                            NavigationLink {
                                RecipeDetailView(recipeId: meal.id)
                            } label: {
                                MealRowView(meal: meal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Weekly Meal Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct DayNutrientsView: View {
    let nutrients: Nutrient
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Daily Nutrients")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                NutrientItemView(label: "Calories", value: String(format: "%.0f", nutrients.calories))
                NutrientItemView(label: "Protein", value: String(format: "%.1fg", nutrients.protein))
                NutrientItemView(label: "Fat", value: String(format: "%.1fg", nutrients.fat))
                NutrientItemView(label: "Carbs", value: String(format: "%.1fg", nutrients.carbohydrates))
            }
        }
        .padding(.vertical, 8)
    }
}

struct NutrientItemView: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.caption)
                .bold()
        }
    }
}

struct MealRowView: View {
    let meal: Meal
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: "https://spoonacular.com/recipeImages/\(meal.image)")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.title)
                    .font(.subheadline)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "clock")
                    Text("\(meal.readyInMinutes)min")
                    Text("•")
                    Image(systemName: "person.2")
                    Text("\(meal.servings) servings")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    WeeklyMealPlanView(mealPlan: MealPlan(week: TastyChef.Week(monday: TastyChef.Day(meals: [TastyChef.Meal(id: 655219, image: "Peanut-Butter-And-Chocolate-Oatmeal-655219.jpg", imageType: "jpg", title: "Peanut Butter And Chocolate Oatmeal", readyInMinutes: 45, servings: 1, sourceUrl: "https://www.foodista.com/recipe/JCCVHSNP/peanut-butter-and-chocolate-oatmeal"), TastyChef.Meal(id: 642593, image: "Farfalle-With-Sun-Dried-Tomato-Pesto--Sausage-and-Fennel-642593.jpg", imageType: "jpg", title: "Farfalle With Sun-Dried Tomato Pesto, Sausage and Fennel", readyInMinutes: 20, servings: 4, sourceUrl: "https://www.foodista.com/recipe/CSLBDWBS/farfalle-with-sun-dried-tomato-pesto-sausage-and-fennel"), TastyChef.Meal(id: 633372, image: "bacon-wrapped-meatloaf-633372.jpg", imageType: "jpg", title: "Bacon-Wrapped Meatloaf", readyInMinutes: 90, servings: 6, sourceUrl: "https://www.foodista.com/recipe/NJNVL828/bacon-wrapped-meatloaf")], nutrients: TastyChef.Nutrient(calories: 2000.06, protein: 90.46, fat: 100.08, carbohydrates: 188.45)), tuesday: TastyChef.Day(meals: [TastyChef.Meal(id: 640275, image: "Crab-Cakes-Eggs-Benedict-640275.jpg", imageType: "jpg", title: "Crab Cakes Eggs Benedict", readyInMinutes: 30, servings: 3, sourceUrl: "https://www.foodista.com/recipe/P53KDVS3/crab-cakes-eggs-benedict"), TastyChef.Meal(id: 653251, image: "Noodles-and-Veggies-With-Peanut-Sauce-653251.jpg", imageType: "jpg", title: "Noodles and Veggies With Peanut Sauce", readyInMinutes: 30, servings: 4, sourceUrl: "https://www.foodista.com/recipe/5VRHVVWQ/noodles-and-veggies-with-peanut-sauce"), TastyChef.Meal(id: 632741, image: "arroz-de-galinha-reinvented-632741.jpg", imageType: "jpg", title: "Arroz De Galinha (Reinvented)", readyInMinutes: 45, servings: 6, sourceUrl: "https://www.foodista.com/recipe/RP7CN685/arroz-de-galinha-reinvented")], nutrients: TastyChef.Nutrient(calories: 2000.02, protein: 80.46, fat: 92.07, carbohydrates: 205.73)), wednesday: TastyChef.Day(meals: [TastyChef.Meal(id: 647084, image: "Homemade-Pumpkin-Muffins-647084.jpg", imageType: "jpg", title: "Homemade Pumpkin Muffins", readyInMinutes: 45, servings: 18, sourceUrl: "https://www.foodista.com/recipe/D4BPXNKR/homemade-pumpkin-muffins"), TastyChef.Meal(id: 1697577, image: "spanish-sardines-pasta-1697577.jpg", imageType: "jpg", title: "Spanish Sardines Pasta", readyInMinutes: 25, servings: 2, sourceUrl: "https://maplewoodroad.com/spanish-sardines-pasta/"), TastyChef.Meal(id: 1095827, image: "ginger-garlic-and-lime-chicken-thighs-with-escarole-salad-1095827.jpg", imageType: "jpg", title: "Ginger-Garlic and Lime Chicken Thighs with Escarole Salad", readyInMinutes: 30, servings: 6, sourceUrl: "https://www.foodista.com/recipe/84ZD6N5S/ginger-garlic-and-lime-chicken-thighs-with-escarole-salad")], nutrients: TastyChef.Nutrient(calories: 1999.95, protein: 94.47, fat: 121.4, carbohydrates: 136.44)), thursday: TastyChef.Day(meals: [TastyChef.Meal(id: 716407, image: "simple-whole-wheat-crepes-kingarthurflour-vitamix-716407.jpg", imageType: "jpg", title: "Simple Whole Wheat Crepes", readyInMinutes: 45, servings: 4, sourceUrl: "https://fullbellysisters.blogspot.com/2014/11/simple-whole-wheat-crepes.html"), TastyChef.Meal(id: 1697541, image: "pasta-with-feta-cheese-and-asparagus-1697541.jpg", imageType: "jpg", title: "Pasta With Feta Cheese And Asparagus", readyInMinutes: 20, servings: 2, sourceUrl: "https://maplewoodroad.com/pasta-with-feta-cheese-and-asparagus/"), TastyChef.Meal(id: 658357, image: "Rigatoni-With-Sweet-Sausages-In-Creamy-Tomato-Sauce-658357.jpg", imageType: "jpg", title: "Rigatoni With Sweet Sausages In Creamy Tomato Sauce", readyInMinutes: 45, servings: 4, sourceUrl: "https://www.foodista.com/recipe/B88DK7YQ/rigatoni-with-sweet-sausages-in-creamy-tomato-sauce")], nutrients: TastyChef.Nutrient(calories: 2000.17, protein: 73.7, fat: 87.95, carbohydrates: 232.15)), friday: TastyChef.Day(meals: [TastyChef.Meal(id: 641700, image: "Duck-Egg-Omelette-With-Caviar-and-Sour-Cream-641700.jpg", imageType: "jpg", title: "Duck Egg Omelette With Caviar and Sour Cream", readyInMinutes: 45, servings: 2, sourceUrl: "https://www.foodista.com/recipe/V4WWB2B2/duck-egg-omelette-with-arenkha-msc-and-sour-cream"), TastyChef.Meal(id: 1697577, image: "spanish-sardines-pasta-1697577.jpg", imageType: "jpg", title: "Spanish Sardines Pasta", readyInMinutes: 25, servings: 2, sourceUrl: "https://maplewoodroad.com/spanish-sardines-pasta/"), TastyChef.Meal(id: 637434, image: "Chanterelle-and-Mangalitsa-Speck-Pizza-637434.jpg", imageType: "jpg", title: "Chanterelle and Mangalitsa Speck Pizza", readyInMinutes: 45, servings: 2, sourceUrl: "https://www.foodista.com/recipe/QBBZYKBH/chanterelle-and-mangalitsa-speck-pizza")], nutrients: TastyChef.Nutrient(calories: 1999.99, protein: 77.35, fat: 116.91, carbohydrates: 160.71)), saturday: TastyChef.Day(meals: [TastyChef.Meal(id: 657768, image: "Raisin-Scones-657768.jpg", imageType: "jpg", title: "Raisin Scones", readyInMinutes: 45, servings: 12, sourceUrl: "https://www.foodista.com/recipe/68J6C6RW/raisin-scones"), TastyChef.Meal(id: 1095827, image: "ginger-garlic-and-lime-chicken-thighs-with-escarole-salad-1095827.jpg", imageType: "jpg", title: "Ginger-Garlic and Lime Chicken Thighs with Escarole Salad", readyInMinutes: 30, servings: 6, sourceUrl: "https://www.foodista.com/recipe/84ZD6N5S/ginger-garlic-and-lime-chicken-thighs-with-escarole-salad"), TastyChef.Meal(id: 661948, image: "Striploin-steak-with-roasted-cherry-tomatoes-and-vegetable-mash-661948.jpg", imageType: "jpg", title: "Strip steak with roasted cherry tomatoes and vegetable mash", readyInMinutes: 45, servings: 4, sourceUrl: "https://www.foodista.com/recipe/BS5TFNHL/striploin-steak-with-roasted-cherry-tomatoes-and-vegetable-mash")], nutrients: TastyChef.Nutrient(calories: 2000.05, protein: 111.38, fat: 145.92, carbohydrates: 61.3)), sunday: TastyChef.Day(meals: [TastyChef.Meal(id: 665776, image: "Zucchini-Quiche---Almond-Flax-Crust-665776.jpg", imageType: "jpg", title: "Zucchini Quiche & Almond Flax Crust", readyInMinutes: 45, servings: 6, sourceUrl: "https://www.foodista.com/recipe/X4RDRKMQ/zucchini-quiche-almond-flax-crust"), TastyChef.Meal(id: 650377, image: "Low-Carb-Brunch-Burger-650377.jpg", imageType: "jpg", title: "Low Carb Brunch Burger", readyInMinutes: 30, servings: 2, sourceUrl: "https://www.foodista.com/recipe/5SPTY657/low-carb-brunch-burger"), TastyChef.Meal(id: 660306, image: "Slow-Cooker--Pork-and-Garbanzo-Beans-660306.jpg", imageType: "jpg", title: "Slow Cooker: Pork and Garbanzo Beans", readyInMinutes: 45, servings: 6, sourceUrl: "https://www.foodista.com/recipe/6BFKWQ7C/slow-cooker-pork-and-garbanzo-beans")], nutrients: TastyChef.Nutrient(calories: 2000.01, protein: 132.95, fat: 126.59, carbohydrates: 86.18))))
)
}
