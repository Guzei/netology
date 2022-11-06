//
//  Radar.swift
//  StarWars
//
//  Created by Aleksey Rochev (Netology) on 19.11.2019.
//  Copyright © 2019 Aleksey Rochev (Netology). All rights reserved.
//

import Foundation

protocol RadarObserver: AnyObject {                 // обзор радаром
    func detected(object: SpaceObject)              // найденный? Да он тупо стреляет сразу.
}

class Radar: SpaceObject {                          // радар. Должен иметь координаты и здоровье
    
    // typealias TimeInterval = Double // it yields sub-millisecond precision // интервал работы радара
    private enum Constants { static let timeInterval: TimeInterval = 1 }

            var coordinate: Point                   // координаты, как у любого космического объекта
            var health    : Int = 1                 // у радара мало здоровья. Формальность?

       weak var datasource: Displayable?            // Нужен делегат с методом expose(for: rect).              
       weak var observer  : RadarObserver?          // Нужен делегат с методом detected(object: SpaceObject ).
            var distance  : Distance?               // умение определять расстояние

    private let fraction  : Fraction
    private var timer     : Timer?
    private var tickCount    =  0
    private var tickCountMax = 30                   // ограничитель цикла. Можно перезаписать при инициализации.
    private var status       = false {              // при таком начальном значении первое обращение к toggle() переключит в true и запустит таймер.
        didSet {
            switch status {
            case true:  startTimer(); print("\n\nRadar \(fraction) didSet status: Start timer ==")
            case false:  stopTimer(); print("\n\nRadar \(fraction) didSet status: Stop timer ==")
            }
        }
    }

    init(coordinate: Point, fraction: Fraction) {
        self.coordinate = coordinate
        self.fraction = fraction
    }
    deinit {
        print("==Radar \(fraction) deinit: is dead")
        // toggle()                         // Вариант остановка таймера после попадания в радар.
        stopTimer()                         // Но зачем делать через посредника, когда действие требуется однозначное. Без возмжной ошибки состояния статусаа
        print("==Radar \(fraction) deinit: Stop timer ==")
    }

    // статус радара делается приватным и преключается методом. А смысл делать лишнее звено? На развитие?
    func toggle() { status = !status }   // Чуть изменил. Больше для понимания что от чего зависит. Хотя вроде и так не плохо вышло :)



    // MARK: - Lifecycle -

    // тут интересно только кого таймер будет регулярно вызывать: selector: #selector(self.sendSignal)
    private func startTimer() {
        // Creates a timer and schedules it on the current run loop in the default mode.
        timer = Timer.scheduledTimer(timeInterval: Constants.timeInterval, // ti ?  // The number of seconds between firings of the timer
                                     target: self,                                  // The object to which to send the message
                                     selector: #selector(self.sendSignal),          // The message to send to target when the timer fires.
                                     userInfo: nil,
                                     repeats: true
        )
    }
    
    private func stopTimer() {
        timer?.invalidate()                                             // Stops the timer from ever firing again and requests its removal from its run loop.
        timer = nil
    }




    @objc  // «Objective-C»

    private func sendSignal() {

        tickCount += 1
//      if tickCount++ >= tickCountMax {                                // вроде @objc указано, а любимый ++ не работает :(
        if tickCount >= tickCountMax {                                  // не нашёл сходу как таймеру указать количество циклов, поэтому по-старинке
            print("\nRadar \(fraction): ... и последняя попытка...")
            toggle()
            // gamePlay = nil                                           // не видно gamePlay. Естественно. Она же приватная.
        }

        let rect = Rect.generate()
        print("Radar \(fraction):\tСканирую космос \(rect)... \(tickCount)/\(tickCountMax)")

        // datasource возвращает всех найденных по координатам. Там могут быть как SpaceObject так и Radar
        if let objects = datasource?.expose(for: rect),                 // в квадрате rect ищем общекты. Получаем...
              !objects.isEmpty                                          // ... не пустой массив
        {
            print("\nRadar \(fraction): Ага! Попался. В количестве: \(objects.count)")// почему попался? Попались? Могут быть корабли и радары.
            for spaceObject in objects {                                // поэтому проходим циклом по всем в поисках нужного (нужных)
                print("Radar \(fraction): spaceObject:", spaceObject)
                //цикл по всем типам космических объектов простится
                if spaceObject is Radar {
                    print("Radar \(fraction): радар поймал радар. Себя или другого?" )
                    let object = spaceObject as! Radar                   // а как же иначе из-за проверки выше
                    if object.fraction == fraction {
                        print("Radar \(fraction): В своих не стреляем")
                    } else {
                        observer?.detected(object: object)               // по вражескому радару: -- Пли!
                    }
                } else if spaceObject is StarshipImp {
                    print("Radar \(fraction): попался объект типа StarshipImp. Анализируем фракцию...")
                    let object = spaceObject as! StarshipImp             // а как же иначе из-за проверки выше
                    // обнаруженный корабль пытается убежать. Телепортируется на новую точку перед выстрелом, что должно вызывать промахи.
                    
                    object.coordinate = Point.generate()
                    if object.fraction == fraction {
                        print("Radar \(fraction): В своих не стреляем")
                    } else {
                        observer?.detected(object: object)               // по вражескому кораблю: -- Пли!
                    }
                } else {
                    print("Radar \(fraction): а это кто такой?", spaceObject)
                }
            }
        }
    }
}
