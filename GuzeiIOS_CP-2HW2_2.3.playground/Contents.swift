let line = "\n" + String(repeating: "-" as Character, count: 80) + "\n"
/*
 Домашнее задание к занятию 2.3 Замыкания

        Тип для Замыкания: на входе два параметра Double, На Выходе Double.

    Задача 1
 История:
 В вашей команде два ученых по космодинамике.
 Вы даете каждому из них задачу
 - расcчитать количество топлива
 для достижения спутником цели.
 Данные, которые они получают — это:
 - вес спутника
 - дальность полета.
 Они должны вам предоставить свои
 - алгоритмы расчета расхода топлива (это ваши замыкания).
 А вы по готовности алгоритмов делаете
 - обработку данных и
 - сравниваете результат
 (это ваша функция).

 Алгоритм выполнения
 Написать функцию с входящим параметром — замыкание (тип указан выше). Функция должна выводить в консоль результат выполнения замыкания.
 Написать два замыкания (тип указан выше). Внутри должна быть математическая операция (на ваш выбор) над входящими значениями.
 Вызвать функцию для первого замыкания и потом для второго замыкания.
 Выполнить задание, не сокращая синтаксис языка.
*/
print("\nTask 1\n")

let satelliteWeight = 1.0
let distanceToEurope = 2.0

func fuel(calc: (Double, Double) -> Double) -> Double {
    let fuel = calc(satelliteWeight, distanceToEurope)
    print("требуется топлива: \(fuel)")
    return fuel
}
// судя по тексту задачи "Написать два замыкания" замыкания надо написать отдельно
var formula1 = { (satelliteWeight: Double, distanceToEurope: Double) -> Double in
    return satelliteWeight * distanceToEurope * 2
}
var formula2 = { (satelliteWeight: Double, distanceToEurope: Double) -> Double in
    return satelliteWeight * distanceToEurope * 3
}
print("Расчёт #1:", terminator: " ")
var fuelResult1 = fuel(calc: formula1)
print("Расчёт #2:", terminator: " ")
var fuelResult2 = fuel(calc: formula2)

print("\n -- или без промежуточных переменный -- \n")

print("Расчёт #1:", terminator: " ")
fuelResult1 = fuel(calc: { (satelliteWeight: Double, distanceToEurope: Double) -> Double in
    return satelliteWeight * distanceToEurope * 2
})
print("Расчёт #2:", terminator: " ")
fuelResult2 = fuel(calc: { (satelliteWeight: Double, distanceToEurope: Double) -> Double in
    return satelliteWeight * distanceToEurope * 3
})

// В истории есть, а в алготитме нет про обработку данных и сравнение результатов:
var fuelToEurope = max( fuelResult1, fuelResult2 )
print("\nДо Европы надо _\(fuelToEurope)_ едениц топлива")


/*
 Задача 2

 История: Ваша задача запомнить максимально краткую форму записи алгоритмов, чтобы все не смешалось в голове.
 Алгоритм выполнения: Представить задание 1 в сокращенном виде (см. пункт лекции "Сокращения для замыканий").
*/
print(line,"\nTask 2\n")

formula1 = { $0 * $1 * 2 }
formula2 = { $0 * $1 * 3 }
print("Расчёт #1:", terminator: " ")
fuelResult1 = fuel(calc: formula1)
print("Расчёт #2:", terminator: " ")
fuelResult2 = fuel(calc: formula2)

print("\n -- или без промежуточных переменных -- \n")

print("Расчёт #1:", terminator: " ")
fuelResult1 = fuel(calc: { $0 * $1 * 2 })
print("Расчёт #2:", terminator: " ")
fuelResult2 = fuel(calc: { $0 * $1 * 3 })

print("До Европы надо _\(max( fuelResult1, fuelResult2 ))_ едениц топлива")

/*
 Задача 3 * (задача со звездочкой):
 История:
 Вы решили использовать свою функцию для проверки гипотезы и стали набирать алгоритм прямо в ней (реализация замыкания вместо параметра).

 Алгоритм выполнения
 Вызвать функцию из задания 1, определив ей замыкание самостоятельно (не передавая).
 Объяснить, куда и почему исчезло ключевое слово ('param' - в примере) для параметра.
 Пример:
 func example(param: () -> Void) {
     // ...
 }

 example {
     // ...
 }
 */

print(line, "\nTask 3\n")
print("Мужики в деревне сказали, что топливо до Европы надо счиать по-другому! Мужик сказал, ему виднее.")
// Применяем последующее замыкание, а поэтому и ярлык аргумента пропадает. Синтаксис такой.
// fuel() { $0 * $1 * 5 }
// а так как аргумент единственный, то и круглые скобки опускаем
// 5 - это новая гипотеза

fuel{ $0 * $1 * 5 }  // не, ну красиво выходит :)
