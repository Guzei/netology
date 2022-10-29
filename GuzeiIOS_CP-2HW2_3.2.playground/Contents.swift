/*
 Домашнее задание к занятию 3.2. Протоколы и расширения

 Задача 1 (основная)

 ВЫ - главный архитектор в команде разработчиков. Ваша задача - разработать программное обеспечение (ПО) для дилерских центров по продаже автомобилей. Ваша цель - создать гибкое ПО. Что это значит?
 Ваше ПО
 - должно подходить для любой марки авто,
 - должно быть расширяемым и масштабируемым в дальнейшем, чтобы ваша компания могла выпускать обновления.
 Задача разделена на 4 части, в каждой из них нужно самостоятельно подумать,
 - какой тип данных передать каждому свойству для комфортной работы, а также
 - по необходимости добавить вспомогательные методы.
*/
//import Foundation

let line = "\n" + String(repeating: "-" as Character, count: 80) + "\n"

// MARK: - масштабируемость
// Расширение марок продаваемых автомобилей и их диллерских центров здесь.
enum CarBrands: String, CaseIterable {
    case BMW, Honda, Audi, Lexus, Volvo
}

// Новые модные цвета автомобилей надо добавлять сюда
enum Colors: CaseIterable {
    case red, green, blue
}

// Новые акксесуары тоже добавлять легко
// Задачу можно сделать веселее задав разный набор аксессуаров разным брендам или салонам.
let allAccessories: Set<String> = ["toning", "signaling", "sportsDiscs", "firstAidKit", "fireExtinguisher"]


// MARK: - Часть 1.
/*
 Создайте протокол 'Car'
 Добавьте в него свойства:
 'model' (только для чтения): марка
 'color' (только для чтения): цвет
 'buildDate' (только для чтения): дата выпуска
 'price' (чтение и запись): цена авто
 'accessories' (чтение и запись): дополнительное оборудование (тонировка, сингнализация, спортивные диски)
 'isServiced' (чтение и запись): сделана ли предпродажная подготовка. Обычно ее делают в дилерских центрах перед постановкой машины в салон.
*/
protocol Car {

    var model: CarBrands { get } // такой тип сокращает вероятность ошибки в соответствующем названии салона
    var color: Colors { get } // у маших всегда ограниченный набор цветов
    var buildDate: UInt16 { get } // нужен только год
    var price: UInt32 { get set } // без копеек обойдёмся
    var accessories: Set<String> { get set } // множество удобнее сравнивать и вычиать. Потом пригодится.
    var isServiced: Bool { get set }

    mutating func buyingAccessories()
}

// MARK: - Часть 2.
/*

 По аналогии с протоколом 'Car', нужно описать дилерский центр минимальным набором свойств и методов, используя протокол.

 Алгоритм выполнения

 Создайте протокол 'Dealership'
 Добавьте свойства:
 'name' (только для чтения): название дилерского центра (назвать по марке машины для упрощения)
 'showroomCapacity' (только для чтения): максимальная вместимость автосалона по количеству машин.
 'stockCars' (массив, чтение и запись): машины, находящиеся на парковке склада. Представим, что парковка не имеет лимита по количеству машин.
 'showroomCars' (массив, чтение и запись): машины, находящиеся в автосалоне.
 'cars' (массив, чтение и запись): хранит список всех машин в наличии.

 Добавьте методы:
 'offerAccesories(_ :)': принимает массив акксесуаров в качестве параметра. Метод предлагает клиенту купить доп. оборудование.
 'presaleService(_ :)': принимает машину в качестве параметра. Метод отправляет машину на предпродажную подготовку.
 'addToShowroom(_ :)': также принимает машину в качестве параметра. Метод перегоняет машину с парковки склада в автосалон, при этом выполняет предпродажную подготовку.
 'sellCar(_ :)': также принимает машину в качестве параметра. Метод продает машину из автосалона при этом проверяет, выполнена ли предпродажная подготовка. Также, если у машины отсутсвует доп. оборудование, нужно предложить клиенту его купить. (давайте представим, что клиент всегда соглашается и покупает :) )
 'orderCar()': не принимает и не возвращает параметры. Метод делает заказ новой машины с завода, т.е. добавляет машину на парковку склада.

 Обратите внимание! Каждый метод должен выводить в консоль информацию о машине и выполненном действии с ней.
*/
protocol Dealership {

    var name: CarBrands { get } // Название по марке машины сразу и слоган подтягивает
    var showroomCapacity: UInt16 { get } // 65_535
    var stockCars: [Car] { get set } // машины, находящиеся на парковке склада. парковка не имеет лимита по количеству машин.
    var showroomCars: [Car] { get set } // машины, находящиеся в автосалоне. Надо ли учесть лимит showroomCapacity?
    var cars: [Car] { get set } // хранит список всех машин в наличии

