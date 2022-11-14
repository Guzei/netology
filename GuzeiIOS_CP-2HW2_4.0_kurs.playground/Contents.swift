//
// MARK: - Курсовой проект “Основы Swift advanced” -
//
// В качестве курсового проекта вы разработаете модель ресторана, используя ООП
//
//
//Создайте следующие протоколы и определите в них свойства и методы.
//1.1. Ресторан
//Свойства: название, сотрудники, склад с продуктами, меню.
//1.2. Сотрудник
//Свойства: имя, пол, возраст, должность (менеджер, повар, официант и т.д.).
//1.3. Блюдо
//Свойства: тип блюда (салат, горячее, гарнир, десерт), ингредиенты (картофель, лук, мясо, соль), время приготовления, цена.
//1.4. Заказ
//Свойства: время получения заказа, время отдачи заказа, блюда в заказе, готовность.
//

import Foundation

let db = UserDefaults.standard

enum Sex {
    case male
    case female
}

enum Position {                             // должность
    case manager                            // менеджер
    case cook                               // повар
    case garcon                             // официант
    // ...
}

enum TypeOfDish: String {                   // тип блюда
    case salad = "салат"
    case main = "горячее"
    case side = "гарнир"
    case dessert = "десерт"
    // ...
}
enum Ingredients: String, CaseIterable {    // ингредиенты
    case potatoes                           // картофель
    case onion                              // лук
    case meat                               // мясо
    case salt                               // соль
    case eggs                               // яйца
    case butter                             // масло
    // ...
}

protocol Cooking {
    func cooking(dish: TypeOfDish)
}


protocol Restaurant {                       // 1.1. Ресторан
    var name: String { get }                // название
    var staff: String { get }               // сотрудники
    var foodRoom: String { get }            // склад с продуктами
    var menu: String { get }                // меню
}

protocol Person {                           // 1.2. Сотрудник
    var name: String { get }                // имя
    var sex: Sex { get }                    // пол
    var age: UInt8 { get }                  // возраст
    var employee: Position { get }          // должность
}

protocol Dish {                             // 1.3. Блюдо
    var type: TypeOfDish { get }            // тип блюда
    var ingradient: Set<Ingredients> { get }
    var time: UInt { get }                  // время приготовления
    var price: UInt { get }                 // цена
    var ready: Bool { get }                 // готовность
}

protocol OrderProtocol {                    // 1.4. Заказ
    var timeIn: Date { get }                // время получения заказа // время внесения заказа в компьютер.
    var timeOut: Date? { get }              // время отдачи заказа // пусть это будет "отдачи с кухни", тогда это по времени готовности
    var dish: Set<TypeOfDish> { get }       // блюда в заказе
    var ready: Bool { get }                 // готовность
}

//
// Создайте следующие классы и структуры.
// 2.1. Должности (менеджер, повар, официант и т.д.) подписать под протокол Сотрудник.
//      Свойства и методы зависят от должности.
//      Для поваров продумать несколько должностей. Каждый должен иметь метод “готовить”, но иметь еще свои методы.
//      Например, повар холодного цеха делает салаты; повар горячего цеха умеет варить и жарить, шеф-повар умеет все (можно сделать привязку к типу блюда).
// 2.2. Конкретные блюда подписать под протокол Блюда.
//      Ингредиенты зависят от типа блюда. Например, для яичницы нужны: яйца, масло, соль.
//      Создать минимум 5 блюд.
// 2.3. Заказ подпишите под протокол Заказы.
//
struct Manager: Person {                    // менеджер
    var name: String
    let sex: Sex
    var age: UInt8
    var employee: Position
}
// Для поваров продумать несколько должностей.
// Каждый должен иметь метод “готовить”, но иметь еще свои методы.
// Например, повар холодного цеха делает салаты; повар горячего цеха умеет варить и жарить, шеф-повар умеет все (можно сделать привязку к типу блюда).
struct Cook: Person, Cooking {              // повар
    var name: String
    let sex: Sex
    var age: UInt8
    var employee: Position

