//
//  StarshipsEmpire.swift
//  StarWars
//
//  Created by Aleksey Rochev (Netology) on 19.11.2019.
//  Copyright © 2019 Aleksey Rochev (Netology). All rights reserved.
//

import Foundation

class DeathStar: StarshipImp {
        
    // MARK: - Constants
    
    private enum Constants {

        static let health = 100
    }

    // MARK: - Lifecycle
    
    init(coordinate: Point) {
        
        super.init(
            name       : "Death Star",
            fraction   : .empire,
            weapons    : [SuperLazer()],  // Оружие, которое назначено звёздному кораблю Империи
            coordinate : coordinate
        )
        health = Constants.health
    }
    
    deinit {
        print("\ndeint: \(name)  ------ Люк, я твой отец! --------\n")
    }
}


// не очень понятно почему у этого корабля сразу не было такого умения.
extension DeathStar: RadarObserver {                                    // стрельба по целям, хотя из названия не ясно.

    func detected( object: SpaceObject ) {

        do {
            try fire( to: object.coordinate )                       // стреляем по координатам полученного объекта // Inherited from Shooting.fire(to:)
                                                                    // и там же вызываем обработчик попадания
                                                                    // вообще то выходит 100% попаданий. Стрельба по известным координатам. Исправим :)
        }
        catch WeaponsError.isEmpty {
            print(">>>DeathStar: Больше нет патронов!")
        }
        catch WeaponsError.misfire(let misfire, let random) {
            print(">>>DeathStar: Осечка оружия :(\t Вероятность осечки: \(misfire). Random: \(random)")
        }
        catch WeaponsError.noBK    {
            print(">>>DeathStar: Нет стреляющиего оружия с БК")
        }
        catch StarshipError.random {
            print(">>>DeathStar: Промах!")
        }
        catch                      {
            print(">>>DeathStar: Ошибка применения оружия неизвестна")
        }
    }
}

