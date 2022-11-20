
//  MARK: - Курсовой проект “Основы Swift advanced” -

// В качестве курсового проекта вы разработаете модель ресторана, используя ООП

// 1.   Создайте следующие протоколы и определите в них свойства и методы.
// 1.1. Ресторан
//      Свойства: название, сотрудники, склад с продуктами, меню.
// 1.2. Сотрудник
//      Свойства: имя, пол, возраст, должность (менеджер, повар, официант и т.д.).
// 1.3. Блюдо
//      Свойства: тип блюда (салат, горячее, гарнир, десерт), ингредиенты (картофель, лук, мясо, соль), время приготовления, цена.
// 1.4. Заказ
//      Свойства: время получения заказа, время отдачи заказа, блюда в заказе, готовность.

//
// 2.   Создайте следующие классы и структуры.
// 2.1. Должности (менеджер, повар, официант и т.д.) подписать под протокол Сотрудник.
//      Свойства и методы зависят от должности.
//      Для поваров продумать несколько должностей. Каждый должен иметь метод “готовить”, но иметь еще свои методы.
//      Например,
//      - повар холодного цеха делает салаты;
//      - повар горячего цеха умеет варить и жарить,
//      - шеф-повар умеет все
//      (можно сделать привязку к типу блюда).
// 2.2. Конкретные блюда подписать под протокол Блюда.
//      Ингредиенты зависят от типа блюда. Например, для яичницы нужны: яйца, масло, соль.
//      Создать минимум 5 блюд.
// 2.3. Заказ подпишите под протокол Заказы.
//
// 3.   Создайте хранилища:
//    * продукты (ингредиенты), хранящиеся на складе с указанием количества (продумайте, какой вид коллекции использовать).
//      Создайте минимум 15 продуктов на складе.
//    * заказы. Содержит в себе заказы.

// Добавлять свои свойства и методы допустимо.


//      Задача co звездочкой (необязательное задание)

//      Реализуйте логику в методах.
//      - Например, у официанта метод “принять заказ” добавляет в начало хранилища с заказами переданный заказ.
//      - Повар берет первый добавленный заказ из хранилища и готовит. В данном случае нужно разобраться с FIFO и LIFO.
//      - После приготовления устанавливается время приготовления, статус меняется на “готов”.
//      - Наприер, вы можете учесть, что от типа блюда заказ может выполнить нужный повар или шеф.
//      Реализуйте любую логику на ваше усмотрение.


//
//  попробовал побольше вспомнить что учили: делегаты, обработка ошибок, наблюдатели, перечисления, extension
//      pushOrder() - как концентрация многого
//  дополнительно нечаянно основил UserDefaults решив, что это и есть "хранилище", но потом усомнился.
//      Решил задачу записи словаря с перечислением в UserDefaults
//  с заказами дополнительно реализована логика "запись на бумажку у столика" и потом "запись в кассу с проврекой возможности исполнить"
//  В качестве названий блюд использовал пиктограммы. Очень хотелось попробовать как это раотает. Оказалось очень наглядно, мне понравилось.
//      заменить на слова реплейсом будет очень просто при необходимости
//


import Foundation

let db = UserDefaults.standard                      // Хранилище хранилищ :)

typealias FoodList = Dictionary<Food, UInt>         // это тип списка продуктов название:количество и для склада и для блюда

typealias Menu = Dictionary<TypeOfDish, Set<NameOfDish>>    // Понравилось мне писать тип коллекции словами. Нагляднее выходит. Может быть пока.

typealias PreOrder = Array<NameOfDish>              // предварительный заказ. Только имена.

//
// MARK: - FOODS -
//
//      Начнём с продуктов. Официанты с заказами и пр. уже на них завязаны, поэтому позже.
//


enum Food: String, CaseIterable {                   // продукты (ингредиенты), которые могут быть на продуктовом складе ресторана и которые входят в блюда
                                                    // ! Создайте минимум 15 продуктов на складе
    case potatoes
    case onion
    case meat
    case salt
    case eggs
    case butter
    case caesarSalad
    case caesarSaladDressing
    case chicken
    case vodka
    case tomatoJuice
    case sparklingWater
    case prosecco
    case aperolLiqueur
    case oliveOil
    case flour
}

