# DloPI Management

DloPI — это скрипт для обхода блокировок интернет-ресурсов в России, таких как YouTube, Discord, а также сайтов, которые сами заблокировали доступ для пользователей из России, таких как ChatGPT и другие. Скрипт автоматически настраивает параметры обхода DPI и позволяет пользователю выбирать, какие сайты запускать с разблокировкой.

## Как использовать

1. **Запуск**:
   - Просто запустите файл `start.cmd`, и вам будут предложены несколько вариантов действий.

2. **Выбор настроек**:
   - После запуска скрипта вы увидите меню с несколькими опциями. Вы можете выбрать:
     - **Запуск обоих скриптов**: для обхода блокировок на всех поддерживаемых сайтах.
     - **Запуск отдельного скрипта**: для обхода блокировки только на одном из сайтов (например, только YouTube или только Discord).
     - **Остановку всех скриптов** и удаление их из автозагрузки.
     - **Запрос списка доменов**: автоматически загрузите список заблокированных доменов и сохраните его в файл `list-domains.txt`.

3. **Добавление собственных сайтов**:
   - Вы можете добавить свои сайты для обхода блокировок, отредактировав файл `list-custom-domains.txt`. В этот файл можно добавлять домены, доступ к которым нужно восстановить. Просто впишите каждый новый домен с новой строки.

## Возможности

- **Запрос актуального списка доменов**: С помощью скрипта можно получить актуальный список заблокированных доменов, и этот список будет автоматически использоваться для обхода блокировок.
- **Поддержка дополнительных доменов**: Помимо заранее настроенных сайтов, вы можете легко добавить свои собственные домены для разблокировки, просто отредактировав файл `list-custom-domains.txt`.
- **Обход ограничений сайтов, блокирующих доступ для пользователей из России**: Скрипт также помогает обходить блокировки со стороны сайтов, которые самостоятельно заблокировали доступ для пользователей из России. Примеры таких сайтов — ChatGPT и другие сервисы, которые ограничили доступ к своим ресурсам.

## Поддерживаемые сайты

- YouTube
- Discord
- Сайты, которые сами заблокировали доступ для пользователей из России, например:
  - ChatGPT
  - И другие сервисы, ограничившие доступ
- Ваши собственные сайты, добавленные в `list-custom-domains.txt`

## Требования

- Для корректной работы требуется запуск от имени администратора.
- PowerShell для создания ярлыков и запуска процессов в скрытом режиме.

## Примечания

- **list-custom-domains.txt** — сюда вы можете добавить свои домены для обхода блокировок.
- **list-domains.txt** — этот файл создается автоматически после запроса списка доменов и содержит домены для разблокировки, которые были заблокированы для пользователей из России.
- Скрипт автоматически проверяет наличие файлов с доменами и настраивает параметры DPI для их разблокировки.