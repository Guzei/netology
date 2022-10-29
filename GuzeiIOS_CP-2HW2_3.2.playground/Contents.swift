//
// Домашнее задание к занятию 3.2. Протоколы и расширения
//
// Ваше ПО
// - должно подходить для любой марки авто,
// - должно быть расширяемым и масштабируемым в дальнейшем, чтобы ваша компания могла выпускать обновления.
// Задача разделена на 4 части, в каждой из них нужно самостоятельно подумать,
// - какой тип данных передать каждому свойству для комфортной работы, а также
// - по необходимости добавить вспомогательные методы.
//
import Foundation

let line = "\n" + String(repeating: "-" as Character, count: 80) + "\n"

// MARK: - масштабируемость и масштабируемость

// не привязаны к конкретному году
//let curentYear = Calendar.current.component(.year, from: Date())

// enum не позволяет ошибиться в названии и позволяет расширять автобренды
enum CarBrands: String, CaseIterable {
    case BMW, Honda, Audi, Lexus, Volvo
}

// Палитра всех прошлых, настоящих цветов. В будущем множно добавлять новые.
enum Palette: CaseIterable {
    case red, green, blue
}

// Для аксессуаров будем использовать Set, т.к. это удобно для сравнения и дополнения.
// Задачу можно сделать веселее задав разный набор аксессуаров разным брендам и/или салонам.
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

    var brand: CarBrands { get }
    var color: Palette { get }
    var buildDate: Date { get }
    var price: UInt32 { get set } // без копеек обойдёмся
    var accessories: Set<String> { get set }
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
    func availabilityCheck(color: Palette) -> Car?
}

// MARK: - Часть 3.

// ! Используя структуры...
struct BrandCar: Car {

    var vin: UUID
    var brand: CarBrands
    var color: Palette
    var buildDate: Date
    var price: UInt32
    var accessories: Set<String>
    var isServiced: Bool = false

    mutating func buyingAccessories() {
        accessories = allAccessories // Купить всё
    }
}

// ! создайте несколько машин разных марок (например BMW, Honda, Audi, Lexus, Volvo). Все они должны реализовать протокол 'Car'.
// Создаём завод по производству автомобилей
protocol CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar
}

struct BmwFactory: CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar {
        return BrandCar(vin: UUID.init(), brand: .BMW, color: color, buildDate: Date(), price: 20_000, accessories: ["toning", "signaling", "sportsDiscs"])
    }
}
struct HondaFactory: CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar {
        return BrandCar(vin: UUID.init(), brand: .Honda, color: color, buildDate: Date(), price: 15_000, accessories: ["signaling", "sportsDiscs"])
    }
}
struct AudiFactory: CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar {
        return BrandCar(vin: UUID.init(), brand: .Audi, color: color, buildDate: Date(), price: 19_000, accessories: ["sportsDiscs"])
    }
}
struct LexusFactory: CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar {
        return BrandCar(vin: UUID.init(), brand: .Lexus, color: color, buildDate: Date(), price: 21_000, accessories: ["toning", "signaling"])
    }
}
struct VolvoFactory: CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar {
        return BrandCar(vin: UUID.init(), brand: .Volvo, color: color, buildDate: Date(), price: 21_000, accessories: ["signaling"])
    }
}

// А вот и сами заводы
let bmwFactory = BmwFactory()
let hondaFactory = HondaFactory()
let audiFactory = AudiFactory()
let lexusFactory = LexusFactory()
let volvoFactory = VolvoFactory()

// Да, трейдеры они такие. Скупают всё. Потом по салонам развезут.
struct Trader {

    var factory: CarMakingDelegate?
    var cars = [UUID : Car]()

    mutating func orderCar(facroty: CarMakingDelegate, color: Palette) {
        self.factory = facroty
        let newCar = facroty.makeCar(color: color)
        self.cars[newCar.vin] = newCar
    }
}