enum TypeOfDish {

    case salad
    case main
    case side
    case dessert
    case cocktail
}

enum NameOfDish {

    case 🥗                                         // салат Цезарь
    case 🍳                                         // яичница глазунья
    case 🥩                                         // стейк
    case 🍟                                         // картофель фри
    case 🍰                                         // бисквит
    case 🥤                                         // коктейль Кровавая Мери
    case 🍹                                         // коктейль Шприц Апероль
}

protocol Dish {                                     // MARK: 1.3. Блюдо

    var name: NameOfDish {get}
    var type: TypeOfDish {get}                      // ! тип блюда (салат, горячее, гарнир, десерт)
    var food: FoodList {get}                        // ! ингредиенты (картофель, лук, мясо, соль)
    var time: UInt {get}                            // ! время приготовления                        // в секундах
    var price: UInt {get}                           // ! цена                                       // в рублях
    var isReady: Bool {get}                                                                         // готово? заказ готов, когда все блюда готовы
}
extension Dish {
    func printSelf() {
        print("Dish name: \(name), of type \(type), with price \(price), time to ready [sec] - \(time) \(isReady ? "is Ready!" : "no reade yet" )")
        print("ingredients:")
        food.forEach{print($0,$1)}
    }
}


// MARK: 2.2. Конкретные блюда подписать под протокол Блюда.
// ! Ингредиенты зависят от типа блюда. Например, для яичницы нужны: яйца, масло, соль.
// ! Создать минимум 5 блюд.

//  Тут хотелось проследить совпадение количества NameOfDish и количества структур конкретных блюд, но не придумал как посчитать структуры.

struct FriedEggs: Dish {

    let name: NameOfDish = .🍳
    let type: TypeOfDish = .main
    let food: FoodList = [.eggs:2, .butter:1, .salt:1]          // иногда состав пишут в меню подробно
    let price: UInt = 500
    internal let time: UInt = 600
    internal let isReady: Bool = false
}

struct CaesarSalad: Dish {

    let name: NameOfDish = .🥗
    let type: TypeOfDish = .salad
    let food: FoodList = [.caesarSalad: 1, .caesarSaladDressing: 1, .chicken: 3] // Это салат курицей или курица с салатом?
    let price: UInt = 750
    internal let time: UInt = 500
    internal let isReady: Bool = false
}

struct Steak: Dish {

    let name: NameOfDish = .🥩
    let type: TypeOfDish = .main
    let food: FoodList = [.meat: 1]
    let price: UInt = 1200
    internal let time: UInt = 900
    internal let isReady: Bool = false
}

struct FrenchFries: Dish {

    let name: NameOfDish = .🍟
    let type: TypeOfDish = .side
    let food: FoodList = [.potatoes: 2, .salt: 2]
    let price: UInt = 200
    internal let time: UInt = 300
    internal let isReady: Bool = false
}

struct Biscuit: Dish {

    let name: NameOfDish = .🍰
    let type: TypeOfDish = .dessert
    let food: FoodList = [.eggs: 5, .butter: 100, .flour: 100]
    let price: UInt = 500
    internal let time: UInt = 3600
    internal let isReady: Bool = false
}

struct BloodyMary: Dish {

    let name: NameOfDish = .🥤
    let type: TypeOfDish = .cocktail
    let food: FoodList = [.vodka: 3, .tomatoJuice: 1]
    let price: UInt = 300
    internal let time: UInt = 30
    internal let isReady: Bool = false
}

struct AperolSpritz: Dish {

    let name: NameOfDish = .🍹
    let type: TypeOfDish = .cocktail
    let food: FoodList = [.aperolLiqueur: 1, .prosecco: 1, .sparklingWater: 2]
    let price: UInt = 600
    internal let time: UInt = 60
    internal let isReady: Bool = false
}



// MARK: - ORDERS -
//
//      Далее заказы. Они завизят только от продуктов, а сами используются далее.
//

protocol Orders {                                   // MARK: 1.4. Заказы

