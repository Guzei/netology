//
//  Space.swift
//  StarWars
//
//  Created by Aleksey Rochev (Netology) on 19.11.2019.
//  Copyright © 2019 Aleksey Rochev (Netology). All rights reserved.
//

import Foundation

// MARK: - Models

protocol Coordinating { var coordinate: Point { get set } }
protocol Vulnerable   { var     health: Int   { get set } }  // уязвимый
protocol SpaceObject : Coordinating, Distance, Vulnerable { }
protocol Distance    : AnyObject { func distance(to: CGPoint) -> Double }
protocol Displayable : AnyObject { func expose(for rect: Rect) -> [SpaceObject] }
protocol ShootHandler: AnyObject { func fire(from weapons: Weapons, to coordinate: Point) throws           }


// MARK: - Space / Космос
// Размеры космоса определяется в CoordinatSystem.swift
// Сейчас это 11*11

class Space {
    
    private var objects = [SpaceObject]() {                 // массив космических объектов у которых есть Coordinating, Vulnerable (координаты здворовье)
        didSet {
            // TODO: можно что-то сделать // после изменения массива космических объектов
            print("--space didSet-- objects:", objects)
            if objects.isEmpty {
                print("--space didSet-- objects: isEmpty)")
            }
        }
    }
    
    func add( object :  SpaceObject  )    { self.objects.append(            object )}
    func add( objects: [SpaceObject] )    { self.objects.append(contentsOf: objects)}
    func remove( with coordinate: Point ) { if let index = objects.firstIndex(where: { $0.coordinate == coordinate } ) { self.objects.remove(at: index) }}
}


// MARK: - Displayable - Отображаемый(-ые)
// отфильтровать из private var objects и вернуть массив всех объектов, чьи координаты находятся в заданом квадрате
// возваращаемый массив может быть пустой,  но не опциональный

extension Space: Displayable {

    func expose(for rect: Rect) -> [SpaceObject] {
        objects.filter { rect.contains($0.coordinate)
        }
    }
}

// MARK: - ShootHandler - обработчик стрельбы
// Анализирует попали в объект или нет
// Если у объекта закончилось здоровье, то удаляем его из собсвенного массива objects
extension Space: ShootHandler  {

    func fire(from weapon: Weapons, to coordinate: Point) throws
    {
        guard
            (1...100).contains(Int.random(in: 1...weapon.chance))      // должна срабоать вероятнось попадания
        else {
            throw StarshipError.random(weapon.chance)
        }

        guard
            var spaceObject = objects.first(where: { $0.coordinate == coordinate })     // координаты кого-то объекта и выстрела совпали. Признак попадания.
        else                                                                            // промах
        {
            // TODO: подумать не применить ли Error
            print("--space: Не попал ха-ха")
            return
        }
        spaceObject.health -= weapon.damage                                            // снижаем здоровье на величину урона оружия

        if spaceObject.health <= 0                                                      // давайдосвидания
        {
            if let radar = spaceObject as? Radar {
                // если попали в радар, то надо его деинициализировать и автоматически вызовется стоп таймер
                // radar = nil  // не вышло :( Хотя, и не очень надеялся. Этоже вторичный экземпляр. Хотя вроде и на туже память должен показывать.
                radar.toggle()  // по-простому
            }
            remove(with: spaceObject.coordinate) // удаление из массива вызывает полное удаление и деинициализацию?
            print("--space: Удалён объект", spaceObject.coordinate, "остались:", objects)
        }
    }
}

// каждый космический объект должен уметь подсчитать расстояние от себя до заданной точки.
extension SpaceObject {

    func distance(to: CGPoint) -> Double {

        return sqrt((self.coordinate.x - to.x) * (self.coordinate.x - to.x)
                  + (self.coordinate.y - to.y) * (self.coordinate.y - to.y)
                   )
    }
}
