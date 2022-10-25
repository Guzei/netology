//
// Домашнее задание к занятию 3.1. Наследование. Переопределение
//

let line = "\n" + String(repeating: "-" as Character, count: 80) + "\n"
var trackTitle: String

// MARK: - Задача 1
print("\nTask 1\n")
/*
 Создайте суперкласс артист;
 Определите в нем общие для артиста свойства (имя, страна, жанр);
 Определите общие методы (написать трек и исполнить трек);
 В реализацию метода “написать трек” добавьте вывод в консоль “Я (имя артиста) написал трек (название трека)”;
 В реализацию метода “исполнить трек” добавьте вывод в консоль “Я (имя артиста) исполнил трек (название трека)”;
 Создайте 3 сабкласса любых артистов и переопределите в них МЕТОДЫ суперкласса класса.
*/

// Что ж, если продолжаем, то надо что-то взять из прошлого. Например список стран:
enum Countries: String {
    case ru = "Российская Федерация"
    case ri = "Российская Империя"
    case us = "USA"
    case fr = "République française"
}


class Artist {

    var name: String
    var country: Countries
    var genre: String

    init(name: String, country: Countries, genre: String) {
        self.name = name
        self.country = country
        self.genre = genre
    }

    func writeTrack(_ title: String) {
        print("Я, \(name), написал(а) трек \"\(title)\".")
    }

    func playTrack(_ title: String) {
        print("Я, \(name), исполнил(а) трек \"\(title)\".")
    }
}

class PopArtist: Artist {

    override func writeTrack(_ title: String) {
        super.writeTrack(title)
        print("Уточняю: попса.")
    }

    override func playTrack(_ title: String) {
        super.playTrack(title)
        print("фанера?")
    }
}

class RapArtist: Artist {

    override func writeTrack(_ title: String) {
        super.writeTrack(title)
        print("В стиле рэп. Для тех, кто в танке.")
    }

    override func playTrack(_ title: String) {
        super.playTrack(title)
        print("Качаем зал!")
    }
}

class ClassicArtist: Artist {

    override func writeTrack(_ title: String) {
        super.writeTrack(title)
        print("И завтра ещё напишу.")
    }

    override func playTrack(_ title: String) {
        super.playTrack(title)
        print("Для любимой аудитории")
    }
}

var klavaCoca = PopArtist(name: "Клава Кока", country: .ru, genre: "Поп")
var crash = RapArtist(name: "Crash", country: .us, genre: "Рэп")
var tchaikovsky = ClassicArtist(name: "Чайковский", country: .ri, genre: "Классика")

trackTitle = "Плачешь"
klavaCoca.writeTrack(trackTitle)
klavaCoca.playTrack(trackTitle)

trackTitle = "Road to me"
crash.writeTrack(trackTitle)
crash.playTrack(trackTitle)

trackTitle = "Времена года"
tchaikovsky.writeTrack(trackTitle)
tchaikovsky.playTrack(trackTitle)


// MARK: - Задача 2 -
print(line, "\nTask 2\n")
/*
 Доработайте существующих артистов так, чтобы они имели уникальные для каждого из них свойства и методы.
 Защитите этих артистов от редактирования в будущем.
*/

final class PopArtistPlus: PopArtist {

    var nickName: String
    private var isMicrophoneSwitchOn = false

    func microfonSwitching(_ switchOnOff: Bool) {
        isMicrophoneSwitchOn = !isMicrophoneSwitchOn
    }

    override func playTrack(_ title: String) {
        guard isMicrophoneSwitchOn else {
            print("Не забудьте включить микрофон 😀")
            return
        }
        print("Я, \(name) aka \(nickName), из \(country.rawValue) исполнил(а) трек \"\(title)\"")  // полностью заменяем базовую функцию не нарушая контракта.
        microfonSwitching(false)
    }

    // инициализатор переопределяется с использованием родительского
    init(name: String, country: Countries, genre: String, nickName: String) {
        self.nickName = nickName
        super.init(name: name, country: country, genre: genre)
    }

}

final class RapArtistPlus: RapArtist {

    var numberOfTattoos = 0

    func isInsider() -> Bool {
        return numberOfTattoos > 10
    }
    // в этом примере инициализатор наследуется полностью
}