var trader = Trader()
// Тредер делат заказ автомобилей на разнх заводах.
for _ in 1...50 {
    if let color = Palette.allCases.randomElement() {
        trader.orderCar(facroty: bmwFactory, color: color)
    }
}
for _ in 1...20 {
    if let color = Palette.allCases.randomElement() {
        trader.orderCar(facroty: hondaFactory, color: color)
    }
}
for _ in 1...25 {
    if let color = Palette.allCases.randomElement() {
        trader.orderCar(facroty: audiFactory, color: color)
    }
}
for _ in 1...200 {
    if let color = Palette.allCases.randomElement() {
        trader.orderCar(facroty: lexusFactory, color: color)
    }
}
for _ in 1...33 {
    if let color = Palette.allCases.randomElement() {
        trader.orderCar(facroty: volvoFactory, color: color)
    }
}

trader.cars.count // 125 автомоблией сделаны


// ! Используя классы
// ! Обратите внимание! Используйте конструкцию приведения типа данных для решения этой задачи.
// а это значит от нас требуется сделать на каждый диллерский центр свой класс.
// 1. общий класс для всех
class DealershipSalon: Dealership {

    var name: CarBrands
    var showroomCapacity: UInt16 // максимальная вместимость автосалона по количеству машин
    var stockCars: [Car] = [] // машины, находящиеся на парковке склада. парковка не имеет лимита по количеству машин.
    var showroomCars: [Car] = [] // машины, находящиеся в автосалоне. Учесть лимит showroomCapacity
    var cars: [Car] = [] // хранит список всех машин в наличии
    var factory: CarMakingDelegate?
    var sellColor: Palette = .red // ну уж очень устал, чтобы делать опционал. Сорри. Это не на что не влияет, т.к. будет использоваться после продажи.

    init(name: CarBrands, showroomCapacity: UInt16) {
        self.name = name
        self.showroomCapacity = showroomCapacity
    }

    func availabilityCheck(color: Palette) -> Car? {
        return cars.first(where: {$0.color == color})
    }

    func offerAccessories(_ accessories: [String]) {
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
        print("\tНа предпродажную подготовку поступил автомобиль", car.brand, car.color)
        car.isServiced = true
        print("Предпродажная подготовка произведена")
    }

    func addToShowroom(_ car: inout Car) {
        print("\tПоступил запрос на перегон с парковки склада в автосалон автомобиля: ", car.brand, car.color)
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

    func sellCar(_ car: inout Car) {
        // если автомобиля вообще нет в салоне, то проверки сюда не попасть. Проверка перед вызовом.
        print("\tПродаём автомобиль", car.brand, car.color)
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
        self.sellColor = car.color
        showroomCars.removeAll(where: {$0.color == car.color})
        cars.removeAll(where: {$0.color == car.color})
        print("\tПродано!")

        orderCar()
    }

    func orderCar() {
        print("Салон \(name) заказывает себе новый автомобиль цвета \(sellColor)...")
        guard let newCar = factory?.makeCar(color: sellColor) else {
            print("Не удалость заказать автомобиль \(name) цвета \(sellColor) в салон")
            return
        }
        stockCars.append(newCar)
        cars.append(newCar)
        print("Автомобиль успешно заказан на заводе \(factory!)")
    }
}

// 2. классы диллерских центров по брендам
final class DealershipSalonBMW: DealershipSalon {

    let slogan = "Freude am Fahren" // С удовольствием за рулём

    init(factory: CarMakingDelegate) {
        super.init(name: .BMW, showroomCapacity: 100)
        self.factory = factory
    }
}
final class DealershipSalonHonda: DealershipSalon {

    let slogan = "자동차에서 삶의 동반자로" // Сначала человек, потом машина

    init(factory: CarMakingDelegate) {
        super.init(name: .Honda, showroomCapacity: 200)
        self.factory = factory
    }
}
final class DealershipSalonAudi: DealershipSalon {

    let slogan = "Vorsprung durch Technik" // Превосходство технологий

    init(factory: CarMakingDelegate) {
        super.init(name: .Audi, showroomCapacity: 90)
        self.factory = factory
    }
}
final class DealershipSalonLexus: DealershipSalon {

    let slogan = "Lexus. Experience Amazing."

    init(factory: CarMakingDelegate) {
        super.init(name: .Lexus, showroomCapacity: 80)
        self.factory = factory
    }
}
final class DealershipSalonVolvo: DealershipSalon {

