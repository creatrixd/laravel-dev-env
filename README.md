# Laravel development environment
# Руководство к использованию

### Окружение создано с целью упрощения запуска и разработки приложения на локальном компьютере.

Требования для автоматизированной установки:
- Linix distro / Windows + Linux Distro WSL

**Для начала установки необходимо открыть текущий репозиторий в linux/linux WSL терминале**

Автоматизированная установка:
```shell
sh i-am-dummy.sh
```
> [!ERROR] ВАЖНО: в случае получения странной ошибки при запуске команды и(или) при получении криво отформатированного сообщения об ошибке, необходимо изменить символы концов строки с CRLF на LF, который правильно распознаются sh.
Существует 2 основных варианта решения проблемы:
- Открыть репозиторий в редакторе кода и изменить символы концов строки у файла .sh через интерфейс редактора
- Воспользоваться предустановленной в подавляющее большинство unix-like операционных систем утилитой sed (в случае работы через WSL утилита также будет доступна через терминал WSL)

```shell
sed 's/\r$//' i-am-dummy.sh > temp.txt && cat temp.txt > i-am-dummy.sh && rm temp.txt
```

После установки необходимо проверить корректность установленного ПО:
```shell
docker -v
make -v
```

> В случае получения сообщения о неизвестной команде, означающей непредвиденную ошибку во время установки, следует повторить процесс установки, либо установить компоненты вручную (вся информация есть в интернете на первых страницах), все необходимые компоненты указаны в требованиях к развертыванию

> Git автоматически не устанавливается, поскольку работа с ним подразумевается с системы-хоста, а не из WSL и, темболее (к слову), не из контейнера.

### Требования к развертыванию окружения
- Docker
- Git
- Make

### Окружение использует следующий набор технологий:
- PHP 8.2 + fpm (Сервирование приложения в многопоточном режиме)
- Nginx (Обеспечение FastCGI проксирования)
- Supervisor (Поддержка одновременной работы PHP-fpm и nginx)
- Sqlite (Хранилище данных приложения)
- Laravel (Основной backend фреймворк)
- Node (Среда для сборки frondend)
- Nano (Консольный текстовый редактор)
- fish (Командная оболочка для более удобной работы внутри контейнера)

Предполагается использование утилиты [make](https://ru.wikipedia.org/wiki/Make). В случае использования системы windows/работы через Docker Desktop все операции также можно выполнять и через графический интерфейс. С доступными командами можно ознакомиться в файле [Makefile](Makefile).

---
### Базовое использование:
Перед запуском окружения необходимо скопировать рабочий проект в папку project (имя можно изменить в Makefile параметре VOLUME).

Установка зависимостей подразумевается после запуска контейнера изнутри него.
```shell
make up         # Сборка образа, запуск контейнера на базе образа   
make connect    # Подключение к оболочке fish внутри контейнера
make drop       # Остановка контейнера, удаление контейнера, удаление образа
make permit     # Выдача полных прав на редактирование рабочей директории (см. 3 пункт раздела Базовые принципы)
```
---

### Базовые принципы:
- Во избежания проблем со сборкой образа, запуском контейнера и работой приложения не рекомендуется изменение файлов Dockerfile, nginx.conf, supervisord.conf.
- Подразумевается возможность редактирования Makefile под свои потребности и добавления новых команд.
- Допускается замена утилиты make на любую другую, которая обеспечит быстрое управление окружением, или полный отказ от вспомогательных утилит и выполнение каждой команды вручную или через GUI приложения, например, через Docker Desktop.
- Из-за особенностей работы с томами (volumes) изнутри контейнера возникает проблема невозможности изменения файлов. Для этого добавлена команда **make permit**, которая переписывает права и разрешает любые действия в рабочей директории в контейнере. Данная проблема была встречена только при попытке изменения файлов при работе на Linux машине, либо при изменении файлов напрямую через WSL при работе на Windows машине (например при выполнении команды *rm -rf* из терминала WSL). При работе с директорией напрямую из Windows (например при сохранении файлов из редакторов кода/IDE, запущенных на Windows машине) проблема замечена не была.
---

### Переопределение параметров
При использовании make можно переопределять параметры, содерщащиеся внутри Makefile, чтобы изменять поведение команд, с помощью следующего синтаксиса:
```shell
make build IMAGE_NAME=some_other_image_name
```
