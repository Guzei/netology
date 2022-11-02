import Foundation

let line = "\n" + String(repeating: "-" as Character, count: 80) + "\n"

enum CarBrands: String, CaseIterable { case BMW, Honda, Audi, Lexus, Volvo }
enum Palette:   CaseIterable         { case red, green, blue }

let allAccessories: Set<String> = ["toning", "signaling", "sportsDiscs", "firstAidKit", "fireExtinguisher"]
let countCarsInFactory: [CarBrands : UInt32] = [.BMW : 8, .Honda : 2, .Audi : 3, .Lexus : 3, .Volvo: 7]

protocol Car {

    var vin: UUID { get }
    var model: CarBrands { get }
    var color: Palette { get }
    var buildDate: Date { get }
    var price: UInt32 { get set }
    var accessories: Set<String> { get set }
    var isServiced: Bool { get set }

    mutating func buyingAccessories()
}

protocol Dealership {

    var name: CarBrands { get }
    var showroomCapacity: UInt16 { get }
    var stockCars: [Car] { get set }
    var showroomCars: [Car] { get set }
    var cars: [Car] { get set }

    func offerAccessories(_ : [String])
    func presaleService(_ : inout Car)
    func addToShowroom(_ : inout Car)
    func sellCar(_ : inout Car)
    func orderCar()
}

struct BrandCar: Car {

    var vin: UUID
    var model: CarBrands
    var color: Palette
    var buildDate: Date
    var price: UInt32 {
        // срабатывает когда цена меняется в общем массиве и в дополнительном массиве. Всегда два раза.
        didSet {
            print("Цена изменилась. Было: \(oldValue), стало: \(price)")
        }
    }
    var accessories: Set<String>
    var isServiced: Bool = false

    mutating func buyingAccessories() {
         accessories = allAccessories
    }
}

protocol CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar
}

struct BmwFactory: CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar {
        var date = Calendar.current.date(byAdding: .year, value: Int.random(in: -1...0), to: Date())!
        return BrandCar(vin: UUID.init(), model: .BMW, color: color, buildDate: date, price: 20_000, accessories: ["toning", "signaling", "sportsDiscs"])
    }
}
struct HondaFactory: CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar {
        var date = Calendar.current.date(byAdding: .year, value: Int.random(in: -1...0), to: Date())!
        return BrandCar(vin: UUID.init(), model: .Honda, color: color, buildDate: date, price: 15_000, accessories: ["signaling", "sportsDiscs"])
    }
}
struct AudiFactory: CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar {
        return BrandCar(vin: UUID.init(), model: .Audi, color: color, buildDate: Date(), price: 19_000, accessories: ["sportsDiscs"])
    }
}
struct LexusFactory: CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar {
        return BrandCar(vin: UUID.init(), model: .Lexus, color: color, buildDate: Date(), price: 21_000, accessories: ["toning", "signaling"])
    }
}
struct VolvoFactory: CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar {
        return BrandCar(vin: UUID.init(), model: .Volvo, color: color, buildDate: Date(), price: 21_000, accessories: ["signaling"])
    }
}

var factories: [CarBrands : CarMakingDelegate] = [.BMW   : BmwFactory(),
                                                  .Honda : HondaFactory(),
                                                  .Audi  : AudiFactory(),
                                                  .Lexus : LexusFactory(),
                                                  .Volvo : VolvoFactory()]

struct Trader {

    var factory: CarMakingDelegate?
    var cars = [UUID : Car]()

    mutating func orderCar(facroty: CarMakingDelegate, color: Palette) {
        self.factory = facroty
        let newCar = facroty.makeCar(color: color)
        self.cars[newCar.vin] = newCar
    }
}

print("Трейдер:\n- Заказываю автомобили на всех заводах!")
var trader = Trader()
CarBrands.allCases.forEach { model in
    for _ in 1...countCarsInFactory[model]! {
        if let color = Palette.allCases.randomElement() {
            if let factory = factories[model] {
                trader.orderCar(facroty: factory, color: color)
            } else {
                print("Нет фабрики для бренда: ", model)
            }
        } else {
            print("Странно... цвета в палитре не нашлось")
        }
    }
}
print("Количество автомобилей всех марок заказанных трейдером: ", trader.cars.count )


class DealershipSalon: Dealership {

    var name: CarBrands
    var showroomCapacity: UInt16
    var stockCars: [Car] = []
    // с одной стороны это удобно при удалении и добавлении
    // но происходит ДВА лишних срабатывания при перестановке автомобиля с парковки в салон.
//    {
//        didSet {
//            cars = stockCars + showroomCars
//        }
//    }
    var showroomCars: [Car] = []
//    {
//        didSet {
//            cars = stockCars + showroomCars
//        }
//    }
    var cars: [Car] = []
    var factory: CarMakingDelegate?
    var sellColor: Palette = .green // если покупатель сам не выбирает цвет, то предлагаем ему зелёную