    func offerAccessories(_ : [String]) // как жаль, что массив тут жёстко определён условием задачи. Лучше бы сразу Set.
    func presaleService(_ : inout Car) // принимает машину в качестве параметра. Метод отправляет машину на предпродажную подготовку.
    func addToShowroom(_ : inout Car) // принимает машину в качестве параметра. Метод перегоняет машину с парковки склада в автосалон, при этом выполняет предпродажную подготовку.
    func sellCar(_ : inout Car) // принимает машину в качестве параметра. Метод продает машину из автосалона при этом проверяет, выполнена ли предпродажная подготовка. Также, если у машины отсутсвует доп. оборудование, нужно предложить клиенту его купить. (давайте представим, что клиент всегда соглашается и покупает :) )
    func orderCar() // не принимает и не возвращает параметры. Метод делает заказ новой машины с завода, т.е. добавляет машину на парковку склада.
    // вспомогательные методы
    func availabilityCheck(color: Colors) -> Car?
}

// MARK: - Часть 3.

// ! Используя структуры...
struct BrendCar: Car {

    var model: CarBrands
    var color: Colors
    var buildDate: UInt16
    var price: UInt32 = 0
    var accessories: Set<String> = []
    var isServiced: Bool = false

    mutating func buyingAccessories() {
        // и это вариант проще некуда. Опять же благодаря выбранному типу непозволяющему дубли. Выборочная покупка чуть усложнила бы.
        accessories = allAccessories
    }
}

// ! создайте несколько машин разных марок (например BMW, Honda, Audi, Lexus, Volvo). Все они должны реализовать протокол 'Car'.
// Создаём завод по производству автомобилей
// С завода атомоблии выходят без предпродажной, без цены и без аксессуаров. Это дело диллеров.
var Cars = [Car]()
for model in CarBrands.allCases {
    for color in Colors.allCases {
        let year = UInt16.random(in: 2021...2022) // странный, конечно, завод, который производит прошлогодние машины :)
        Cars.append(BrendCar(model: model, color: color, buildDate: year ))
    }
}

// ! Используя классы
// ! Обратите внимание! Используйте конструкцию приведения типа данных для решения этой задачи.
// а это значит от нас требуется сделать на каждый диллерский центр свой класс.
// общий класс для всех
class DealershipSalon: Dealership {

    var name: CarBrands
    var showroomCapacity: UInt16 // максимальная вместимость автосалона по количеству машин
    var stockCars: [Car] = [] // машины, находящиеся на парковке склада. парковка не имеет лимита по количеству машин.
    var showroomCars: [Car] = [] // машины, находящиеся в автосалоне. Учесть лимит showroomCapacity
    var cars: [Car] = [] // хранит список всех машин в наличии

    init(name: CarBrands, showroomCapacity: UInt16) {
        self.name = name
        self.showroomCapacity = showroomCapacity
    }

    func availabilityCheck(color: Colors) -> Car? {
        // ищем машину в салоне
        return cars.first(where: {$0.color == color})
    }

    func offerAccessories(_ accessories: [String]) {
        //print("in acc: ",accessories)
        guard !accessories.isEmpty else {
            print("Задайте список возможных аксессуаров")
            return
        }
        let requestedAccessories = Set(accessories)
        let defunctAccessories = requestedAccessories.subtracting(allAccessories) // вычетание
        if defunctAccessories.count > 0 {
            print("\tЭтих аксессуаров несуществует:")
            defunctAccessories.map{ print("- ",$0) }
        }
        var selectedAccessories = requestedAccessories.intersection(allAccessories) // Пересечение
        if selectedAccessories.count > 0 {
            print("\tПредалагаем купить следующие аксессары:")
            selectedAccessories.forEach{ print("- ", $0) }
        } else {
            print("Не задано ни одного существующего аксессуара")
        }
    }

    func presaleService(_ car: inout Car) {
        guard !car.isServiced else {
            print("Предпродажная подготовка не требуется")
            return
        }
        print("\tНа предпродажную подготовку поступил автомобиль", car.model, car.color)
        car.isServiced = true
        print("Предпродажная подготовка произведена")
    }

