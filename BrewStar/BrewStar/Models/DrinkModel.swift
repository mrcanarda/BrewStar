//
//  DrinkModel.swift
//  BrewStar
//
//  Created by Can Arda on 24.02.26.
//

import Foundation

// MARK: - Category
enum DrinkCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case hotCoffee = "Hot Coffee"
    case coldBrew = "Cold Brew"
    case frappuccino = "Frappuccino"
    case tea = "Tea"
    case seasonal = "Seasonal"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2.fill"
        case .hotCoffee: return "cup.and.saucer.fill"
        case .coldBrew: return "thermometer.snowflake"
        case .frappuccino: return "snow"
        case .tea: return "leaf.fill"
        case .seasonal: return "snowflake"
        }
    }
    
    var cardIcon: String {
        switch self {
        case .all: return "cup.and.saucer.fill"
        case .hotCoffee: return "cup.and.saucer.fill"
        case .coldBrew: return "takeoutbag.and.cup.and.straw.fill"
        case .frappuccino: return "snowflake"
        case .tea: return "leaf.fill"
        case .seasonal: return "snowflake"
        }
    }
}

// MARK: - Drink
struct Drink: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let price: Double
    let imageName: String
    let category: String
    let calories: Int
    let starPoints: Int
    
    var drinkCategory: DrinkCategory {
        DrinkCategory(rawValue: category) ?? .all
    }
    
    var formattedPrice: String {
        String(format: "€%.2f", price)
    }
    
    // Her içeceğe özel SF Symbol ikonu
    var sfSymbol: String {
        switch name {
        case "Caramel Macchiato": return "cup.and.saucer.fill"
        case "Espresso": return "cup.and.saucer.fill"
        case "Vanilla Latte": return "cup.and.saucer.fill"
        case "Flat White": return "cup.and.saucer.fill"
        case "Cappuccino": return "smoke.fill"
        case "Americano": return "mug.fill"
        case "Cold Brew": return "takeoutbag.and.cup.and.straw.fill"
        case "Salted Caramel Cold Brew": return "takeoutbag.and.cup.and.straw.fill"
        case "Vanilla Sweet Cream Cold Brew": return "takeoutbag.and.cup.and.straw.fill"
        case "Mocha Frappuccino": return "snowflake"
        case "Caramel Frappuccino": return "snowflake"
        case "Java Chip Frappuccino": return "snowflake"
        case "Strawberry Frappuccino": return "heart.fill"
        case "Matcha Latte": return "leaf.fill"
        case "Green Tea Lemonade": return "drop.fill"
        case "Chai Latte": return "flame.fill"
        case "Passion Tango Tea": return "flame.fill"
        case "Pumpkin Spice Latte": return "laurel.leading"
        case "Peppermint Mocha": return "snowflake"
        case "Eggnog Latte": return "star.fill"
        default: return "cup.and.saucer.fill"
        }
    }
}

