
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

// MARK: - Комментарии к решению
//
//  попробовал побольше вспомнить чему учили: делегаты, обработка ошибок, наблюдатели, перечисления, extension, ...
//      pushOrder() - как концентрация многого
//  дополнительно нечаянно основил UserDefaults решив, что это и есть "хранилище", но потом усомнился.
//      Решил задачу записи словаря с перечислением в UserDefaults
//  усложинил заказ. В нём может быть не одно блюдо, а несколько. Потом повара сами разбираются что кому готовить и формируют выполненный заказ.
//  с заказами дополнительно реализована логика "запись на бумажку у столика" и потом "запись в кассу с проврекой возможности исполнить"
//  В качестве названий блюд использовал пиктограммы. Очень хотелось попробовать как это работает. Оказалось очень наглядно, мне понравилось.
//      заменить на слова реплейсом будет очень просто при необходимости
//


import Foundation

let db = UserDefaults.standard                      // Хранилище хранилищ :)

typealias FoodList = Dictionary<Food, UInt>         // это тип списка продуктов название:количество и для склада и для блюда

typealias Menu = Dictionary<TypeOfDish, Set<NameOfDish>>    // Понравилось мне писать тип коллекции словами. Нагляднее выходит. Может быть пока.

typealias PreOrder = Array<NameOfDish>              // предварительный заказ. Только имена.

typealias Staff = Array<MemberOfStaff>

enum Errors: Error {

    case food(food: Food)
    case count(food: Food, count: UInt, countInRoom: UInt)
    case sorry(dishName: NameOfDish)
}

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

enum TypeOfDish: CaseIterable {

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
    var isReady: Bool {get set}                                                                     // готово? заказ готов, когда все блюда готовы
}
extension Dish {
    func printSelf() {
        print("Dish name: \(name), type of \(type), with price \(price), time to ready  \(time) sec, \(isReady ? "is Ready!" : "no reade yet" )")
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
    internal var isReady: Bool = false
}

struct CaesarSalad: Dish {

    let name: NameOfDish = .🥗
    let type: TypeOfDish = .salad
    let food: FoodList = [.caesarSalad: 1, .caesarSaladDressing: 1, .chicken: 3] // Это салат курицей или курица с салатом?
    let price: UInt = 750
    internal let time: UInt = 500
    internal var isReady: Bool = false
}

struct Steak: Dish {

    let name: NameOfDish = .🥩
    let type: TypeOfDish = .main
    let food: FoodList = [.meat: 1]
    let price: UInt = 1200
    internal let time: UInt = 900
    internal var isReady: Bool = false
}

struct FrenchFries: Dish {

    let name: NameOfDish = .🍟
    let type: TypeOfDish = .side
    let food: FoodList = [.potatoes: 2, .salt: 2]
    let price: UInt = 200
    internal let time: UInt = 300
    internal var isReady: Bool = false
}

struct Biscuit: Dish {

    let name: NameOfDish = .🍰
    let type: TypeOfDish = .dessert
    let food: FoodList = [.eggs: 5, .butter: 100, .flour: 100]
    let price: UInt = 500
    internal let time: UInt = 3600
    internal var isReady: Bool = false
}

struct BloodyMary: Dish {

    let name: NameOfDish = .🥤
    let type: TypeOfDish = .cocktail
    let food: FoodList = [.vodka: 3, .tomatoJuice: 1]
    let price: UInt = 300
    internal let time: UInt = 30
    internal var isReady: Bool = false
}

struct AperolSpritz: Dish {

    let name: NameOfDish = .🍹
    let type: TypeOfDish = .cocktail
    let food: FoodList = [.aperolLiqueur: 1, .prosecco: 1, .sparklingWater: 2]
    let price: UInt = 600
    internal let time: UInt = 60
    internal var isReady: Bool = false
}



// MARK: - ORDERS -
//
//      Далее заказы. Они завизят только от продуктов, а сами используются далее.
//

protocol Orders {                                   // MARK: 1.4. Заказы

    var timeIn: Date {get}                          // ! время получения заказа
    var timePlan: Date? {get}                       // ! время отдачи заказа по плану
    var timeOut: Date? {get}                        //   время отдачи заказа реальное
    var dishs: Array<Dish> {get set}                    // ! блюда в заказе // Одинаковые названия блюд в заказе -- норма.
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

final class Order: Orders {                         // MARK: 2.3. Заказ подпишите под протокол Заказы
                                                    // Что выбрать класс или структуру? Думаю вопрос не только наследования, но и передачи между объектами.
                                                    //  передавать лучше ссылку на область памяти, а не размножать экземпляры. Поэтому класс. Верно ли?
    var timeIn: Date = Date()
    var timePlan: Date?
    var timeOut: Date? {                            // ! После приготовления устанавливается время приготовления, статус меняется на “готов”
        didSet {
            isReady = timeOut != nil
        }
    }
    var dishs: Array<Dish> = [] {
        didSet {
            setPlan()                               // только тут мало. При инициализации не срабатывает.
        }
    }
    var isReady: Bool = false

    init( dishs: Array<Dish> ) {
        self.dishs = dishs
        setPlan()
    }