    func cooking(dish: TypeOfDish){}
}
struct Confectioner: Person, Cooking {
    var name: String
    let sex: Sex
    var age: UInt8
    var employee: Position

    func cooking(dish: TypeOfDish){}
}

struct Garcon: Person {                     // официант
    var name: String
    let sex: Sex
    var age: UInt8
    var employee: Position

    func takeOrder(order: Set<TypeOfDish>){}
}


// 2.2. Конкретные блюда подписать под протокол Блюда.
struct Omelette: Dish {

    var type: TypeOfDish = .main
    var ingradient: Set<Ingredients> = [.eggs, .butter, .salt]
    var time: UInt = 10
    var price: UInt = 500
    var ready: Bool = false
}

struct CaesarSalad: Dish {

    var type: TypeOfDish = .salad
    var ingradient: Set<Ingredients>
    var time: UInt = 10
    var price: UInt = 550
    var ready: Bool = false
}

struct Caesar1: Dish { // бифстроганов
//    CoreData
    var type: TypeOfDish
    var ingradient: Set<Ingredients>
    var time: UInt
    var price: UInt
    var ready: Bool = false
}

struct Caesar2: Dish { // медовик

    var type: TypeOfDish
    var ingradient: Set<Ingredients>
    var time: UInt
    var price: UInt
    var ready: Bool = false
}

struct Caesar3: Dish {  // Bloody Mary

    var type: TypeOfDish
    var ingradient: Set<Ingredients>
    var time: UInt
    var price: UInt
    var ready: Bool = false
}

// 2.3. Заказ подпишите под протокол Заказы.
struct Order: OrderProtocol {
    var timeIn: Date = Date()                       // время получения заказа ставим равным созданию заказа
    var timeOut: Date?
    var dish: Set<TypeOfDish>
    var ready: Bool = false {                       // заказ готов, когда все блюда в заказе готовы
        didSet {
            if ready {
                timeOut = Date()                    // время готовности (отдачи) заказа
            }
        }
    }
}

// Создайте хранилища:
// * продукты (ингредиенты), хранящиеся на складе с указанием количества (продумайте, какой вид коллекции использовать).
//   Создайте минимум 15 продуктов на складе.
// * заказы. Содержит в себе заказы.
//

var foodRoom: Dictionary<Ingredients,Int> {
    get {
        guard let dicStrInt = db.dictionary(forKey: "ingredient") as? [String:Int] else {
            print("no data for key \"ingredient\"")
            return [:]
        }
        var dicEnumInt: Dictionary<Ingredients, Int> = [:]
        for (s,i) in dicStrInt {
            if let e = Ingredients(rawValue: s) {
                dicEnumInt[e] = i
            }
        }
        return dicEnumInt
    }
    set {
        var dicStrInt: Dictionary<String, Int> = [:]
        for (key, val) in newValue {
            dicStrInt[key.rawValue] = val
        }
        db.set(dicStrInt, forKey: "ingredient")
    }
}

print("На продуктовом складе до обноления:")
foodRoom.forEach { (key: Ingredients, value: Int) in
    print(key, value)
}

foodRoom[.salt] = 1                                       // завезли яйца


print("На продуктовом складе после обноления:")
foodRoom.forEach { (key: Ingredients, value: Int) in
    print(key, value)
}


// Добавлять свои свойства и методы допустимо.
// Продумайте, где можно и нужно использовать enum вместо стандартных свойств.
//
// Задача co звездочкой (необязательное задание)
// Реализуйте логику в методах.
// Например, у официанта метод “принять заказ” добавляет в начало хранилища с заказами переданный заказ.
// Повар берет первый добавленный заказ из хранилища и готовит. В данном случае нужно разобраться с FIFO и LIFO.
// После приготовления устанавливается время приготовления, статус меняется на “готов”.
// Наприер, вы можете учесть, что от типа блюда заказ может выполнить нужный повар или шеф.
// Реализуйте любую логику на ваше усмотрение.
