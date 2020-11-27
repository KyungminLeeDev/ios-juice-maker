//
//  JuiceMaker - JuiceMaker.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import Foundation

enum JuiceMakerError: Error {
    case lowStock
    case noRecipe
}

// 쥬스 제작 역할만
// - 쥬스종류에 따라 제작
class JuiceMaker {
    // 과일창고와 레시피는 변경할 수 있도록 var로 선언
    private var fruitStorage: FruitStorage
    private var juiceRecipes: JuiceRecipes
    
    init(fruitStorage: FruitStorage, juiceRecipes: JuiceRecipes) {
        self.fruitStorage = fruitStorage
        self.juiceRecipes = juiceRecipes
    }
    
    private func isEnoughStock(of juiceRecipe: JuiceRecipe) -> Bool {
        for (fruit, count) in juiceRecipe.needFruits {
            let currentCount = fruitStorage.countStock(of: fruit)

            guard currentCount >= count else {
                return false
            }
        }
        
        return true
    }
    
    private func consumeStock(of juiceRecipe: JuiceRecipe) -> Bool {
        for (fruit, count) in juiceRecipe.needFruits {
            guard fruitStorage.subtractStock(of: fruit, count: count) else {
                return false
            }
        }
        
        return true
    }
        
    func make(juice: Juice) throws {
        guard let recipe = juiceRecipes.recipe(of: juice) else {
            throw JuiceMakerError.noRecipe
        }
        
        guard isEnoughStock(of: recipe) else {
            throw JuiceMakerError.lowStock
        }

        guard consumeStock(of: recipe) else {
            throw JuiceMakerError.lowStock
        }
    }
}
