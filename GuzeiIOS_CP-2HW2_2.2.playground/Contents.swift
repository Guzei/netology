/*
 Домашнее задание к занятию 2.2. Свойства и методы

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


class MusicCategoryList {
    var name: String
    lazy var list = [MusicTrack]()
    var count: Int {
        list.count
    }
    func ins(track: MusicTrack) {
        if !list.contains(where: {$0.trackName == track.trackName}) {
            list.append(track)
        }
        else {
            print("не частите")
        }
    }
    func del(trackName: String) {
        if let i = list.firstIndex(where: {$0.trackName == trackName}) {
            list.remove(at: i)
        }
        else {
            print("Нет такого трека")
        }
    }
    init(name: String) {
        self.name = name
    }
}

var poprock = MusicCategoryList(name: "Поп-Рок")
tracks.forEach{ track in
    poprock.ins(track: track)
}
print("Список треков в категории. Вариант 1:")
poprock.list.forEach { track in
    print(track.trackName, track.artist, track.duration, track.country.rawValue)
}
print("\nСписок треков в категории. Вариант 2:")
for (index, track) in poprock.list.enumerated() {
    print(index, track.trackName, track.artist, track.duration, track.country.rawValue)
}
print("Количество треков в массиве категории ПопРок: \(poprock.count)")
poprock.del(trackName: "Balance Ton Quoi")
poprock.del(trackName: "бред")
print("Количество треков в массиве категории ПопРок: \(poprock.count)")


/*
Задача 2
Доработайте свою библиотеку так, чтобы в ней было несколько категорий.
Алгоритм выполнения:
Создайте класс библиотеки. Этот класс будет аналогичен классу категории, только хранить он должен список категорий.
 */
print("\n\nTask 2\n")

enum MusicCategory: String, CaseIterable {
    case poprock = "Поп-Рок"
    case jazz = "Джаз"
    case classic = "Классика"
}
class MusicLibrary {
    var library = [MusicCategory: [MusicTrack]]()
    var count: Int {
        var sum = 0
        library.forEach { (_, list) in
     // for (_, list) in library {          // не понял ещё какая запись мне больше нравится :)
            sum += list.count
        }
        return sum
    }
    // нет предела совершенству. Можно ещё счётчики по категориям делать и ...
    func ins(category: MusicCategory, track: MusicTrack) {
        // Инициализатор гарантирует наличие необходимого и можно форсить для краткости
        guard !library[category]!.contains(where: {$0.trackName == track.trackName}) else {
            print("не частите")
            return
        }
        library[category]!.append(track)
    }
    func del(trackName: String) {
        // library.forEach { (category, list) in
        for (category, list) in library { // похоже так нагляднее из-за более видимой скобки в конце
            if let index = list.firstIndex(where: {$0.trackName == trackName}) {
                library[category]!.remove(at: index)
                print("Трек удалён")
                // А вот и нюанс! return по-разному работает при forEach и при for
                return
            }
        }
        print("Нет трека \"\(trackName)\" ни в одной из категорий")
    }
    func printSelf() {
        for (caterory, list) in library {
            print("Категория: \(caterory)")
            for track in list {
                print("\tName: \(track.trackName); Artist: \(track.artist); Duration: \(track.duration); From: \(track.country.rawValue)")
            }
        }
    }

    // Дабы гарантировать существование всех ключей и начальных пустых массивов для списка треков в словаре:
    init() {
        MusicCategory.allCases.forEach { category in
            library.updateValue([], forKey: category)
        }
    }
}

var music = MusicLibrary()
music.ins(category: .poprock, track: tracks[1])
music.ins(category: .poprock, track: tracks[2])
music.ins(category: .jazz, track: tracks[0])
//music.ins(category: .old, track: tracks[0])   // не пройдёт // Type 'MusicCategory' has no member 'old'
music.count // 3
music.del(trackName: "Плачешь")
music.del(trackName: "нечто")
music.count // 2
music.printSelf()


 /*
Задача 3 * (задача со звездочкой):
Преобразуйте классы так, чтобы в пределах вашей библиотеки можно было обмениваться треками между категориями.
*/
print("\n\nTask 3\n")

class MusicLibraryPlus: MusicLibrary {
    func swapTrack(fromCategory: MusicCategory, toCategory: MusicCategory, track: MusicTrack ){
        var list = library[fromCategory]!
        if let index = list.firstIndex(where: {$0.trackName == track.trackName}) {
            list.remove(at: index)
            library.updateValue(list, forKey: fromCategory)
            library[toCategory]! += [track]
        }
        else {
            print("No track \"\(track.trackName)\" in \"\(fromCategory)\"")
        }
    }
}
var musicPlus = MusicLibraryPlus()
musicPlus.ins(category: .poprock, track: tracks[1])
musicPlus.ins(category: .poprock, track: tracks[2])
musicPlus.ins(category: .jazz, track: tracks[0])
musicPlus.count
musicPlus.printSelf()

musicPlus.swapTrack(fromCategory: .poprock, toCategory: .classic, track: tracks[0])
musicPlus.swapTrack(fromCategory: .jazz, toCategory: .classic, track: tracks[0])
musicPlus.count
print("--")
musicPlus.printSelf()
