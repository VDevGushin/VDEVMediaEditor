//
//  ModeratecontentOperation.swift
//  Network
//
//  Created by Vladislav Gushin on 08.12.2022.
//

import Foundation

struct ModeratecontentOperation: ApiOperation {
    typealias Response = ModeratecontentResponse

    let text: String = """
Сучка
Сука
Пизденка
Абляпездл
Ебеня
Абляудок
Хуепутало
Вжопуклянченко
Вротпопрошайка
Раньше люди ели сало,
Hо ебались очень мало.
А теперь живут не емши,
Hо ебутся ошалемши.
Ууух
Начинаем представленье
Начинаем песни петь
Разрешите для начала
На хуй валенок одеть
Как в Ивановском совхозе
Девок жарят на навозе
Их ебут они пердят
Брызги в сторону летят
Я у тещи был в гостях-
Переменна пища:
Утром-хуй, в обед-хуина
Вечером-хуища!
Как за печкой, за трубой
Пизда шлепала губой.
Отчего зашлёпала?
Большого хуя слопала!
Как у нашего попа,
У попа, у Прошки.
Оторвали девки хуй,
Hосят вместо брошки!
Тискал девку Анатолий
Hа бульваре на Тверском,
Hо ебать не соизволил:
Слишком мало был знаком.
"""
    
    var path: String = "/text"
    var method: HTTPMethod { .get }

    var params: [String : String] {
        [
            "exclude": "ho,hell",
            "replace": "******",
            "key": "96f3c1499836a9b2065a5e0706c707d1",
            "msg": text
        ]
    }

    var host: String? { "api.moderatecontent.com" }
    var token: String?

    struct ModeratecontentResponse: Codable {
        let origionalMsg: String
        let clean: String
        let exclude: [String]
        let badWords: [String]

        enum CodingKeys: String, CodingKey {
            case origionalMsg = "origional_msg"
            case clean, exclude
            case badWords = "bad_words"
        }
    }
}
