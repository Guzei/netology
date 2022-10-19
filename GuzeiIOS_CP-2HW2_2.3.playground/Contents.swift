//
// Домашнее задание "Замыкания"
//

print("Task 1")

func fuel(calculation: (Double, Double) -> Double) -> Double {
    let fuel = calculation(satelliteWeight, distanceToEurope)
    print("требуется топлива: \(fuel)")
    return fuel
}

var algorithm1 = { (satelliteWeight: Double, distanceToEurope: Double) -> Double in
    return satelliteWeight * distanceToEurope * 2
}
var algorithm2 = { (satelliteWeight: Double, distanceToEurope: Double) -> Double in
    return satelliteWeight * distanceToEurope * 3
}

// исходные данные
let satelliteWeight = 1.1
let distanceToEurope = 2.2

print("Расчёт по алгоритму #1:", terminator: " ")
var fuel1 = fuel(calculation: algorithm1)

print("Расчёт по алгоритму #2:", terminator: " ")
var fuel2 = fuel(calculation: algorithm2)

func fuelToEurope(_ data1: Double, _ data2: Double) -> Double {
    return max( data1, data2 )
}
print("\tДо Европы надо _\(fuelToEurope(fuel1, fuel2))_ едениц топлива")


print("\nTask 2")

algorithm1 = { $0 * $1 * 2 }
algorithm2 = { $0 * $1 * 3 }

print("Расчёт #1:", terminator: " ")
fuel1 = fuel(calculation: algorithm1)

print("Расчёт #2:", terminator: " ")
fuel2 = fuel(calculation: algorithm2)

print("\tДо Европы надо _\(fuelToEurope(fuel1, fuel2))_ едениц топлива")


print("\nTask 3")
/*
 Применяем последующее замыкание, а поэтому и ярлык аргумента пропадает, а само замыкание выносится за (). Синтаксис такой.
 fuel() { $0 * $1 * 5 }
 а так как аргумент единственный, то и круглые скобки опускаем
*/
print("Расчёт по своему алгоритму:", terminator: " ")
fuel{ $0 * $1 * 5 }