    func addToShowroom(_ car: inout Car) {
        print("\tПоступил запрос на перегон с парковки склада в автосалон автомобиля: ", car.model, car.color)
        // в нашем случае цвет как ID. Без ID автомобиля вообще не выйдет работать с двумя одинаковыми автомобилями отличающимися только по VIN.
        guard stockCars.contains(where: {$0.color == car.color}) else {
            print("На парковке салона такого автомобиля нет")
            return
        }
        showroomCars.append(car)
        stockCars.removeAll(where: {$0.color == car.color})
        print("Автомобиль переставлен в салон")

        presaleService(&car)
    }

    //Метод продает машину из автосалона при этом проверяет, выполнена ли предпродажная подготовка. Также, если у машины отсутсвует доп. оборудование, нужно предложить клиенту его купить. (давайте представим, что клиент всегда соглашается и покупает :) )
    func sellCar(_ car: inout Car) {
        // если автомобиля вообще нет в салоне, то проверки сюда не попасть. Проверка перед вызовом.
        print("\tПродаём автомобиль", car.model, car.color)
        if showroomCars.first(where: {$0.color == car.color}) == nil {
            print("Машины в салне нет. Забираем её со стоянки.") // вариант, что машина в салоне есть, а её нет ни салоне, ни на парковке не должен случаться вообще.
            if showroomCars.count >= showroomCapacity {
                print("Салон переполнен! Перегоняем первую машину из салона на парковку")
                stockCars.append(showroomCars.removeFirst())
            }
            addToShowroom(&car)
        }
        // теперь автомобиль точно есть в салоне

        // по условию задачи проверяем предпродажную подготовку, хотя как машина пападёт в салон без неё?
        presaleService(&car)

        // формируем список нехватающих допов // allAccessories vs. car.accessories
        let carAccessories = Set(car.accessories) // Если допов не было изначально, то пустое множество -- не проблема.
        let newAccessories = allAccessories.subtracting(Set(car.accessories)) // это причина выбора множества.
        if newAccessories.count > 0 {

            offerAccessories(Array(newAccessories)) // гоняем Set - Array только из-за жёских условий задачи. Хотелось бы только на Сетах всё сделать.

            // покупаем все предложенное
            car.buyingAccessories()
        } else {
            print("Аксессуаров уже под завязку. Больше ничего предложить не можем.")
        }

        // удаяем машину из салона (на стоянке её ведь быть уже не может) и из общего списка
        showroomCars.removeAll(where: {$0.color == car.color})
        cars.removeAll(where: {$0.color == car.color})
        print("\tПродано!")
    }

    // Метод делает заказ новой машины с завода, т.е. добавляет машину на парковку склада.
    func orderCar() {
//        var car = BrendCar(model: <#T##CarBrands#>, color: <#T##Colors#>, buildDate: <#T##UInt16#>)
//        делегирование?
//        stockCars.append(<#T##newElement: Car##Car#>)
//        cars.append(<#T##newElement: Car##Car#>)
    }
}

// Расширение марок продаваемых автомобилей и их диллерских центров здесь.
final class DealershipSalonBMW: DealershipSalon {

    let slogan = "Freude am Fahren" // С удовольствием за рулём

    init() {
        super.init(name: .BMW, showroomCapacity: 100)
    }
}
final class DealershipSalonHonda: DealershipSalon {

    let slogan = "자동차에서 삶의 동반자로" // Сначала человек, потом машина

    init() {
        super.init(name: .Honda, showroomCapacity: 200)
    }
}
final class DealershipSalonAudi: DealershipSalon {

    let slogan = "Vorsprung durch Technik" // Превосходство технологий

    init() {
        super.init(name: .Audi, showroomCapacity: 90)
    }
}
final class DealershipSalonLexus: DealershipSalon {

    let slogan = "Lexus. Experience Amazing."

    init() {
        super.init(name: .Lexus, showroomCapacity: 80)
    }
}
final class DealershipSalonVolvo: DealershipSalon {

    let slogan = "Volvo. For life"

    init() {
        super.init(name: .Volvo, showroomCapacity: 70)
    }
}

Cars // автомобили различных марок, цветов и дат производства готовы. Они едут в свои салоны.
// ! создайте пять различных дилерских центров (например BMW, Honda, Audi, Lexus, Volvo). Все они должны реализовать протокол 'Dealership'.
// протокол реализуется через класс
var dealershipBMW   = DealershipSalonBMW()
var dealershipHonda = DealershipSalonHonda()
var dealershipAudi  = DealershipSalonAudi()
var dealershipLexus = DealershipSalonLexus()
var dealershipVolvo = DealershipSalonVolvo()

// ! Каждому дилерскому центру добавьте машин на парковку и в автосалон (используйте те машины, которые создали ранее).
// Автосалон при получении автомобиля назначает ему стоимость и даёт от 1 до 3 аксессуара на удачу. Если случайная величина совпадёт, то будет менее трёх аксессуаров.