    init(name: CarBrands, showroomCapacity: UInt16) {
        self.name = name
        self.showroomCapacity = showroomCapacity
    }

    // предлагаем купить допы
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
        print("\tНа предпродажную подготовку поступил автомобиль", car.model, car.color)
        car.isServiced = true
        print("Предпродажная подготовка произведена")
    }

    func addToShowroom(_ car: inout Car) {
        print("\tПоступил запрос на перегон с парковки склада в автосалон автомобиля: ", car.model, car.price, car.color)
        guard stockCars.contains(where: {$0.vin == car.vin}) else {
            print("На парковке салона такого автомобиля нет")
            return
        }
        showroomCars += [car]
        stockCars.removeAll{ $0.vin == car.vin }
        print("Автомобиль переставлен в салон")

        presaleService(&car)
    }

    func sellCar(_ car: inout Car) {
        print("\tПродаём автомобиль", car.model, car.color)
        if showroomCars.first(where: {$0.vin == car.vin}) == nil { // тут была ошибка в коде
            print("Машины в салне нет. Забираем её со стоянки.")
            if showroomCars.count >= showroomCapacity {
                print("Салон переполнен! Перегоняем первую машину из салона на парковку")
                stockCars.append(showroomCars.removeFirst())
            }
            addToShowroom(&car)
        }

        presaleService(&car)

        // формируем список нехватающих допов // allAccessories vs. car.accessories
        let carAccessories = Set(car.accessories)
        let newAccessories = allAccessories.subtracting(Set(car.accessories)) // это причина выбора множества.
        if newAccessories.count > 0 {
            offerAccessories(Array(newAccessories))
            car.buyingAccessories()
        } else {
            print("Аксессуаров уже под завязку. Больше ничего предложить не можем.")
        }

        print(car.vin)
        cars.removeAll{ $0.vin == car.vin}
        showroomCars.removeAll{ $0.vin == car.vin}
        print("\tПродано!")

        orderCar()
    }

    func orderCar() {
        print("Салон \(name) заказывает себе новый автомобиль цвета \(sellColor)...")
        guard let newCar = factory?.makeCar(color: sellColor) else {
            print("Не удалость заказать автомобиль \(name) цвета \(sellColor) в салон")
            return
        }
        cars      += [newCar]
        stockCars += [newCar]
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
var dealershipBrands = [CarBrands : DealershipSalon]()

dealershipBrands[.BMW] = DealershipSalonBMW(factory: factories[.BMW]!)
dealershipBrands[.Honda] = DealershipSalonHonda(factory: factories[.Honda]!)
dealershipBrands[.Audi] = DealershipSalonAudi(factory: factories[.Audi]!)
dealershipBrands[.Lexus] = DealershipSalonLexus(factory: factories[.Lexus]!)
dealershipBrands[.Volvo] = DealershipSalonVolvo(factory: factories[.Volvo]!)

// ! Каждому дилерскому центру добавьте машин на парковку и в автосалон (используйте те машины, которые создали ранее).
// Трейдер раставляет автомобили по салонам
for (vin, car) in trader.cars {
    if let salon = dealershipBrands[car.model] {
        salon.cars.append(car)
        if car.color == Palette.allCases.randomElement()  &&  salon.showroomCars.count < salon.showroomCapacity {
            salon.showroomCars.append(car)
        } else {
            salon.stockCars.append(car)
        }
        trader.cars[vin] = nil
    } else {
        print("Для марки \(car.model) не нашлось салона")
    }
}
dealershipBrands.forEach { (model: CarBrands, salon: DealershipSalon) in
    print("Количество автомобилей переданнх в диллерский центр \(model)): ", salon.cars.count)
}
print("Количество автомоблией оставшихся у трейдера: ", trader.cars.count)


// MARK: - Задача №1

print(line)

protocol SpecialOffer {
    func makeSpecialOffer(_ index: Int) throws
}

enum ErrorSpecialOffer: Error {
    case year(_ year: String)
}

// Возвращать ошибку внутри цикла означает прервать цикл,
// поэтому метод makeSpecialOffer() должен обрабатывать конкретный автомобиль, а не все
// для проверки всех автомобилей делаем дополнительную функцию

extension DealershipSalonBMW: SpecialOffer {

    func makeSpecialOffer(_ index: Int) throws {
        print("\tSpecialOffer")
        let date = Date()
        let year = cars[index].buildDate.formatted(.dateTime.year())
        guard year != date.formatted(.dateTime.year()) else {
            // ! 1. Внесите изменения в метод 'makeSpecialOffer()' таким образом, чтобы он возвращал ошибку, если машина не соответствует требованиям акции.
            throw ErrorSpecialOffer.year(date.formatted(.dateTime.year()))
        }
        // ! 2. В случае, если нет ошибки, сделайте для этой машины специальное предложение.
        print("Good: Автомобиль с годом выпуска машины меньше текущего: \(year), что соответствует условия акции.")
        let newPrice = cars[index].price * 85 / 100
        // это изменяет цену только в общем массиве, а эта же машина ещё в салоне или на парковке, где цена не меняется автоматически, т.к. автомобиль -- это структура.
        cars[index].price = newPrice
        // дальше или искать этот автомобиль в салоне или на парковке и менять ему цену
        if let i = stockCars.firstIndex(where: { $0.vin == cars[index].vin }) {
            stockCars[i].price = newPrice
        } else if let i = showroomCars.firstIndex(where: { $0.vin == cars[index].vin }) {
            showroomCars[i].price = newPrice
        }
    }

    // ! 3. Проверьте текущий список машин, чтобы при проверке генерировались ошибки. При необходимости, внесите изменения.
    // ! 4. Обработайте ошибки.
    func makeSpecialOfferForAllCars() {
        for i in 0 ..< cars.count {
            do { try makeSpecialOffer(i);
                print("Предложение принято! Цена:", cars[i].price)
            }
            catch ErrorSpecialOffer.year(let year) {print("Error: Автомобиль имеет год __", year, "__ что не соответствуе условию акции")}
            catch {print("Error: ?")}
        }
    }
}

// для разнообразия раскроем не как в прошлом ДЗ
var salonBMW = dealershipBrands[.BMW] as! DealershipSalonBMW
salonBMW.makeSpecialOfferForAllCars()

print("\nКонтрольная печать")
var carsTemp = [Car]()
carsTemp = salonBMW.cars
for i in 0 ..< carsTemp.count {
    print( i,
           carsTemp[i].buildDate.formatted(.dateTime.year()),
           carsTemp[i].price,
           carsTemp[i].vin,
           carsTemp[i].color
    )
}
print("\nStock")
carsTemp = salonBMW.stockCars
for i in 0 ..< carsTemp.count {
    print( i,
           carsTemp[i].buildDate.formatted(.dateTime.year()),
           carsTemp[i].price,
           carsTemp[i].vin,
           carsTemp[i].color
    )
}
print("\nRoom")
carsTemp = salonBMW.showroomCars
for i in 0 ..< carsTemp.count {
    print( i,
           carsTemp[i].buildDate.formatted(.dateTime.year()),
           carsTemp[i].price,
           carsTemp[i].vin,
           carsTemp[i].color
    )
}


/* MARK: - Задача №2

 - осуществлялся возврат ошибки в том случае, если машина со скидкой уже находится в автосалоне.
 - В том случае, если ошибки нет, нужно перегнать машину в автосалон.
*/
print(line)

protocol CarToSalon {
    func toSalon(_ index: Int) throws
}

enum ErrorCarToSalon: Error {
    case into
}

extension DealershipSalonBMW: CarToSalon {

   func toSalon(_ index: Int) throws {
       print("\tCar to salon: ",
             index,
             cars[index].buildDate.formatted(.dateTime.year()),
             cars[index].price,
             cars[index].vin,
             cars[index].color
//             , terminator: "; "
       )

       let date = Date()
       if cars[index].buildDate.formatted(.dateTime.year()) != date.formatted(.dateTime.year()) {
           guard !showroomCars.contains(where: {$0.vin == cars[index].vin}) else {
               throw ErrorCarToSalon.into
           }
           // нельзя брать автомобиль из общего массива, т.к. эта процедура меняет порядок элементов в массиве.
           // var car = cars[index]
           if let i = stockCars.firstIndex(where: { car in car.vin == cars[index].vin }) {
               var car = stockCars[i]
               print("На парковке найдено:"
                     , car.buildDate.formatted(.dateTime.year())
                     , car.price
                     , car.vin
                     , car.color
               )
               addToShowroom(&car)
           }
       } else {
           print("Error? No! Машина без скидки") // тоже просится в throw, но этого нет в условии задачи
       }
    }

    func carsToSalon() {
        for i in 0 ..< cars.count {
            do {
                try toSalon(i)
            }
            catch ErrorCarToSalon.into {
                print("Error: машина со скидкой уже находится в автосалоне.")
            }
            catch {print("Error: ?")}
        }
    }
}

salonBMW.carsToSalon()
