let line = "\n" + String(repeating: "-" as Character, count: 80) + "\n"
/*
 Домашнее задание к занятию 2.2. Свойства и методы

 version 3

Задача 1
 Вы разрабатываете библиотеку аудиотреков. Вам необходимо реализовать одну из категорий музыки, наполненную треками.

Создайте объект трек.
Определите в нем свойства:
- имя,
- исполнитель,
- длительность
- страна.
Подумайте, где можно использовать enum.

Создайте класс категория.
Объявите в нем свойства:
- название категории,
- список треков
- количество треков в списке
(экспериментируйте с "ленивыми" и вычисляемыми свойствами).
Определите методы добавления и удаления треков в эту категорию.
*/
// enum, наверное можно использовать везде :). Пусть будет тут:
enum Countries: String {
    case ru = "Российская Федерация"
    case ri = "Российская Империя"
    case us = "USA"
    case fr = "République française"
}
struct MusicTrack {
    var trackName: String
    var artist: String
    var duration: Int
    var country: Countries
}

var tracks = [MusicTrack]()
tracks.append(MusicTrack(trackName: "Road to me", artist: "Crash", duration: 33, country: .us))
tracks.append(MusicTrack(trackName: "Плачешь", artist: "Клава Кока", duration: 155, country: .ru))
tracks.append(MusicTrack(trackName: "Balance Ton Quoi", artist: "Angèle", duration: 265, country: .fr))
tracks.append(MusicTrack(trackName: "Времена года", artist: "Чайкоский", duration: 3600, country: .ri))

class MusicCategory {
    var name: String
    lazy var list = [MusicTrack]()
    var count: Int {
        list.count
    }
    func ins(track: MusicTrack) {
        guard !list.contains(where: {$0.trackName == track.trackName}) else {
            print("не частите")
            return
        }
        list.append(track)
    }
// v.1 Плохой вариант .remove(at: i)
//    func del(trackName: String) {
//        if let i = list.firstIndex(where: {$0.trackName == trackName}) {
//            list.remove(at: i)
//        }
//        else {
//            print("Нет такого трека")
//        }
//    }
// v.2
//    func del(trackName: String) -> Bool {
//        guard list.contains(where: {$0.trackName == trackName}) else {
//            print("В категории \"\(name)\" нет трека \"\(trackName)\"")
//            return false
//        }
//        list.removeAll { $0.trackName == trackName }        // жаль, что removeAll ничего не возвращает. Количество удалённых было бы полезно.
//        print("Трек \"\(trackName)\" найден и должн был быть удалён")
//        return true
//    }

//  v.3
    // тип trackName при удалении отличный от типа при добавлении был сделан с самого начала осознано по следующей логике:
    // 1) при добавлении трека без него не обойтись, а при удалении названия достаточно и писать название нагляднее, чем название переменной.
    // 2) чисто учебных целях пощупать как метод будет зависеть от типа входящей переменной. Код чуть короче получился, но менее надёжный.
    func del(track: MusicTrack) -> Bool {
        // в этой версии guard похоже лишний, т.к. сам swift не позволит послать на вход несущестующий трек, т.к. все треки храняться в массиве. Если треки хранить как отдельные переменные, то guard будет снова нужен.
        guard list.contains(where: {$0.trackName == track.trackName}) else {
            print("В категории \"\(name)\" нет трека \"\(track.trackName)\"")
            return false
        }
        list.removeAll { $0.trackName == track.trackName } 
        print("Трек \"\(track.trackName)\" найден и должн был быть удалён")
        return true
    }
    func printSelf() {
        print("Список треков в категории \"\(name)\":")
        for track in list {
            print("\tName: \(track.trackName); Artist: \(track.artist); Duration: \(track.duration); From: \(track.country.rawValue)")
        }
    }
    init(name: String) {
        self.name = name
    }
}

var jazz = MusicCategory(name: "Джаз")
var poprock = MusicCategory(name: "Поп-Рок")
var classic = MusicCategory(name: "Классика")