    var timeIn: Date {get}                          // ! время получения заказа
    var timePlan: Date? {get}                       // ! время отдачи заказа по плану
    var timeOut: Date? {get}                        //   время отдачи заказа реальное
    var dishs: Array<Dish> {get}                    // ! блюда в заказе // Одинаковые названия блюд в заказе -- норма.
    var isReady: Bool {get}                         // ! готовность
}
extension Orders {
    func printSelf() {
        print("\n -- Order --")
        print("TimeIn: ", timeIn)
        print("TimeOut: ", timeOut ?? "no information")
        print("TimePlan: ", timePlan ?? "no information")
        print("Redy?:", isReady)
        dishs.forEach { $0.printSelf() }
    }
}

struct Order: Orders {                             // MARK: 2.3. Заказ подпишите под протокол Заказы

    var timeIn: Date = Date()
    var timePlan: Date?
    var timeOut: Date? {                            // ! После приготовления устанавливается время приготовления, статус меняется на “готов”
        didSet {
            isReady = timeOut != nil
        }
    }
    var dishs: Array<Dish> = [] {
        didSet {
            if let dish = dishs.max(by: {$0.time < $1.time}) {              // какое блюдо дольше всех готовится
                timePlan = timeIn.addingTimeInterval(Double(dish.time))
            }
        }
    }
    var isReady: Bool = false
}



// MARK: - persons & staff -
//
//      Вот и до людей дошла очередь, т.к. они работают с продуктами и заказами.
//

typealias Staff = Array<MemberOfStaff>

enum Sex { case male, female }

enum Position {                                     // должность

    case cook                                       // повар (горячее, холодное, кондитер, бармен...)
    case manager                                    // менеджер
    case garcon                                     // официант
}

protocol MemberOfStaff {                            // MARK: 1.2. Сотрудник

    var name: String {get}                          // ! имя
    var sex: Sex {get}                              // ! пол
    var age: UInt8 {get}                            // ! возраст
    var position: Position {get}                    // ! должность (менеджер, повар, официант и т.д.)
    //var vacant: Bool {get}                          //   любой член команды может быть занят и в это время он не может ни готовить, ни принимать заказы.
}

enum Errors: Error {
    case food(food: Food)
    case count(food: Food, count: UInt, countInRoom: UInt)
    case sorry(dishName: NameOfDish)
}

// А вот и делегаты пошли. Будем поручать ресторану проверить есть ли на его складе продукты из списка.
// Кто как не владелец склада продуктов и хранилища заказов лучше всех их обработает?
protocol CheckFoodsInRoom {
    func checkFoodsInRoom(foodList: FoodList) throws
}
protocol PushToOrders {
    func pushToOrders(_ order: Order)
}

class Garcon: MemberOfStaff {
                                                    // MARK: 2.1. Должности. Официант.
                                                    // ! подписать под протокол Сотрудник
    var name: String
    let sex: Sex
    var age: UInt8
    var position: Position = .garcon
    var vacant = true                               // свободен. Готов принять заказ.
    var preOrder: PreOrder = []                     // для записи заказа на бумажку у столика и последующего формирования заказа в компьютере
    var rest: CheckFoodsInRoom & PushToOrders

    init(name: String, sex: Sex, age: UInt8, rest: CheckFoodsInRoom & PushToOrders) {
        self.name = name
        self.sex = sex
        self.age = age
        self.rest = rest
    }

    func pushOrder() throws {                       // ! добавляет в начало хранилища с заказами переданный заказ.
                                                    //   начало -- значит кладём в first, а забираеть будем last
                                                    //   но сначала надо проверить хватает ли продуктов
                                                    //   по записанным на бумажку названиям блюд пытаемся создать их экземпляры на кассе (в БД)
        try preOrder.forEach({ dishName in

            // 1. берём рецепт заказанного блюда
            var dish: Dish {
                switch dishName {
                case .🥗: return CaesarSalad()
                case .🍳: return FriedEggs()
                case .🥩: return Steak()
                case .🍟: return FrenchFries()
                case .🍰: return Biscuit()
                case .🥤: return BloodyMary()
                case .🍹: return AperolSpritz()
                }
            }

            do {
                try rest.checkFoodsInRoom(foodList: dish.food)
                print("-- Продуктов для блюда \(dish.name) достаточно. Будем готовить.")
                // формируем заказ и вписываем его в стек
                let order = Order( dishs: [dish])
                rest.pushToOrders(order)
            }
            catch {throw Errors.sorry(dishName: dish.name)}
        })
        // официант готов принять новый заказ
        vacant = true
        preOrder = []
    }
}

