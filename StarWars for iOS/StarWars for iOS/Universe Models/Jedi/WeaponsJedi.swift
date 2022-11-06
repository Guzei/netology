//
//  WeaponsJedi.swift
//  StarWars
//
//  Created by Aleksey Rochev (Netology) on 19.11.2019.
//  Copyright © 2019 Aleksey Rochev (Netology). All rights reserved.
//

import Foundation

// strust
class Bomb: Weapons {

    var name: String = "Bomb"
    var damage: Int = 30
    var rateOfFire: Int = 1   // ой, я кажется придумал тоже самое: ammoPerTime
    var ammunition: Int = 2 {
        didSet {
            print("Jedi weapon:", name,
                  "Было зарядов:", oldValue,
                  "Осталось зарядов:", ammunition,
                  "Стреляем очередями за раз:", ammoPerTime,
                  "Наносим ущерб:", damage
            )
        }
    }

    // MARK: new
    var distance: Int = 3
    var misfire: Int = 15               // шанс осечки завышеннй, чтобы видны были срабатывания осечек
    var chance: Int = 10                // шанс попадания заниженный, чтобы видны были срабатывания промахов
    var ammoPerTime: Int = 1
}

class LazerBlaster: Weapons {

    var name: String = "Lazer Blaster"
    var damage: Int = 20
    var rateOfFire: Int = 60   // ой, я кажется придумал тоже самое: ammoPerTime
    var ammunition: Int = 10 {
        didSet {
            print("Jedi weapon:", name,
                  "Было зарядов:", oldValue,
                  "Осталось зарядов:", ammunition,
                  "Стреляем очередями за раз:", ammoPerTime,
                  "Наносим ущерб:", damage
            )
        }
    }

    // MARK: new
    var distance: Int = 4
    var misfire = 25
    var chance = 50
    var ammoPerTime = 4
}