    let slogan = "Volvo. For life"

    init(factory: CarMakingDelegate) {
        super.init(name: .Volvo, showroomCapacity: 70)
        self.factory = factory
    }
}

// ! создайте пять различных дилерских центров (например BMW, Honda, Audi, Lexus, Volvo). Все они должны реализовать протокол 'Dealership'.
// протокол реализуется через класс
var dealershipBMW   = DealershipSalonBMW(factory: bmwFactory)
var dealershipHonda = DealershipSalonHonda(factory: hondaFactory)
var dealershipAudi  = DealershipSalonAudi(factory: audiFactory)
var dealershipLexus = DealershipSalonLexus(factory: lexusFactory)
var dealershipVolvo = DealershipSalonVolvo(factory: volvoFactory)

// ! Каждому дилерскому центру добавьте машин на парковку и в автосалон (используйте те машины, которые создали ранее).
// Автосалон при получении автомобиля назначает ему стоимость и даёт от 1 до 3 аксессуара на удачу. Если случайная величина совпадёт, то будет менее трёх аксессуаров.

// Трейдер раставляет автомобили по салонам
trader.cars.forEach { (_: UUID, car: Car) in
    switch car.brand {
    case .BMW:
        dealershipBMW.cars.append(car)
        if car.color == .red  &&  dealershipBMW.showroomCars.count < dealershipBMW.showroomCapacity {
            dealershipBMW.showroomCars.append(car)
        } else {
            dealershipBMW.stockCars.append(car)
        }
    case .Honda:
        dealershipHonda.cars.append(car)
        if car.color != .red  &&  dealershipHonda.showroomCars.count < dealershipHonda.showroomCapacity {
            dealershipHonda.showroomCars.append(car)
        } else {
            dealershipHonda.stockCars.append(car)
        }
    case .Audi:
        dealershipAudi.cars.append(car)
        if dealershipAudi.showroomCars.count < dealershipAudi.showroomCapacity {
            dealershipAudi.showroomCars.append(car)
        } else {
            dealershipAudi.stockCars.append(car)
        }
    case .Lexus:
        dealershipLexus.cars.append(car)
        if dealershipLexus.showroomCars.count < dealershipLexus.showroomCapacity {
            dealershipLexus.showroomCars.append(car)
        } else {
            dealershipLexus.stockCars.append(car)
        }
    case .Volvo:
        dealershipVolvo.cars.append(car)
        if dealershipVolvo.showroomCars.count < dealershipVolvo.showroomCapacity {
            dealershipVolvo.showroomCars.append(car)
        } else {
            dealershipVolvo.stockCars.append(car)
        }
    }
}
dealershipBMW.cars // для контроля

// Пришёл покупатель за чёрным бумером, а такой цвет отсутствует в списке цветов у менеджера и даже проверок делать не надо.
// Пришёл покупатель на красную БМВ.
var color = Palette.red
var car = dealershipBMW.availabilityCheck(color: color)
if car == nil {
    print("Извините, в салоне нет машины цвета: ", color)
} else {
    dealershipBMW.sellCar(&car!)
}
print(line)
color = .blue
car = dealershipVolvo.availabilityCheck(color: color)
if car == nil {
    print("Извините, в салоне нет машины цвета: ", color)
} else {
    dealershipVolvo.sellCar(&car!)
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
//protocol SpecialOffer {
//    func addEmergencyPack() // добавляет аптечку и огнетушитель к доп. оборудованию машины.
//    func makeSpecialOffer() // проверяет дату выпуска авто, если год выпуска машины меньше текущего, нужно сделать скидку 15%, а также добавить аптеку и огнетушитель.
//}
//
//let emergencyPack: Set<String> = ["firstAidKit", "fireExtinguisher"]
//
//extension DealershipSalonBMW: SpecialOffer {
//
//    func addEmergencyPack() {
//        accessuare.uppend(emergencyPack)
//    }
//
//    func makeSpecialOffer() {
//        cars.forEach{
//            if $0.buildDate == 2021 {
//                $0.price = UInt32(Double($0.price) * 0.85)
//                addEmergencyPack()
//            }
//        }
//    }
//}