    private func setPlan() {
        if let dish = dishs.max(by: {$0.time < $1.time}) {              // какое блюдо дольше всех готовится
            timePlan = timeIn.addingTimeInterval(Double(dish.time))
        }
    }
}



// MARK: - persons & staff -
//
//      Вот и до людей дошла очередь, т.к. они работают с продуктами и заказами.
//

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
}

// А вот и делегаты пошли. Будем поручать ресторану проверить есть ли на его складе продукты из списка.
// Кто как не владелец склада продуктов и хранилища заказов лучше всех их обработает?
protocol CheckFoodsInRoom {
    func checkFoodsInRoom(foodList: FoodList) throws
}
protocol PushOrder {
    func pushOrder(_ order: Order)
}
protocol PullOrder {
    func pullOrder() -> Order?
}

final class Garcon: MemberOfStaff {
                                                    // MARK: 2.1. Должности. Официант.
                                                    // ! подписать под протокол Сотрудник
    var name: String
    let sex: Sex
    var age: UInt8
    let position: Position = .garcon
    var vacant = true                               // свободен. Готов принять заказ.
    var preOrder: PreOrder = []                     // для записи заказа на бумажку у столика и последующего формирования заказа в компьютере
    var rest: CheckFoodsInRoom & PushOrder

    init(name: String, sex: Sex, age: UInt8, rest: CheckFoodsInRoom & PushOrder) {
        self.name = name
        self.sex = sex
        self.age = age
        self.rest = rest
    }

    func pushOrder() throws {                       // ! добавляет в начало хранилища с заказами переданный заказ.
                                                    //   начало -- значит кладём в first, а забираеть будем last
                                                    //   но сначала надо проверить хватает ли продуктов
                                                    //   по записанным на бумажку названиям блюд пытаемся создать их экземпляры на кассе (в БД)
        var dishs: Array<Dish> = []
        try preOrder.forEach({ dishName in

            var dish: Dish {                        // берём рецепт заказанного блюда
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
                dishs += [dish]
            }
            catch {
                throw Errors.sorry(dishName: dish.name)
            }
        })
        rest.pushOrder(Order(dishs: dishs))         // формируем заказ и вписываем его в стек

        vacant = true                               // официант готов принять новый заказ
        preOrder = []                               // надеюсь так корректно удалять
    }
}

struct Manager: MemberOfStaff {                     // MARK: 2.1. Должности. Менеджер.

    let name: String
    let sex: Sex
    var age: UInt8
    let position: Position = .manager

    func foo() {
        print("-- Гуляю по залу туда-сюда, смотрю за порядком")
    }

}

protocol Cooking {
    func cooking(_ dish: inout Dish)
}

// Шеф - класс, а остальные работники будут структуры.
// Сделал в попытках нащупать разницу в удобстве. Не сумел.

final class Chef: MemberOfStaff, Cooking {          // MARK: 2.1. Должности. Шеф-повар.

    let name: String
    let sex: Sex
    var age: UInt8
    let position: Position = .cook
    var rest: PullOrder                             // ! Повар берет первый добавленный заказ из хранилища и готовит.
    var cook: Cooking?                              //   усложнение: шеф-повар берёт заказ, смотрит какие в нём блюда и поручает специалистам их готовить

    init(name: String, sex: Sex, age: UInt8, rest: PullOrder) {
        self.name = name
        self.sex = sex
        self.age = age
        self.rest = rest
    }

    func cooking(_ dish: inout Dish) {
        print("Cooking \(dish.name)...")
        dish.isReady = true
    }
}

struct Barman: MemberOfStaff, Cooking {             // MARK: 2.1. Должности. Бармен.
    var name: String
    var sex: Sex
    var age: UInt8
    let position: Position = .cook

    func cooking(_ dish: inout Dish) {
        print("Dish \(dish.name) is ready!")
        dish.isReady = true
    }
}

struct Confectioner: MemberOfStaff, Cooking {       // MARK: 2.1. Должности. Кондитер.

    var name: String
    let sex: Sex
    var age: UInt8
    let position: Position = .cook

