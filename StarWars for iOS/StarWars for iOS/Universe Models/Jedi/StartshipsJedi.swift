//
//  StartshipsJedi.swift
//  StarWars
//
//  Created by Aleksey Rochev (Netology) on 19.11.2019.
//  Copyright © 2019 Aleksey Rochev (Netology). All rights reserved.
//

import Foundation

class XWing: StarshipImp {                                          // https://ru.wikipedia.org/wiki/X-wing

    // MARK: - Constants

    private enum Constants {

        static let health = 100
    }

    // MARK: - Lifecycle

    init(coordinate: Point) {

        super.init(
            name      : "X Wing",
            fraction  : .jedi,
            weapons   : [Bomb(), LazerBlaster()],
            coordinate: coordinate
        )
        health = Constants.health
    }

    deinit {
        print("deint: \(name), ты должен был бороться со злом...")
    }
}



extension XWing: RadarObserver {                                    // стрельба по целям, хотя из названия не ясно.

    func detected( object: SpaceObject ) {

        do {
            try fire( to: object.coordinate )                       // стреляем по координатам полученного объекта // Inherited from Shooting.fire(to:)
                                                                    // и там же вызываем обработчик попадания
                                                                    // вообще то выходит 100% попаданий. Стрельба по известным координатам. Исправим :)
        }
        catch WeaponsError.isEmpty {
            print("<<XWing: Больше нет патронов!")
        }
        catch WeaponsError.misfire(let misfire, let random) {
            print("<<XWing: Осечка оружия :(\t Вероятность осечки: \(misfire). Random: \(random)")
        }
        catch WeaponsError.noBK    {
            print("<<XWing: Нет стреляющиего оружия с БК")
        }
        catch StarshipError.random {
            print("<<XWing: Промах!")
        }
        catch                      {
            print("<<XWing: Ошибка применения оружия неизвестна")
        }
    }
}