struct Manager: MemberOfStaff {                     // MARK: 2.1. Должности. Менеджер.

    var name: String
    let sex: Sex
    var age: UInt8
    var position: Position = .manager
}

protocol Cooking {
    func cooking()
}
struct Cook: MemberOfStaff, Cooking {               // MARK: 2.1. Должности. Повар.

    var name: String
    let sex: Sex
    var age: UInt8
    var position: Position = .cook

    func cooking() {                                // ! Повар берет первый добавленный заказ из хранилища и готовит.
        print("Cook")
    }
}

protocol CookingDessert {                           // MARK: 2.1. Должности. Контдитер.
    func cooking()
}
struct Confectioner: MemberOfStaff, CookingDessert {

    var name: String
    let sex: Sex
    var age: UInt8
    var position: Position = .cook

    func cooking() {
        print("Dessert cooking...")
        print("Dessert is ready")
    }
}



// MARK: - restaurant

protocol Restaurant {                               // MARK: 1.1. Ресторан

    var name: String {get}                          // ! название
    var staff: Staff {get}                          // ! сотрудники
    var menu: Menu {get}                            // ! меню
    var foodRoom: FoodList {get}                    // ! склад с продуктами
}


// MARK: - модель конкретного ресторна -

class Butler: Restaurant, CheckFoodsInRoom, PushToOrders {

    var name = "Butler"
    var staff: Staff = []
    var menu: Menu = [.salad    : [.🥗],           // у каждого ресторана своё меню, но структура общая
                      .main     : [.🍳, .🥩],
                      .side     : [.🍟],
                      .dessert  : [.🍰],
                      .cocktail : [.🥤, .🍹]
    ]

                                                    // MARK: 3.   Создайте хранилища:
    var foodRoom = FoodList()                       // ! склад продуктов.
    var orders: Array<Orders> = []                  // ! заказы. Содержит в себе заказы.
                                                    //   хранилище заказов -- стек типа FIFO --  наполняемый официантами и уменьшаемый шеф-поваром и барменом

    init() {
        self.foodRoom = initFoodRoom()
        self.menu
    }

    // Забираем из UserDefaults хранимый там словарь [String:UInt] и превращаем его словарь [enum:UInt]
    func initFoodRoom() -> FoodList {
        var foodRoom: FoodList = [:]
        guard let foodRoomDB = db.dictionary(forKey: name) as? [String:UInt] else {
            print("no data for key \"\(name)\"")
            return foodRoom
        }
        for (name, count) in foodRoomDB {
            if let food = Food(rawValue: name) {
                foodRoom[food] = count
            }
        }
        return foodRoom
    }

    func updateFoodRoom(_ foodList: FoodList) {
        foodList.forEach{ foodRoom[$0] = $1 }
    }

    func toDB() {                                                       // запоминаем все изменения на складе
        var foodRoomDB: Dictionary<String, UInt> = [:]                  // формат словаря в UserDefaults
        foodRoom.forEach{ foodRoomDB[$0.rawValue] = $1 }                // конвертируем
        db.set(foodRoomDB, forKey: name)                                // запоминаем словарь целиком в одном ключе
    }

    func printStaff() {
        print("\nВ ресторане \(butler.name) работают:")
        butler.staff.forEach({
            print("\($0.position) - \($0.name)")
            switch $0.position {
            case .garcon: print("vacant?", ($0 as! Garcon).vacant)
            case .cook, .manager: print($0.age)
            }
        })
    }

    func printOrders() {
        orders.forEach{$0.printSelf()}
    }

