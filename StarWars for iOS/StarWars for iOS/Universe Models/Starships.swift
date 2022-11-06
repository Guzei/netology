//
//  Starships.swift
//  StarWars
//
//  Created by Aleksey Rochev (Netology) on 19.11.2019.
//  Copyright © 2019 Aleksey Rochev (Netology). All rights reserved.
//

import Foundation

// MARK: - Starship

protocol Starship: CustomStringConvertible, SpaceObject
{
    var name    : String   { get }
    var fraction: Fraction { get }
    var canShoot: Bool     { get }
}
extension Starship { var description: String { return self.name + " \(self.fraction) fraction" }}
extension Starship where Self: Armed { // новая конструкция. Типа: только для тех, кто вооружён // протокол Armed требует наличие массива weapons
    var canShoot: Bool {
        return self.weapons.first(where: { $0.ammunition > 0 }) == nil ? false : true  // есть ли оружие с боезапасом
    }
}

enum StarshipError: Error {
    case random(_ chance: Int) // промазал. Сам кривой или корабль улетел?
}

// MARK: - Starship Base - StarshipImp

class StarshipImp: Starship, Shooting { // объект с координатами, здоровьем и умеющим стрелять оружием.
    
    private(set) var name        = ""
    private(set) var fraction    = Fraction.empire
    private(set) var weapons     : [Weapons]
                 var coordinate  : Point
                 var health      : Int = 0 {didSet{ if oldValue > health {print("\n>>ssi: Ай, больно же! Осталось здоровья:", self.health)}} }
            weak var shootHandler: ShootHandler?


    // MARK: - Lifecycle
    
    init(name      : String,
         fraction  : Fraction,
         weapons   : [Weapons],
         coordinate: Point
    ) {
        self.name       = name
        self.fraction   = fraction
        self.weapons    = weapons
        self.coordinate = coordinate
    }
        
    // MARK: - Properties
    // протокол Shooting требует наличие умения стрелять
    
    func fire(to coordinate: Point) throws                              // Inherited from Shooting.fire(to:)
    {
        guard
            canShoot,                                                   // в расширении протокола проверяем есть ли оружие с боезапасом
            var weapon = weapons.first(where: { $0.ammunition > 0 } )   // и тем же самым кодом ищем это оружие
        else
        {
            throw WeaponsError.noBK
        }

        print(">>ssi: Выбрано оружие: \(weapon)")

        guard Double(weapon.distance) >= distance(to: coordinate)       // радиус применения достатоный
        else {
            throw WeaponsError.longDistance
        }


        for _ in 1...weapon.ammoPerTime {                               // стрельба очередями
            try weapon.fire()                                           // проверка возможности стрелять (не закончилился ли БК и нет ли осечки)
            try shootHandler?.fire(from: weapon, to: coordinate)        // Контроль попадания, если у космического корабля империи есть обработчик стрельбы
        }
    }
}