    func cooking(_ dish: inout Dish) {
        print("Dessert \(dish.name)  is ready")
        dish.isReady = true
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

final class Butler: Restaurant, CheckFoodsInRoom, PushOrder, PullOrder {

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
    var orders: Array<Order> = []                   // ! заказы. Содержит в себе заказы.        // Массив структур.
                                                    //   хранилище заказов -- стек типа FIFO --  наполняемый официантами и уменьшаемый шеф-поваром и барменом

    init() {
        self.foodRoom = initFoodRoom()
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

    func pushOrder(_ order: Order) {
        print("\n\tCont of orders berfor insert", orders.count)
        orders.insert(order, at: 0)                 // ! метод “принять заказ” добавляет в начало хранилища с заказами переданный заказ.
                                                    //   если бы не "начало", то сделал бы += [], a изымыл бы first
    }

    func pullOrder() -> Order? {                    // шеф-повар запрашивает в компьютере последний заказ
        print("\tCount in orders:", orders.count)
        guard orders.count > 0 else {
            return nil
        }
        return orders.removeLast()                  // т.к. добавляем в first, то last - это самый старый заказ. FIFO.
    }
}


// MARK:                        - GO! -

var butler = Butler()

// приём на работу
let chef = Chef(name: "Juzeppe", sex: .male, age: 40, rest: butler)
let barman = Barman(name: "Алексей", sex: .male, age: 22)
let confectioner = Confectioner(name: "Мила", sex: .female, age: 30)
let manager = Manager(name: "Света", sex: .female, age: 33)


// Официантов запишем сразу в массив и потом будем искать в массиве по их типу.
butler.staff += [Garcon(name: "Ира", sex: .female, age: 20, rest: butler),
                 Garcon(name: "Миша", sex: .male, age: 20, rest: butler),
                 Garcon(name: "Саша", sex: .male, age: 20, rest: butler),
                 chef,
                 barman,
                 confectioner,
                 manager
]

butler.printStaff()

print("\nНа продуктовом складе ресторана \(butler.name) со вчерашнего дня лежат:")
butler.foodRoom.forEach{ print($0, $1) }

print("\nМеню ресторана \(butler.name):")
for (type, dishSet) in butler.menu {
    print("\n------------------\n", type)
    for name in dishSet {
        print(name)
    }
}

var busygarcon = [Garcon]()

print("\n--1 Официант!")
if var garcon = butler.takeGarcon() {
    print("-- \(garcon.name), две яичницы, пожалуйста. Глазуньи!")
    garcon.preOrder = [.🍳,.🍳]
    print("-- Да, и кокнейль Кровавая Мэри, чуть не забыл")
    garcon.preOrder += [.🥤]
    print("-- Позвольте повторить Ваш заказ:", terminator: " ")
    garcon.preOrder.forEach{print($0, terminator: " ")}
}
// на вторую глазунью не хватит масла и заказ будет отменён

print("\n\n--2 Официант!")
if var garcon = butler.takeGarcon() {
    print("-- \(garcon.name), мне стейк и коктейльчик какой-нибудь посоветуйте...")
    let menuItem = butler.menu[.cocktail]?.randomElement() ?? .🥤
    print("-- Не желаете попробовать \(menuItem)?")
    print("-- Годится!")
    garcon.preOrder = [.🥩, menuItem]
    print("-- Позвольте повторить Ваш заказ:", terminator: " ")
    garcon.preOrder.forEach{print($0, terminator: " ")}
}

print("\n\n--3 Официант!")
if var garcon = butler.takeGarcon() {
    print("-- \(garcon.name), мне что-нибудь и каждого блока меню")
    TypeOfDish.allCases.forEach({
        if let menuItem = butler.menu[$0]?.randomElement() {
            garcon.preOrder += [menuItem]
        }
    })
    print("-- Позвольте повторить Ваш заказ:", terminator: " ")
    garcon.preOrder.forEach{print($0, terminator: " ")}
}

print("\n\n--4 Официант!")
if var garcon = butler.takeGarcon() {
    let menuItem = butler.menu[.cocktail]?.randomElement() ?? .none
    if menuItem != .none {
        print("-- \(garcon.name), хочу \(String(describing: menuItem)), да побыстрее!")
    }
    // у нас только три официанта и этому четвёртому гостю должен быть отказ
}

print("\n-- Официанты понесли заказы к кассе --")
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

for _ in 0 ..< butler.orders.count {                // можно было бы и сразу заказ изымать, но в задании это должен делать повар.

    if var order = chef.rest.pullOrder() {          // ! Повар берет первый добавленный заказ из хранилища и готовит.
        // ! В данном случае нужно разобраться с FIFO и LIFO.

        print("Выполняем заказ")
        //order.printSelf()
        for var dish in order.dishs {

            var cook: Cooking {
                switch dish.type {                  // ! вы можете учесть, что от типа блюда заказ может выполнить нужный повар или шеф.
                case .cocktail: return barman
                case .dessert: return confectioner
                default: return chef
                }
            }
            chef.cook = cook                        // шеф-повар назначает исполнителя для приготовления конкретного блюда. Может и сам.
            chef.cook?.cooking(&dish)
            print("Ready?", dish.isReady)
        }

        order.timeOut = Date()                      // ! После приготовления устанавливается время приготовления, статус меняется на “готов”. // didSet
        print("Время выполения заказа:", order.timeOut!, "Статус заказа:", order.isReady)
    }
    else {
        print("заказов нет")
    }
}

print("\n\nА что делаем менеджер?")
manager.foo()

// вечером привезли новые продукты
butler.updateFoodRoom([.salt: 100,
                       .eggs: 100,
                       .potatoes: 100,
                       .onion: 100,
                       .butter: 10,                  // масла на глазунью хватит, а если выбадет бисквит, то будет отказ
                       .meat: 2,
                       .vodka: 100,
                       .sparklingWater: 100,
                       .prosecco: 100,
                       .aperolLiqueur: 100,
                       .tomatoJuice: 100,
                       .caesarSalad: 100,
                       .caesarSaladDressing: 100,
                       .chicken: 100
])

butler.toDB()