// MARK: - Sample Data
// MARK: - Sample Data
extension Drink {
    static let sampleDrinks: [Drink] = [
        
        // MARK: Hot Coffee
        Drink(id: UUID(), name: "Caramel Macchiato", description: "Velvety smooth espresso with vanilla-flavored syrup, steamed milk and caramel drizzle.", price: 5.45, imageName: "https://images.unsplash.com/photo-1593443320739-77f74939d0da?w=400&q=80", category: DrinkCategory.hotCoffee.rawValue, calories: 250, starPoints: 55),
        Drink(id: UUID(), name: "Espresso", description: "Our dark, rich espresso balanced with steamed milk and a light layer of foam.", price: 3.45, imageName: "https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=400&q=80", category: DrinkCategory.hotCoffee.rawValue, calories: 10, starPoints: 35),
        Drink(id: UUID(), name: "Vanilla Latte", description: "Our signature espresso balanced with steamed milk and vanilla syrup.", price: 4.75, imageName: "https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400&q=80", category: DrinkCategory.hotCoffee.rawValue, calories: 190, starPoints: 48),
        Drink(id: UUID(), name: "Flat White", description: "Velvety microfoam poured over a double ristretto shot.", price: 4.55, imageName: "https://images.unsplash.com/photo-1577968897966-3d4325b36b61?w=400&q=80", category: DrinkCategory.hotCoffee.rawValue, calories: 120, starPoints: 46),
        Drink(id: UUID(), name: "Cappuccino", description: "Rich espresso with thick, creamy foam on top.", price: 4.25, imageName: "https://images.unsplash.com/photo-1534778101976-62847782c213?w=400&q=80", category: DrinkCategory.hotCoffee.rawValue, calories: 140, starPoints: 43),
        Drink(id: UUID(), name: "Americano", description: "Espresso shots topped with hot water for a rich, full-bodied drink.", price: 3.75, imageName: "https://images.unsplash.com/photo-1551030173-122aabc4489c?w=400&q=80", category: DrinkCategory.hotCoffee.rawValue, calories: 15, starPoints: 38),
        
        // MARK: Cold Brew
        Drink(id: UUID(), name: "Cold Brew", description: "Smooth, small-batch cold brew coffee sweetened with a touch of vanilla.", price: 4.95, imageName: "https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400&q=80", category: DrinkCategory.coldBrew.rawValue, calories: 15, starPoints: 50),
        Drink(id: UUID(), name: "Salted Caramel Cold Brew", description: "Cold brew topped with a salted caramel cream cold foam.", price: 5.45, imageName: "https://images.unsplash.com/photo-1568649929103-28ffbefaca1e?w=400&q=80", category: DrinkCategory.coldBrew.rawValue, calories: 230, starPoints: 55),
        Drink(id: UUID(), name: "Vanilla Sweet Cream Cold Brew", description: "Cold brew with vanilla sweet cream slowly cascading.", price: 5.25, imageName: "https://images.unsplash.com/photo-1587080413959-06b859fb107d?w=400&q=80", category: DrinkCategory.coldBrew.rawValue, calories: 200, starPoints: 53),
        
        // MARK: Frappuccino
        Drink(id: UUID(), name: "Mocha Frappuccino", description: "Coffee and milk are blended with ice and mocha sauce for a rich, chocolatey drink.", price: 5.95, imageName: "https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400&q=80", category: DrinkCategory.frappuccino.rawValue, calories: 420, starPoints: 60),
        Drink(id: UUID(), name: "Caramel Frappuccino", description: "Caramel syrup meets coffee, milk and ice for a delightfully sweet drink.", price: 5.75, imageName: "https://images.unsplash.com/photo-1579954115545-a95591f28bfc?w=400&q=80", category: DrinkCategory.frappuccino.rawValue, calories: 380, starPoints: 58),
        Drink(id: UUID(), name: "Java Chip Frappuccino", description: "Mocha sauce and Frappuccino chips blended with coffee.", price: 6.25, imageName: "https://images.unsplash.com/photo-1553361371-9b22f78e8b1d?w=400&q=80", category: DrinkCategory.frappuccino.rawValue, calories: 470, starPoints: 63),
        Drink(id: UUID(), name: "Strawberry Frappuccino", description: "Blend of ice, milk and strawberry puree topped with whip.", price: 5.95, imageName: "https://images.unsplash.com/photo-1553361371-9b22f78e8b1d?w=400&q=80", category: DrinkCategory.frappuccino.rawValue, calories: 380, starPoints: 60),
        
        // MARK: Tea
        Drink(id: UUID(), name: "Matcha Latte", description: "Smooth and creamy matcha sweetened just right and served with steamed milk.", price: 5.25, imageName: "https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=400&q=80", category: DrinkCategory.tea.rawValue, calories: 200, starPoints: 52),
        Drink(id: UUID(), name: "Green Tea Lemonade", description: "Matcha green tea shaken with real lemonade and ice.", price: 4.45, imageName: "https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400&q=80", category: DrinkCategory.tea.rawValue, calories: 130, starPoints: 45),
        Drink(id: UUID(), name: "Chai Latte", description: "Black tea infused with cinnamon, clove and spices with steamed milk.", price: 4.95, imageName: "https://images.unsplash.com/photo-1609743522653-52354461eb27?w=400&q=80", category: DrinkCategory.tea.rawValue, calories: 240, starPoints: 50),
        Drink(id: UUID(), name: "Passion Tango Tea", description: "Hibiscus, lemongrass and apple shaken with ice.", price: 4.25, imageName: "https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400&q=80", category: DrinkCategory.tea.rawValue, calories: 45, starPoints: 43),
        
        // MARK: Seasonal
        Drink(id: UUID(), name: "Pumpkin Spice Latte", description: "Espresso with pumpkin pie flavors, cinnamon and nutmeg.", price: 5.75, imageName: "https://images.unsplash.com/photo-1534778101976-62847782c213?w=400&q=80", category: DrinkCategory.seasonal.rawValue, calories: 380, starPoints: 58),
        Drink(id: UUID(), name: "Peppermint Mocha", description: "Espresso with chocolate and peppermint flavors topped with whip.", price: 5.95, imageName: "https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400&q=80", category: DrinkCategory.seasonal.rawValue, calories: 440, starPoints: 60),
        Drink(id: UUID(), name: "Eggnog Latte", description: "Espresso combined with eggnog and steamed milk.", price: 5.45, imageName: "https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400&q=80", category: DrinkCategory.seasonal.rawValue, calories: 460, starPoints: 55),
    ]
}