    // запрос свободного официанта
    // TODO: guard и обработка ошибок
    func takeGarcon() -> Garcon? {

        let garcons = staff.compactMap{ $0 as? Garcon}

        if garcons.isEmpty {
            print("-- У нас самообслуживание!")
            return nil
        } else {
            if let garcon = garcons.first(where: {$0.vacant}) { // находим свободного
                garcon.vacant = false
                print("-- Здравствуйте, меня зовут \(garcon.name), я буду вашим официантом сегодня")
                return garcon
            } else {
                print("-- Извинте, все официанты заняты")
                return nil
            }
        }
    }

    func checkFoodsInRoom(foodList: FoodList) throws {
        print("Checking foods")
        for (food, count) in foodList {
            print("Check", food, count)
            guard let countInRoom = foodRoom[food]  else {
                throw Errors.food(food: food)
            }
            guard countInRoom >= count else {
                throw Errors.count(food: food, count: count, countInRoom: countInRoom)
            }
        }
        // только после проверки наличия всех ингредиентов блюда их можно бронировать для приготовления
        // в учебыных целях для разнообразия другой цикл
        foodList.forEach {
            print("было",foodRoom[$0]!)
            foodRoom[$0]! -= $1                     // смело форсим, т.к. вышё всё проверили
            print("стало",foodRoom[$0]!)
        }
    }

    func pushToOrders(_ order: Order) {
        orders.insert(order, at: 0)                 // ! метод “принять заказ” добавляет в начало хранилища с заказами переданный заказ.
                                                    //   если бы не "начало", то сделал бы += [], a изымыл бы first
    }
}


// MARK:                        - GO! -

var butler = Butler()

// иерархия для сотрудников и ресторана -- Агрегация = Слабая ассоциация. При удалении ресторана люди останутся.
// приём на работу
butler.staff += [Garcon(name: "Ира", sex: .female, age: 20, rest: butler),
                 Garcon(name: "Миша", sex: .male, age: 20, rest: butler),
                 Cook(name: "Juzeppe", sex: .male, age: 40),
                 Confectioner(name: "Мила", sex: .female, age: 30),
                 Cook(name: "Иван", sex: .male, age: 30)
]

butler.printStaff()

print("\nНа продуктовом складе ресторана \(butler.name) со вчерашнего дня лежат:")
butler.foodRoom.forEach{ print($0, $1) }

// с сортировкой решил не заморачиваться. Это отдельный пармер вводить придётся. Ведь по алфавиту меню не сортируют. Но сейчас, навероное, это не самое важное.
print("\nМеню ресторана \(butler.name):")
for (type, dishSet) in butler.menu {
    print("\n------------------\n", type)
    for name in dishSet {
        print(name)
    }
}

var busygarcon = [Garcon]()

print("\n-- Официант!")
if var garcon = butler.takeGarcon() {
    print("-- \(garcon.name), две яичницы, пожалуйста. Глазуньи!")
    garcon.preOrder = [.🍳,.🍳]
    print("-- Да, и кокнейль Кровавая Мэри, чуть не забыл")
    garcon.preOrder += [.🥤]
    print("-- Позвольте повторить Ваш заказ:", terminator: " ")
    garcon.preOrder.forEach{print($0, terminator: " ")}
}
//butler.printStaff()
print("\n\n-- Официант!")
if var garcon = butler.takeGarcon() {
    print("-- \(garcon.name), мне стейк и коктейльчик какой-нибудь посоветуйте...")
    let menuItem = butler.menu[.cocktail]?.randomElement() ?? .🥤
    print("-- Не желаете попробовать \(menuItem)?")
    print("-- Годится!")
    garcon.preOrder = [.🥩, menuItem]
    print("-- Позвольте повторить Ваш заказ:", terminator: " ")
    garcon.preOrder.forEach{print($0, terminator: " ")}
}
//butler.printStaff()

print("\n\n-- Официант!")
if var garcon = butler.takeGarcon() {
    let menuItem = butler.menu[.cocktail]?.randomElement() ?? .none
    if menuItem != .none {
        print("-- \(garcon.name), хочу \(String(describing: menuItem)), да побыстрее!")
    }
    // у нас только два официанта и этому треьему гостю должен быть отказ
}
//butler.printStaff()


