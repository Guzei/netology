//
//  StartshipsWeapons.swift
//  StarWars
//
//  Created by Aleksey Rochev (Netology) on 19.11.2019.
//  Copyright © 2019 Aleksey Rochev (Netology). All rights reserved.
//

import Foundation


//struct SuperLazer: Weapons { // MARK: - ERROR? при стуртуре не происходит уменьшение БК. Похоже страбатывает в отдельном экземпляре структуры.

class SuperLazer: Weapons {
    var name: String = "Ultimate super lazer"
    var damage: Int = 100
    var rateOfFire: Int = 1 // скорострельность // ой, я кажется придумал тоже самое: ammoPerTime
    var ammunition: Int = 5 {
        didSet {
            print("Empire weapon:", name,
                  "Было зарядов:", oldValue,
                  "Осталось зарядов:", ammunition,
                  "Стреляем очередями за раз:", ammoPerTime,
                  "Наносим ущерб:", damage
            )
        }
    }

    // MARK: new
    var distance: Int = 5
    var misfire = 25            // шанс осечки завышеннй, чтобы видны были срабатывания осечек
    var chance = 70             // шанс попадания заниженный, чтобы видны были срабатывания промахов
    var ammoPerTime = 2
}
