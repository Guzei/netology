/*
 Домашнее задание к занятию 2.1. Классы и структуры. Перечисления

Задача 1

Представьте себя инженером проектировщиком телевизоров во времена, когда эпоха телевещания только набирала обороты. Вам поступила задача создать устройство для просмотра эфира в домашних условиях "Телевизор в каждую семью".

Вам нужно реализовать перечисление (enum) "Телевизионный канал" с 5-7 каналами.

Алгоритм выполнения

Реализуйте класс "Телевизор". У него должны быть состояния:
фирма/модель (реализовать одним полем. Подумайте какой тип данных подойдет?);
включен/выключен;
текущий телеканал;
У него должно быть поведение:
показать, что сейчас по телеку
Вызовите метод и покажите, что сейчас по телеку.
Сделайте изменение состояний телевизора (на свой выбор).
Повторите вызов метода и покажите, что сейчас по телеку.
*/

let line = "\n" + String(repeating: "-" as Character, count: 80) + "\n"

print("Task 1\n")
enum TvChannelName: String {
    case c1 = "First chenel"
    case c2 = "Cultura"
    case c3 = "News 24"
    case c4 = "Sport"
    case c5 = "2x2"
}

class TvBox {
    var isOn: Bool
    var tv: (manufacturer: String, model: String)
    var channel: TvChannelName

    func switchOnOff() {
        isOn = !isOn
    }
    func changeChannel(_ channel: TvChannelName) {
        self.channel = channel
    }
    func whatsOnTvNow() {
        if isOn {
            changeChannel(channel)
            print("TV shows channel: \(channel) (\(channel.rawValue))")
        }
        else
        {
            print("TV is off")
        }
    }
    init( isOn: Bool, manufacturer: String, model: String, channel: TvChannelName) {
        self.isOn = isOn
        tv.manufacturer = manufacturer
        tv.model = model
        self.channel = channel
    }
}
var lastChannel: TvChannelName = .c5
var myHomeTv = TvBox(isOn: false, manufacturer: "LG", model: "123", channel: lastChannel)

myHomeTv.whatsOnTvNow()
myHomeTv.switchOnOff()
print("Well, well, well. You turned off the TV \(myHomeTv.tv.manufacturer).\(myHomeTv.tv.model) on the channel: \(myHomeTv.channel) (\(myHomeTv.channel.rawValue))")
myHomeTv.changeChannel(.c2)
myHomeTv.whatsOnTvNow()
myHomeTv.changeChannel(.c3)
myHomeTv.whatsOnTvNow()
if (myHomeTv.isOn) {
    print("Don't forget to turn off the TV")
    myHomeTv.switchOnOff()
}
lastChannel = myHomeTv.channel

/*
Задача 2

Время идет, рынок и потребители развиваются, и ваша компания набирает ритм. Поступают все новые и новые требования к эволюции устройств. Перед вами снова инженерная задача — обеспечить пользователей практичным устройством.

Алгоритм выполнения

Создайте новый класс Телевизор (с другим названием класса), который будет уметь все, что и предыдущий.

Реализуйте структуру настроек (struct):

громкость от 0 до 1, то есть могут быть промежуточные значения. (подумайте, какой тип использовать); показывать цветом или черно-белым (подумайте, какой тип данных лучше всего использовать).

Интегрируйте Настройки в новый класс Телевизор.

Переопределите метод "что сейчас по телеку" из класса родителя. Вызовите метод и покажите, что сейчас идет по телевизору, учитывая настройки.
*/
print("\n\(line)Task 2\n")

struct TvSettings {
    var isColor: Bool
    var volumeLevel: Double
}

class NewTvBox: TvBox {
    var settings = TvSettings(isColor: true, volumeLevel: 0.5)
    override func whatsOnTvNow() {
        super.whatsOnTvNow()
        if isOn {
            print("with level of volume \(settings.volumeLevel) and in \(settings.isColor ? "color" : "b&w")")
        }
    }
}

var myNewTv = NewTvBox(isOn: false, manufacturer: "LG", model: "234", channel: lastChannel)
print("New TV model: \(myNewTv.tv.manufacturer).\(myNewTv.tv.model)")

myNewTv.whatsOnTvNow()
myNewTv.switchOnOff()
myNewTv.whatsOnTvNow()
myNewTv.settings = TvSettings(isColor: false, volumeLevel: 0.1)
myNewTv.changeChannel(.c4)
myNewTv.whatsOnTvNow()
lastChannel = myNewTv.channel

/*
Задача 3 * (задача со звездочкой):

Порог новой эры пройден. Теперь не только есть радиоволна, но и видеомагнитофоны. Эту технику подключают проводами к телевизору и смотрят в записи свои любимые фильмы. Вам, как ведущему инженеру, срочно нужно адаптировать продукт вашей компании, потому как спрос на устаревший вариант резко пошел вниз.

Алгоритм выполнения

Создайте перечисление со связанными значениями с двумя кейсами: телеканал и подключение по входящему видео порту;
Интегрируйте эту опцию в Телевизор.
Вызовите метод и покажите, что сейчас по телевизору.
*/
print("\n\(line)Task 3\n")

enum Source {
    case tv(tvChannel: TvChannelName)
    case video(record: String)
}

class TvVideo: NewTvBox {
    var source: Source
    func print_if() {
        if case Source.tv(_) = source {
            super.whatsOnTvNow()
        }
        else if case let Source.video(video) = source {
            print("New option! Video! \"\(video)\"")
        }
        else {
            print("Was ist das?")
        }
    }
    func print_case() {
        switch source {
        case .tv:
            super.whatsOnTvNow()
        case .video(let video):
            print("video: \(video) with level of volume \(settings.volumeLevel) and in \(settings.isColor ? "color" : "b&w")")
        }
    }
    init(source: Source) {
        self.source = source
        super.init(isOn: false, manufacturer: "LG", model: "345", channel: lastChannel)
    }
}

var tvVideo = TvVideo(source: .tv(tvChannel: lastChannel)) // масло масляное вышло :(
print("IF\n")
tvVideo.print_if()
tvVideo.switchOnOff()
tvVideo.print_if()
tvVideo = TvVideo(source: .video(record: "Avatar 2"))
tvVideo.print_if()
print("\nCASE\n")
tvVideo.settings = TvSettings(isColor: false, volumeLevel: 0.1)
tvVideo.print_case()
tvVideo = TvVideo(source: .tv(tvChannel: .c4))
tvVideo.print_case()
tvVideo.switchOnOff()
tvVideo.print_case()

// test to GIT
// test form GIT

