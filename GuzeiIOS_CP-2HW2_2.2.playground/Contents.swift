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
enum Countries: String {
    case ru = "Российская Федерация"
    case us = "USA"
    case fr = "République française"
}
enum CategoryName {
    case poprock
    case jazz
    case classic
}

struct musicTrack {
    var name: String
    var artist: (name: String?, lastName: String?, nickName: String)
    var duration: Int
    var country: Countries
}

class Category {
    let name: CategoryName
    // Множество неупорядоченных уникальных имён треков. Сами треки могут браться по этим именам.
    var listSet = Set<String>()
    // Словарь треков. Храним свразу всю информацию.
    var listDic: [String: musicTrack] = [:]
    var countSet: Int {
        listSet.count
    }
    var countDic: Int {
        listDic.count
    }
    func insSet(name: String) {
        listSet.insert(name)
    }
    func insDic(track: musicTrack) {
        listDic[track.name] = track
    }
    func delSet(name: String) {
        listSet.remove(name)
    }
    func delDic(name: String) {

    }
    init(_ name: CategoryName) {
        self.name = name
    }
}

var track1 = musicTrack(name: "n1", artist: (nil, nil, "Pogonialo"), duration: 33, country: .us)
var track2 = musicTrack(name: "n2", artist: ("Vasilii", "Ivanov", "Vasia Pupkin"), duration: 77, country: .ru)

var poprock = Category(.poprock)

poprock.insSet(name: track1.name)
poprock.insSet(name: track2.name)
poprock.countSet
if (poprock.listSet.contains("n1")) {
    print(track1)
}
poprock.delSet(name: track1.name )
poprock.countSet

poprock.insDic(track: track2)
poprock.listDic["n1"]
poprock.insDic(track: track1)
poprock.listDic["n1"]
poprock.countDic
poprock

// tracks.
// print(tracks)

//Определите методы добавления и удаления треков в эту категорию.

/*
Задача 2

Доработайте свою библиотеку так, чтобы в ней было несколько категорий.

Алгоритм выполнения

Создайте класс библиотеки. Этот класс будет аналогичен классу категории, только хранить он должен список категорий.
 */



 /*
Задача 3 * (задача со звездочкой):

Преобразуйте классы так, чтобы в пределах вашей библиотеки можно было обмениваться треками между категориями.
*/


