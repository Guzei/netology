//
//  GamePlay.swift
//  StarWars
//
//  Created by Aleksey Rochev (Netology) on 19.11.2019.
//  Copyright © 2019 Aleksey Rochev (Netology). All rights reserved.
//

/*
 1. ViewController.swift
    - создаётся private var gamePlay = GamePlay() чей инициализатор и запускает игру
    - после загрузки срабатывает viewDidLoad() и стартует gamePlay.play()
 2. GamePlay.swift
    - создаём
        - private let space = Space()
        - два корабля с координатами ограниченными размером 0...10 (см. CoordinatSystem.seift). По сути это размеры космоса.
        - радар с теми же ограничениями на координаты
    - и вызываем переключатель статуса radar.toogle()
 3. Radar.swift - toogle()
    - переключает статус
    - и по didSet и запускает таймер startTimer()
 4. startTimer()
    - начинает вызывать метод sendSignal(), который генерит квадратик x*x (см. CoordinatSystem.seift) и анализирует его

 x. Чтобы закончить игру надо остановить таймер и удалить gamePlay
     Чтобы остановить таймер надо изменить статус радара: private var status котрый по didSet вызовет stopTimer()
      Чтобы измерить приватную переменную status надо вызвать метод радара: toggle()
       Это можно сделать в:
        - deinit самого радара.
        - В анализе попаданий extension Space: ShootHandler
        - при сканировании космоса в sendSignal (Radar.swift)
     Чтобы удалить экземпляр gamePlay...
      Вообще непонятно как.
      А может вообще не надо? Может быть он удаляется при закрытии окна приложения сам?
*/

import Foundation

class GamePlay {
    
    private let space = Space() // Космос. Массив космических объектов с координатами и с умениями expose() и shootHandler()

    func play() {

        print("Давным давно в далекой галактике...")

        // создаём космические корабли // StarshipImp < Shooting < Armed
        let deathStar = DeathStar(coordinate: Point.generate())
        let xWing = XWing(coordinate: Point.generate())

        // назначаем делегатов космическим кораблям
        // протокол ShootHandler требует метод обратоки стрельбы fire(from weapons: Weapons, to coordinate: Point)
        deathStar.shootHandler = space
        xWing.shootHandler = space

        // все космические корабли запускаем в космос
        space.add(objects: [deathStar, xWing])

        // печать в косоль для красоты и котроля
        print("\t\(deathStar.name) создан в точке: \(deathStar.coordinate), его shootHandler: \(String(describing: deathStar.shootHandler))")
        print("\t\(xWing.name) создан в точке: \(xWing.coordinate), его shootHandler: \(String(describing: xWing.shootHandler))")

        // Создаём радары для фракций для стрельбы по врагам
        var radars: [Fraction : Radar] = [:]
        Fraction.allCases.forEach({ fraction in
            radars[fraction] = Radar(coordinate: Point.generate(), fraction: fraction)
        })

        // назначаем делегатов радарам и стартуме их таймеры
        radars.forEach { (fraction: Fraction, radar: Radar) in
            radar.datasource = space                    // назначается для поиска (фильтрации) объектов методом expose(for: rect)
            switch fraction {
            case .empire: radar.observer = deathStar    // кто будет стралять методом detected(object: stardhip)
            case .jedi:   radar.observer = xWing        // у каждой фракции свой космический корабль
            }
            print("\tRadar \(fraction) создан в точке:", radar.coordinate)
            // поехали!
            radar.toggle()                              // Переключение статуса, а статус через didSet включает таймер.
            // startTimer()  // Хотя казалось можно и прямо сказать, что хочется. Возможно через переключатель может пригодится в будущем "на вырост".
            space.add(object: radar) // Радар в список объектов после запуска таймера. Почему? Вроде и "до" работает.
            // radar.toggle()              // короткая игра :)
        }
    }

    deinit                          // не сумел понять как удалить экземпляр этого класса.
    {
        print("Game Over")          // private var gamePlay = GamePlay(). И как получить доступ к приватной переменной, чтобы удалить её экземпляр?
    }
}