for var car in Cars {
//    print(car)
    switch car.model {
    case .BMW:
        car.price = 20_000
        car.accessories = [allAccessories.randomElement()!, allAccessories.randomElement()!, allAccessories.randomElement()!]
        dealershipBMW.stockCars.append(car)
        dealershipBMW.cars.append(car)
    case .Honda:
        car.price = 10_000
        car.accessories = [allAccessories.randomElement()!, allAccessories.randomElement()!, allAccessories.randomElement()!]
        dealershipHonda.stockCars.append(car)
        dealershipHonda.cars.append(car)
    case .Audi:
        car.price = 19_000
        car.accessories = [allAccessories.randomElement()!, allAccessories.randomElement()!, allAccessories.randomElement()!]
        dealershipAudi.stockCars.append(car)
        dealershipAudi.cars.append(car)
    case .Lexus:
        car.price = 21_000
        car.accessories = [allAccessories.randomElement()!, allAccessories.randomElement()!, allAccessories.randomElement()!]
        dealershipLexus.stockCars.append(car)
        dealershipLexus.cars.append(car)
    case .Volvo:
        car.price = 18_000
        car.accessories = [allAccessories.randomElement()!, allAccessories.randomElement()!, allAccessories.randomElement()!]
        dealershipVolvo.stockCars.append(car)
        dealershipVolvo.cars.append(car)
    }
}
// теперь на парковке каждого салона по три машины с ценой и аксессуарами, но по-прежнему без предпродажной подготовки
//DealershipBMW.cars.forEach{print($0.accessories)} // для контроля

// Пришёл покупатель за чёрным бумером, а такой цвет отсутствует в списке цветов у менеджера и даже проверок делать не надо.
// Пришёл покупатель на красную БМВ.
var color = Colors.red
var car = dealershipBMW.availabilityCheck(color: color)
if car == nil {
    print("Извините, в салоне нет машины цвета: ", color)
} else {
    dealershipBMW.sellCar(&car!)
}

// ! Создайте массив, положите в него созданные дилерские центры.
var Dealerships = [Dealership]()
Dealerships = [dealershipBMW, dealershipHonda, dealershipAudi, dealershipLexus, dealershipVolvo]

// ! Пройдитесь по нему циклом и выведите в консоль слоган для каждого дилеского центра (слоган можно загуглить).
// ! Обратите внимание! Используйте конструкцию приведения типа данных для решения этой задачи.
// Dealerships[0].slogan -- у суперкласса нет слогана, поэтому идём на ступень ниже:
print("\n", line, "Слоганы автосалонов:")
Dealerships.forEach {
    if let car = $0 as? DealershipSalonBMW {
        print($0.name, "-", car.slogan)
    } else if let car = $0 as? DealershipSalonHonda {
        print($0.name, "-", car.slogan)
    } else if let car = $0 as? DealershipSalonAudi {
        print($0.name, "-", car.slogan)
    } else if let car = $0 as? DealershipSalonLexus {
        print($0.name, "-", car.slogan)
    } else if let car = $0 as? DealershipSalonVolvo {
        print($0.name, "-", car.slogan)
    }
}

// MARK: - Часть 4.
/*
 Работа с расширениями. Нам нужно добавить спецпредложение для "прошлогодних" машин.

 Алгоритм выполнения

 Создайте протокол SpecialOffer.
 Добавьте методы:
 - 'addEmergencyPack()': не принимает никаких параметров. Метод добавляет аптечку и огнетушитель к доп. оборудованию машины.
 - 'makeSpecialOffer()': не принимает никаких параметров. Метод проверяет дату выпуска авто, если год выпуска машины меньше текущего, нужно сделать скидку 15%, а также добавить аптеку и огнетушитель.

 Используя расширение, реализуйте протокол 'SpecialOffer' для любых трех дилерских центров.
 Проверьте все машины в дилерском центре (склад + автосалон), возможно они нуждаются в специальном предложении. Если есть машины со скидкой на складе, нужно перегнать их в автосалон.
 */
protocol SpecialOffer {
    func addEmergencyPack() // добавляет аптечку и огнетушитель к доп. оборудованию машины.
    func makeSpecialOffer() // проверяет дату выпуска авто, если год выпуска машины меньше текущего, нужно сделать скидку 15%, а также добавить аптеку и огнетушитель.
}

let accessoriesForOls: Set<String> = ["firstAidKit", "fireExtinguisher"]

extension DealershipSalonBMW: SpecialOffer {

    func addEmergencyPack() {
        
    }

    func makeSpecialOffer() {

    }
}
