
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



import Foundation

let db = UserDefaults.standard                      // Хранилище хранилищ :)

// MARK: - FOODS -
//
//      Начнём с продуктов. Официанты с заказами и пр. уже на них завязаны, поэтому позже.
//

typealias FoodList = Dictionary<Foods, UInt>        // это тип списка продуктов название:количество и для склада и для блюда

typealias Menu = Dictionary<TypeOfDish, Set<NameOfDish>>    // Понравилось мне писать тип коллекции словами. Нагляднее выходит. Может быть пока.

enum Foods: String, CaseIterable {                  // продукты (ингредиенты), которые могут быть на продуктовом складе ресторана и которые входят в блюда
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
}

enum TypeOfDish {

    case salad
    case main
    case side
    case dessert
    case cocktail
}

enum NameOfDish {                                   // В меню ресторана так оказало очень наглядно

    case 🥗                                         // салат Цезарь
    case 🍳                                         // яичница глазунья
    case 🥩                                         // стейк
    case 🍟                                         // картофель фри
    case 🍰                                         // пирожное
    case 🥤                                         // коктейль Кровавая Мери
    case 🍹                                         // коктейль Шприц Апероль
}

protocol Dish {                                     // MARK: 1.3. Блюдо

    var type: TypeOfDish {get}                      // ! тип блюда (салат, горячее, гарнир, десерт)
    var food: FoodList {get}                        // ! ингредиенты (картофель, лук, мясо, соль)
    var time: UInt {get}                            // ! время приготовления                        // в секундах
    var price: UInt {get}                           // ! цена                                       // в рублях
    var isReady: Bool {get}                                                                         // готово?
}


// MARK: 2.2. Конкретные блюда подписать под протокол Блюда.
// ! Ингредиенты зависят от типа блюда. Например, для яичницы нужны: яйца, масло, соль.
// ! Создать минимум 5 блюд.

//  Тут хотелось проследить совпадение количества NameOfDish и структур конкретных блюд, но не придумал как посчитать структуры.

struct FriedEggs: Dish {

    var type: TypeOfDish = .main
    var food: FoodList = [.eggs:2, .butter:1, .salt:1]
    var price: UInt = 500
    internal var time: UInt = 600
    internal var isReady: Bool = false
}

struct CaesarSalad: Dish {

    var type: TypeOfDish = .salad
    var food: FoodList = [.caesarSalad: 1, .caesarSaladDressing: 1, .chicken: 3] // Это салат курицей или курица с салатом?
    var price: UInt = 750
    internal var time: UInt = 500
    internal var isReady: Bool = false
}

struct steak: Dish {

    var type: TypeOfDish = .main
    var food: FoodList = [.meat: 1]
    var time: UInt = 900
    var price: UInt = 1200
    var isReady: Bool = false
}

struct FrenchFries: Dish {

    var type: TypeOfDish = .side
    var food: FoodList = [.potatoes: 2, .salt: 2]
    var time: UInt = 300
    var price: UInt = 200
    var isReady: Bool = false
}

struct BloodyMary: Dish {

    var type: TypeOfDish = .cocktail
    var food: FoodList = [.vodka: 3, .tomatoJuice: 1]
    var time: UInt = 30
    var price: UInt = 300
    var isReady: Bool = false
}

struct AperolSpritz: Dish {

    var type: TypeOfDish = .cocktail
    var food: FoodList = [.aperolLiqueur: 1, .prosecco: 1, .sparklingWater: 2]
    var time: UInt = 60
    var price: UInt = 600
    var isReady: Bool = false
}



// MARK: - ORDERS -
//
//      Далее заказы. Они завизят только от продуктов, а сами используются далее.
//

protocol Orders {                                   // MARK: 1.4. Заказы

    var timeIn: Date {get}                          // ! время получения заказа
    var timePlan: Date? {get}                       // ! время отдачи заказа по плану
    var timeOut: Date? {get}                        //   время отдачи заказа реальное
    var dishs: Array<Dish> {get}                    // ! блюда в заказе       // одинаковые названия блюд в заказе -- норма
    var isReady: Bool {get}                         // ! готовность
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

// Хранилище заказов будет уже внутри ресторана



// MARK: - person & staff -
//
//      Вот и до людей должна очередь, т.к. они работают с продуктами и заказами.
//

typealias Staff = Dictionary<UUID, MemberOfStaff>

enum Sex {
    case male
    case female
}

enum Position {                                     // должность