jazz.ins(track: tracks[0])
poprock.ins(track: tracks[1])
poprock.ins(track: tracks[2])
classic.ins(track: tracks[3])

print("Количество треков категории \"\(jazz.name)\": \(jazz.count)")
print("Количество треков категории \"\(poprock.name)\": \(poprock.count)")
print("Количество треков категории \"\(jazz.name)\": \(classic.count)")

jazz.printSelf()
poprock.printSelf()
classic.printSelf()

print("\n\t -- Удаление трека существующего и несуществующего -- ")
poprock.del(track: tracks[2])
// poprock.del(track: tracks[9]) // error: Execution was interrupted, reason: EXC_BREAKPOINT (code=1, subcode=0x18bc5923c).
print("Количество треков категории \"\(poprock.name)\": \(poprock.count)")
poprock.printSelf()


/*
Задача 2
Доработайте свою библиотеку так, чтобы в ней было несколько категорий.
Алгоритм выполнения:
Создайте класс библиотеки. Этот класс будет аналогичен классу категории, только хранить он должен список категорий.
 */
print("\n",line,"Task 2\n")

class MusicLibrary {
    var name: String
    lazy var list = [MusicCategory]()
    var count: Int {
        list.count
    }
    func ins(category: MusicCategory) {
        guard !list.contains(where: {$0.name == category.name}) else {
            print("не частите")
            return
        }
        list.append(category)
    }
    func del(category: MusicCategory) -> Bool {
        guard list.contains(where: {$0.name == category.name}) else {
            print("Нет такой категории")
            return false
        }
        list.removeAll{$0.name == category.name}
        print("Категория \"\(category.name)\" найдена и должна была быть удалена")
        return true
    }
    func printSelf() {
        print("Список категорий и треков в библиотеке \"\(name)\":")
        for category in list {
            print("Категория \(category.name)")
            category.printSelf()
        }
    }
    init(_ name: String) {
        self.name = name
    }
}
var myMorningMusic = MusicLibrary("Утреннее")
myMorningMusic.ins(category: jazz)
myMorningMusic.ins(category: poprock)
// вернём удалённый в задаче 1 трек
poprock.ins(track: tracks[2])
print("Количество музыкальных категорий в библиотеке:", myMorningMusic.count)
myMorningMusic.printSelf()
myMorningMusic.del(category: jazz)
print(" -- After deleting")
myMorningMusic.printSelf()


/*
Задача 3 * (задача со звездочкой):
Преобразуйте классы так, чтобы в пределах вашей библиотеки можно было обмениваться треками между категориями.
*/
print("\n",line,"Task 3\n")

// Преобразовывать классы не вышло. Только одни класс :)
class MusicLibrary2: MusicLibrary {
    func swapTrack(track: MusicTrack, from fromCategory: MusicCategory, to toCategory: MusicCategory ) {
        print("\n -- SWAP -- ")
        // при удалении трека проверяется его наличие в категории
        if fromCategory.del(track: track) {
            toCategory.ins(track: track)
        }
    }
}
var myEvningMusic = MusicLibrary2("Вечернее")
myEvningMusic.ins(category: jazz)
myEvningMusic.ins(category: poprock)
myEvningMusic.ins(category: poprock) // не частите
myEvningMusic.ins(category: classic)
print("Количество музыкальных категорий в библиотеке \"\(myEvningMusic.name)\":", myEvningMusic.count)
myEvningMusic.printSelf()
myEvningMusic.swapTrack(track: tracks[0], from: jazz, to: classic)
print("\n -- After swap -- ")
myEvningMusic.printSelf()
print("\n -- After del category -- ")
myEvningMusic.del(category: jazz)
myEvningMusic.del(category: poprock)
myEvningMusic.printSelf()


// Во время работы над этим ДЗ я ещё сделал вариант, когда в первой задаче удаление не возвращет Bool и при переопределении классов переопределял и методы удаления. Так же в сам начале делал версию с подверсиями для массивов, множеств и словарей. Пытался нащупать как лучше хратить треки. Везде были плюсы и минусы.
