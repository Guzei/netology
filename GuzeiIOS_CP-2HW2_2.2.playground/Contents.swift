
не доделано, т.к. вторая задача была неправильно понята и после уточнения коммитим и далее...

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
    case de = "Bundesrepublik Deutschland"
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
tracks.append(MusicTrack(trackName: "Лунная соната", artist: "Бетховен", duration: 300, country: .de))

// избыточные варианты для тренировки навыков при обучении
class MusicCategory {
    var categoryName: String = ""

    // Массив. Индекс ненадёжная вещь.
    lazy var listArray = [MusicTrack]() // В учебники смысл понятен -- отложенная тяжёлая инициализация, а тут получается просто в учебных целях.
    var countArray: Int {
        listArray.count
        // return - вроде не обязательно в этом случае
    }
    func insArray(track: MusicTrack) {
        if !listArray.contains(where: {$0.trackName == track.trackName}) {
            listArray.append(track)
        }
        else {
            print("не частите")
        }
    }
    func delArray(name: String) {
        if let i = listArray.firstIndex(where: {$0.trackName == name}) {
            listArray.remove(at: i)
        }
        else {
            print("Нет такого трека")
        }
    }

    // Теоретически можно добавить имена несуществующих треков. Это недостаток очень сильный.
    lazy var listSet = Set<String>()
    var countSet: Int {
        get {                   // чисто для разнообразия
            listSet.count
        }
    }
    func insSet(name: String) {
        let (b, name) = listSet.insert(name)
        if b {
            print("Добавлено: ", name)
        } else {
            print("есть уже")
        }
    }
    func delSet(name: String) {
        if listSet.contains(name) {
            listSet.remove(name)
        }
        else {
            print("No track named: \"\(name)\"")
        }
    }

    // Словарь треков. Храним сразу всю информацию. Ключ - имя трека делает невозможность повторов.
    lazy var listDic = [String: MusicTrack]() // all lazy not init
    var countDic: Int {
        listDic.count
    }
    func insDic(track: MusicTrack) {
        listDic[track.trackName] = track
    }
    func delDic(name: String) {
        listDic.removeValue(forKey: name) // ok or nill -- неважно
    }
}

var poprock = MusicCategory()
poprock.categoryName = "Поп-Рок"

print("\nArray\n")
// poprock.listArray = tracks  // так проще и даже с диапазонами играть можно, но в задании надо не так
// а так:
poprock.insArray(track: tracks[0])
poprock.insArray(track: tracks[1])
for track in poprock.listArray {
    print(track.trackName, track.artist, track.duration, track.country.rawValue)
}
for (index, track) in poprock.listArray.enumerated() {
    print(index, track.trackName, track.artist, track.duration, track.country.rawValue)
}
print("Количество треков в массиве категории ПопРок: \(poprock.countArray)")
poprock.delArray(name: "Ву а ля")
print("Количество треков в массиве категории ПопРок: \(poprock.countArray)")

print("\n\nSet\n")
poprock.insSet(name: tracks[0].trackName)
poprock.insSet(name: tracks[1].trackName)
poprock.insSet(name: tracks[1].trackName)
print("Количество треков в множестве категории ПопРок: \(poprock.countSet)")
// список в множестве скромный
print(poprock.listSet)
// и распечатка треков получается так
poprock.listSet.forEach{item in
    if let track = tracks.first(where: {$0.trackName == item}) {
        print(track.trackName, track.artist, track.duration, track.country.rawValue)
    }
}
poprock.delSet(name: "не существующее имя" )
poprock.delSet(name: tracks[0].trackName )
print("Количество треков в множестве категории ПопРок: \(poprock.countSet)")
print(poprock.listSet)

print("\n\nDic\n")
poprock.insDic(track: tracks[0])
poprock.insDic(track: tracks[1])
print("Количество треков в словаре категории ПопРок: \(poprock.countDic)")
//print(poprock.listDic.values)
poprock.listDic.forEach {name, track in
    print("Track name: \"\(name)\" and ones more track name \"\(track.trackName)\" from singer: \(track.artist) from \(track.country.rawValue) duration \(track.duration)")
}
poprock.delDic(name: tracks[1].trackName)
print("Количество треков в словаре категории ПопРок: \(poprock.countDic)")
poprock.delDic(name: "бред")
print("Количество треков в словаре категории ПопРок: \(poprock.countDic)")



/*
Задача 2
Доработайте свою библиотеку так, чтобы в ней было несколько категорий.
Алгоритм выполнения:
Создайте класс библиотеки. Этот класс будет аналогичен классу категории, только хранить он должен список категорий.
 */

// Предположим, что "аналогичен" не значит потомок, а просто похожий со списком категорий вместо названия категории. А иначе куда девать это название?
//class MusicLibraryNew {
//    var category = [MusicCategoryName: [String: MusicTrack]]()
//    var list = [String : MusicTrack]()
//    var count: Int {
//        list.count
//    }
//    func ins(track: MusicTrack) {
//        list[track.trackName] = track
////        category[name] = list
//    }
//    func del(name: String) {
//        list.removeValue(forKey: name)
//    }
//}
print("\n\nTask 2\n")

enum MusicCategoryName {
    case poprock, jazz, classic
    var name: String {
        switch self {
        case .poprock: return "Поп-Рок"
        case .jazz: return "Джаз"
        case .classic: return "Классика"
        }
    }
//    case poprock(nama: "Поп-Рок", trackList: [String: MusicTrack])
}

class MusicLibrary: MusicCategory {
    var categories = [MusicCategoryName: [String: MusicTrack]]()
    func insToCategories(categoryName: MusicCategoryName, track: MusicTrack) {
        categories[categoryName] = [track.trackName: track]
    }
}
var music = MusicLibrary()
tracks.forEach { track in
    music.insDic(track: track)
}
music.insToCategories(categoryName: .jazz, track: tracks[0])
music.insToCategories(categoryName: .poprock, track: tracks[1])
music.insToCategories(categoryName: .poprock, track: tracks[2])
music.insToCategories(categoryName: .classic, track: tracks[3])
music.categories.forEach { category in
    print("\(category.key): \(category.value)")
}


 /*
Задача 3 * (задача со звездочкой):
Преобразуйте классы так, чтобы в пределах вашей библиотеки можно было обмениваться треками между категориями.
*/
print("\n\nTask 3\n")
class MusicLibraryPlus: MusicLibrary {
    func swapTrack(newCategory: MusicCategoryName, track: MusicTrack ){
        categories[newCategory] = [track.trackName: track]
    }
}
var musicPlus = MusicLibraryPlus()
tracks.forEach { track in
//    print(track)
    musicPlus.insDic(track: track)
}
//print(musicPlus.listDic)
musicPlus.insToCategories(categoryName: .jazz, track: tracks[0])
musicPlus.insToCategories(categoryName: .poprock, track: tracks[1])
musicPlus.insToCategories(categoryName: .poprock, track: tracks[2])
musicPlus.insToCategories(categoryName: .classic, track: tracks[3])
musicPlus.categories.forEach { category in
    print("\(category.key): \(category.value)")
}