    case cook                                       // повар (горячее, холодное, кондитер, бармен...)
    case manager                                    // менеджер
    case garcon                                     // официант
}

protocol Person {                                   // просто человек

    var name: String {get}                          // ! имя
    var sex: Sex {get}                              // ! пол
    var age: UInt8 {get}                            // ! возраст
}

protocol MemberOfStaff: Person {                    // MARK: 1.2. Сотрудник
                                                    //   человек становится сотрудником, когда получает табельный номер и должность
    var id: UUID {get}
    var position: Position {get}                    // ! должность (менеджер, повар, официант и т.д.)
}

class Garcon: MemberOfStaff {                      // MARK: 2.1. Должности. Официант.

    let id = UUID()
    var name: String
    let sex: Sex
    var age: UInt8
    var position: Position = .garcon

    init(name: String, sex: Sex, age: UInt8) {
        self.name = name
        self.sex = sex
        self.age = age
    }

    func takeOrder(dishs: Set<Menu>) {             // ! добавляет в начало хранилища с заказами переданный заказ.
        print("Order to list")
    }
}

let ira   = Garcon(name: "Ира" , sex: .female, age: 20)
let misha = Garcon(name: "Миша", sex:   .male, age: 20)


// соискатели на должности
//var juzeppe = Person(name: "Juzeppe", sex:   .male, age: 40)
//var mila    = Person(name: "Mila"   , sex: .female, age: 30)
//var ivan    = Person(name: "Ivan"   , sex:   .male, age: 30)
//var ira     = Person(name: "Ira"    , sex: .female, age: 20)
//var masha   = Person(name: "Masha"  , sex: .female, age: 20)
//




// MARK: - restaurant


protocol Restaurant {                               // MARK: 1.1. Ресторан

    var name: String {get}                        // ! название
    var staff: Staff {get}                        // ! сотрудники
    var menu: Menu {get}                          // ! меню
    var foodRoom: FoodList {get}                  // ! склад с продуктами
    var order: Array<Orders> {get}               //   хранилище (стек типа FIFO) заказов наполняемый официантами и уменьшаемый шеф-поваром
}




// MARK: - модель конкретного ресторна -
// Иерархия для сотрудников -- Агрегация = Слабая ассоциация. При удалении ресторана должности пропадут, но люди останутся.
// иерархия для блюд -- Композиция = Владение или Сильная ассоциация. Блюда разработаны шефом только для этого ресторна.


struct Butler: Restaurant {

    var name = "Butler"
    var staff = Staff()
    var menu: Menu = [.salad    : [.🥗],           // у каждого ресторана своё меню, но структура общая
                      .main     : [.🍳,.🥩],
                      .side     : [.🍟],
                      .dessert  : [.🍰],
                      .cocktail : [.🥤, .🍹]
    ]
    internal var foodRoom = FoodList()              // склад продуктов. Будет запоминаться.
    internal var order: Array<Orders> = []         // все заказы, добавленные всеми официантами.


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
            if let food = Foods(rawValue: name) {
                foodRoom[food] = count
            }
        }
        return foodRoom
    }

    mutating func updateFoodRoom(_ foodList: FoodList) {
        foodList.forEach{ foodRoom[$0] = $1 }
    }

    func toDB() {                                                       // запоминаем все изменения на складе
        var foodRoomDB: Dictionary<String, UInt> = [:]                  // формат словаря в UserDefaults
        foodRoom.forEach{ foodRoomDB[$0.rawValue] = $1 }                // конвертируем
        db.set(foodRoomDB, forKey: name)                                // запоминаем словарь целиком в одном ключе
    }

    mutating func hiringToJob(person: Person, position: Position) {
        let newMemberOfStaff = MemberOfStaff(person: person, positon: position)
        staff[newMemberOfStaff.id] = newMemberOfStaff
    }

    // запрос свободного официанта
    // TODO: guard и обработка ошибки
    func takeGarcon() -> MemberOfStaff? {
        if let garson = staff.first(where: { $1.vacant && $1.position == .garcon })?.value {
            print("-- Здравствуйте, меня зовут \(garson.name), я буду вашим официантом сегодня")
            garson.vacant = false
            return garson
        } else {
            print("Изивинте, все официанты заняты")
            return nil
        }
    }
}

