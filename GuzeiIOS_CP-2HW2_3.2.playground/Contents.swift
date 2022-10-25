/*
 Домашнее задание к занятию 3.2. Протоколы и расширения

 Задача 1 (основная)

 ВЫ - главный архитектор в команде разработчиков. Ваша задача - разработать программное обеспечение (ПО) для дилерских центров по продаже автомобилей. Ваша цель - создать гибкое ПО. Что это значит? Ваше ПО должно подходить для любой марки авто, должно быть расширяемым и масштабируемым в дальнейшем, чтобы ваша компания могла выпускать обновления. Задача разделена на 4 части, в каждой из них нужно самостоятельно подумать, какой тип данных передать каждому свойству для комфортной работы, а также по необходимости добавить вспомогательные методы.

 Часть 1.

 Для начала нужно описать машину минимальным набором параметров, используя протокол.

 Алгоритм выполнения

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
    var model: String {get}
    var color: String {get}
    var buildDate: Int {get}
    var price: Int {get set}
    var accessories: [String] {get set}
    var isServiced: Bool {get set}
}
/* Часть 2.

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
    var name: String {get}
    var showroomCapacity: UInt {get}
    var stockCars: [Car] {get set}
    var showroomCars: [Car] {get set}
    var cars: [Car] {get set}
    func offerAccesories(accessories: [String])
    func presaleService(_ : Car)
    func addToShowroom(_ : Car)
    func sellCar(_ : Car)
    func orderCar()
}
/*
 Часть 3.

 Настало время добавить классы и структуры, реализующие созданные ранее протоколы.

 Алгоритм выполнения

 Используя структуры, создайте несколько машин разных марок (например BMW, Honda, Audi, Lexus, Volvo). Все они должны реализовать протокол 'Car'.
 Используя классы, создайте пять различных дилерских центров (например BMW, Honda, Audi, Lexus, Volvo). Все они должны реализовать протокол 'Dealership'. Каждому дилерскому центру добавьте машин на парковку и в автосалон (используйте те машины, которые создали ранее).
 Создайте массив, положите в него созданные дилерские центры. Пройдитесь по нему циклом и выведите в консоль слоган для каждого дилеского центра (слоган можно загуглить).
 Обратите внимание! Используйте конструкцию приведения типа данных для решения этой задачи.
*/
struct BMW: Car {
    var model: String = "BMW"
    var color: String
    var buildDate: Int
    var price: Int
    var accessories: [String]
    var isServiced: Bool
}
//, Honda, Audi, Lexus, Volvo). Все они должны реализовать протокол 'Car'.
class BmwCenter: Dealership {
    var name: String = "BMW"
    var showroomCapacity: UInt

    var stockCars: [Car]

    var showroomCars: [Car]

    var cars: [Car]

    func offerAccesories(accessories: [String]) {
        <#code#>
    }

    func presaleService(_: Car) {
        <#code#>
    }

    func addToShowroom(_: Car) {
        <#code#>
    }

    func sellCar(_: Car) {
        <#code#>
    }

    func orderCar() {
        <#code#>
    }


}
/*
 Часть 4.

 Работа с расширениями. Нам нужно добавить спецпредложение для "прошлогодних" машин.

 Алгоритм выполнения

 Создайте протокол SpecialOffer.
 Добавьте методы:
 'addEmergencyPack()': не принимает никаких параметров. Метод добавляет аптечку и огнетушитель к доп. оборудованию машины.
 'makeSpecialOffer()': не принимает никаких параметров. Метод проверяет дату выпуска авто, если год выпуска машины меньше текущего, нужно сделать скидку 15%, а также добавить аптеку и огнетушитель.
 Используя расширение, реализуйте протокол 'SpecialOffer' для любых трех дилерских центров.
 Проверьте все машины в дилерском центре (склад + автосалон), возможно они нуждаются в специальном предложении. Если есть машины со скидкой на складе, нужно перегнать их в автосалон.
 */