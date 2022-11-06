//
//  Weapons.swift
//  StarWars
//
//  Created by Aleksey Rochev (Netology) on 19.11.2019.
//  Copyright © 2019 Aleksey Rochev (Netology). All rights reserved.
//

import Foundation

protocol Armed           { var  weapons: [Weapons] { get } }            // Вооружённый. Просто наличие оружия.
protocol Shooting: Armed { func fire(to coordinate: Point) throws }     // оружием, умеющим стрелять
protocol Weapons                                                        // зачем множественное число?
{
    var name:        String { get }
    var damage:      Int    { get }             // размер ущерба
    var ammunition:  Int    { get set }         // количество боеприпасов

    var distance:    Int    { get }             // дальность применения
    var misfire:     Int    { get }             // Вероятность осечки оружия. В процентах.
    var chance:      Int    { get }             // Шанс попасть. В процентах.
    var ammoPerTime: Int    { get }             // стрельба сериями по N

    mutating func fire() throws
}
// Протокол используется в: Bomb, LazerBlaster, SuperLazer


enum WeaponsError: Error {
    case isEmpty
    case misfire(misfire: Int, random: Int)
    case noBK
    case longDistance
}

extension Weapons
{
    mutating func fire() throws {                                   // проверяем можно ли стрелять

        guard
            ammunition > 0                                          // проверка наличия БК
        else {
            throw WeaponsError.isEmpty                              // может случиться при стрельбе очередями
        }
        ammunition -= 1                                             // уменьшаем БК. Если протокол реализовывать структурой, то не работает.

        let r = Int.random(in: 1...100)
        guard
            r >= misfire                                            // осечка оружия
        else {
            throw WeaponsError.misfire(misfire: misfire, random: r)
        }
    }
}