var butler = Butler()


// Нанимаем людей в ресторан в качестве сотрудников
butler.hiringToJob(person: ira, position: .garcon)
butler.hiringToJob(person: masha, position: .garcon)
butler.hiringToJob(person: juzeppe, position: .cook)
butler.hiringToJob(person: mila, position: .cook)
butler.hiringToJob(person: ivan, position: .manager)

print("\nВ ресторан \(butler.name) приняты на работу:")
butler.staff.forEach{print("\($1.name) - \($1.position)")}


print("\nНа продуктовом складе ресторана \(butler.name) уже давно лежат:")
butler.foodRoom.forEach{ print($0, $1) }

// с сортировкой решил не заморачиваться. Это отдельный пармер вводить придётся. Ведь по алфавиту меню не сортируют. Но сейчас, навероное, это не самое важное.
print("\nМеню ресторана \(butler.name):")
for (type, dishSet) in butler.menu {
    print("\n------------------\n", type)
    for name in dishSet {
        print(name)
    }
}

// занятые работой официанты и принятые ими заказы
var busyGarson: [UUID:[NameOfDish]] = [:]

print("\n-- Официант!")
if let garson = butler.takeGarcon() {
    print("-- \(garson.name), две яичницы, пожалуйста. Глазуньи!")
    busyGarson[garson.id] = [.🍳,.🍳]
    print("-- Да, и кокнейль Кровавая Мэри, чуть не забыл")
    busyGarson[garson.id]! += [.🥤]
    print("-- Позвольте повторить Ваш заказ:", terminator: " ")
    busyGarson[garson.id]!.forEach{print($0, terminator: " ")}
}

print("\n-- Официант!")
if let garson = butler.takeGarcon() {
    print("-- \(garson.name), мне коктейльчика хочется")
    let menuItem = butler.menu[.cocktail]?.randomElement() ?? .🥤
    print("Не желаете попробовать \(menuItem)?")
    print("Годится!")
    busyGarson[garson.id] = [.🥤]
    print("-- Позвольте повторить Ваш заказ:", terminator: " ")
    busyGarson[garson.id]!.forEach{print($0, terminator: " ")}
}

print("\n-- Официант!")
if let garson = butler.takeGarcon() {
    let menuItem = butler.menu[.cocktail]?.randomElement() ?? .none
    if menuItem != .none {
        print("-- \(garson.name), хочу \(String(describing: menuItem)), да побыстрее!")
    }
    // у нас только два официанта и этому готю должен быть отказ
}

// Официанты понесли заказы на кухню
busyGarson.forEach { (id, dishs) in
    let garson = butler.staff[id]!                     // смело форсим, т.к. id сюда пришло надёжное только что.
    garson.takeOrder(dishs)
    garson.vacant = true                     // смело форсим, т.к. id сюда пришло надёжное только что.
}



butler.updateFoodRoom([.salt:2, .eggs:80, .potatoes:2, .onion:5])
butler.toDB()





//var menu = [FriedEggs.self, CaesarSalad.self] as [Any]
//


//struct Manager: MemberOfStaff {                     // MARK: 2.1. Должности. Менеджер.
//
//    let id: UUID
//    var name: String
//    let sex: Sex
//    var age: UInt8
//    var position: Position
//}
//
//protocol Cooking {
//    func cooking()
//}
//struct Cook: MemberOfStaff, Cooking {               // MARK: 2.1. Должности. Повар.
//
//    let id: UUID
//    var name: String
//    let sex: Sex
//    var age: UInt8
//    var position: Position
//
//    func cooking() {                                // ! Повар берет первый добавленный заказ из хранилища и готовит.
//        print("Cook")
//    }
//}
//
//protocol CookingDessert {                           // MARK: 2.1. Должности. Контдитер.
//    func cooking()
//}
//struct Confectioner: MemberOfStaff, CookingDessert {
//
//    let id: UUID
//    var name: String
//    let sex: Sex
//    var age: UInt8
//    var position: Position
//
//    func cooking() {
//        print("Dessert cooking...")
//        print("Dessert is ready")
//    }
//}



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