print("\n -- Официанты понесли заказы к кассе --")
butler.staff.compactMap{$0 as? Garcon}.forEach { garcon in
    if !garcon.vacant {
        do {
            try garcon.pushOrder()
        }
        catch Errors.sorry(dishName: let name) {print("-- Извините, мы не можем приготовить \(name). Продукты на складе закончились :(")}
        catch {print("Error: ??")}

    }
}

butler.printOrders()

print("\n -- Повара начинают работать --")


// вечером привезли новые продукты
butler.updateFoodRoom([.salt: 100,
                       .eggs: 100,
                       .potatoes: 100,
                       .onion: 100,
                       .butter: 1,                  // масло мало, чтобы вторую яичницу нельзя было приготовить и сработал отказ
                       .meat: 2,
                       .vodka: 100,
                       .sparklingWater: 100,
                       .prosecco: 100,
                       .aperolLiqueur: 100,
                       .tomatoJuice: 100
])
butler.toDB()






//extension Position {
//    var who: String {
//        switch self {
//        case .cook([.salad, .main]):    return String("Шеф")
//        case .cook([.dessert]):         return String("Кондитер")
//        case .cook(_):                  return Cooking
//        case .manager:                  return String("Менеджер")
//        case .garcon:                   return String("Официант")
//        }
//    }
//}


//extension Position {
//    var who: MemberOfStaff, Cooking {
//        switch self {
//        case .cook([.salad, .main]):    return Cook.self as! MemberOfStaff
//        case .cook([.dessert]):         return Confectioner.self as! MemberOfStaff
//        case .cook(_):                  return Cook.self as! MemberOfStaff
////        case .manager:                  return Manager.self as! MemberOfStaff
////        case .garcon:                   return Garcon.self as! MemberOfStaff
//        }
//    }
//}

//enum Menu: CaseIterable, Hashable {
//
//    static var allCases: [Menu] {
//        return [.салатЦезарь (type: .salad   , foods: [.eggs    :1]),
//                .омлет       (type: .main    , foods: [.eggs    :2]),
//                .стейк       (type: .main    , foods: [.meat    :1]),
//                .медовик     (type: .dessert , foods: [.eggs    :1]),
//                .кроваваяМери(type: .cocktail, foods: [.potatoes:1])
//        ]
//    }
//    case салатЦезарь(type: TypeOfDish, foods: FoodList)                                // CaesarSalad
//    case омлет(type: TypeOfDish, foods: FoodList)                                      // Omelette
//    case стейк(type: TypeOfDish, foods: FoodList)
//    case медовик(type: TypeOfDish, foods: FoodList)
//    case кроваваяМери(type: TypeOfDish, foods: FoodList)
//}


//var typeOfDish: TypeOfDish = (.main)
//
//switch typeOfDish {
//case .main, .salad:
//    break
//case .side:
//    break
//case .dessert:
//    break
//case .cocktail:
//    break
//}


//typealias Menu = Dictionary<TypeOfDish, Set<String>>  // Внутри типа блюд все пункты уникальные
//typealias Menu1 = Set<Dish>
//class Person: PersonPr {                            //   Люди, которые будут наняты в ресторан в качестве сотрудников
//
//    var name: String
//    var sex: Sex
//    var age: UInt8
//
//    init(name: String, sex: Sex, age: UInt8) {
//        self.name = name
//        self.sex = sex
//        self.age = age
//    }
//}
//
//class MemberOfStaff: Person {                 // MARK: 1.2. Сотрудник
//    var id: UUID = UUID()                           //   табельный номер сотрудника в отделе кадров ресторана
//    var position: Position                          // ! должность (менеджер, повар, официант и т.д.)
//    var vacant: Bool = true                         //   статус: свободен для работы или занят (уже выполняет)
//
//    init(person: Person, positon: Position) {
//        self.position = positon
//        super.init(name: person.name, sex: person.sex, age: person.age)
//    }
//}

//let membersOfStaff = staff.filter({ $0 is Garcon }) // выделяем официантов