final class ClassicArtistPlus: ClassicArtist {

    var countTchaikovskyCompetition: UInt8 { // 🫢
        didSet {
            print("Теперь кличество участий в конкурсе им.П.И.Чайковского: ", countTchaikovskyCompetition)
        }
    }

    func plusOneToCompetition() {
        self.countTchaikovskyCompetition += 1
    }

    init(name: String, country: Countries, genre: String, countTchaikovskyCompetition: UInt8) {
        self.countTchaikovskyCompetition = countTchaikovskyCompetition
        super.init(name: name, country: country, genre: genre)
    }
    convenience init(_ name: String, _ country: Countries, _ genre: String, _ countTchaikovskyCompetition: UInt8) {
        self.init(name: name, country: country, genre: genre, countTchaikovskyCompetition: countTchaikovskyCompetition)
    }

    override func playTrack(_ title: String) {
        super.playTrack(title)
        print("Да, кстати, я из страны: \"\(country.rawValue)\"")
    }
}

// class PopArtictPlusSub: PopArtistPlus {} // Error: Inheritance from a final class 'PopArtistPlus'

var klavaCocaPlus = PopArtistPlus(name: "Клавдия Вадимовна Высокова", country: .ru, genre: "Поп", nickName: "Клава Кока")
klavaCocaPlus.playTrack("Плачешь")
klavaCocaPlus.microfonSwitching(true)
klavaCocaPlus.playTrack("Плачешь")

var crashPlus = RapArtistPlus(name: "Crash", country: .us, genre: "Рэп")
crashPlus.isInsider()
crashPlus.numberOfTattoos = 11
crashPlus.isInsider()


var martinovPlus = ClassicArtistPlus(name: "Мартынов", country: .ru, genre: "Классика", countTchaikovskyCompetition: 5)
var tchaikovskyPlus = ClassicArtistPlus("Чайковский", .ri, "Классика", 0)
tchaikovskyPlus.countTchaikovskyCompetition // 0
tchaikovskyPlus.plusOneToCompetition()
tchaikovskyPlus.plusOneToCompetition()
tchaikovskyPlus.playTrack("Времена года")


// MARK: - Задача 3 * (задача со звездочкой) -
print(line, "\nTask 3\n")
/*
 Создайте пустой массив, чтобы потом добавить в него ваших артистов;
 Добавьте созданных ранее артистов в массив;
*/


var artists = [Artist]()

// Дайте всех! по два экземпляра. Запахло полиморфизмом.
artists += [klavaCoca, klavaCocaPlus, crash, crashPlus, tchaikovsky, tchaikovskyPlus]

// и всё же как лучше проходить по всем элементам? Или общего правила нет и это личные предпочтения? Или от команды зависит?
for artist in artists {
    print(artist.name)
}
print("\n")
artists.forEach {
    print($0.playTrack("BB")) // Демонстрация полиморфизма, т.к. это метод разный. Вот только не понял откуда взялись пустые скобки при выводе в консоль?
}

artists[4].playTrack("CC") // Если печать по отдельности то скобок () нет. Загадка.

//artists[1].nickName // Опс...
// смотрим видео https://youtu.be/1D-DFsNS1tY?t=1183 и записываем для конспекта :)
if artists[1] is PopArtistPlus {
    print(line, (artists[1] as! PopArtistPlus).nickName)
}

/*
 Напишите отчет о том, что вы поняли/в чем разобрались, выполняя это задание;
 Дайте оценку своему пониманию данной темы.
 Данное задание поможет вам лучше понять эту тему. В процессе написания отчета вы выявите слабые и сильные места в изучении данной темы, закроете пробелы или у вас появятся новые вопросы.
*/

/*
 override уже было и раньше и это не вызывает сложностей
 convenience - что-то новенькое. По лекции всё понятно. Ещё лучше понял прочитав: https://swiftbook.ru/content/languageguide/initialization/
 final - тоже новое, но очевидное
 Для лучшего запоминания сделал шпаргалку
 https://github.com/Guzei/swift/blob/main/inheritance.playground/Contents.swift

 Тема ООП (да и как и другие темы) в представленном объёме полностью понятна в момент прохождения и требудет много практики для закрепления.

 а ещё показалось, что полиморфизм и замыкания похожи друг на друга
*/
