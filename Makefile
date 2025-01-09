# Стандартное имя контейнера
CONTAINER_NAME = llcrm-dev-container
# Стандартное имя образа контейнера
IMAGE_NAME = llcrm-dev-image

# Стандартные параметры для проброса портов
PORTS = 8080:80
# Стандартные параметры для монтирования директрии с проектом
VOLUME = ./test.llcrm.ru:/app

# Параметр запуска контейнера (подразумевается замена стандартного -d флагами -it в целях отладки контейнера)
MODE = -d
# Флаги, подразумевающие свое использование при исполнении команды внутри контейнера
FLAGS = 
# Команда, подразумевающая свое исполнение внутри контейнера
COMMAND = 

# Псевдоцели для сборки
# При добавлении новой цели крайне рекомендуется добавлять ее в список
# Более подробное описание для .PHONY можно найти в интернете
.PHONY: all build run up clean clean-image clean-container stop start drop containers images connect permit exec

# Собрать образ
build: 
	sudo docker build -t $(IMAGE_NAME) .

# Запустить контейнер после сборки образа
run:
	sudo docker run $(MODE) --name $(CONTAINER_NAME) -v $(VOLUME) -p $(PORTS) $(IMAGE_NAME)

# Объединение сборки образа и запуска контейнера
up: build run

# Остановить запущенный контейнер
stop:
	sudo docker stop $(CONTAINER_NAME)

# Запустить остановленный контейнер
start:
	sudo docker start $(CONTAINER_NAME)

# Удалить контейнер
clean-container:
	sudo docker rm $(CONTAINER_NAME)

# Удалить образ
clean-image:
	sudo docker rmi $(IMAGE_NAME)

# Объединение удаления контейнера и образа
clean: clean-container clean-image

# Объединение остановки контейнера и удаления контейнера и образа
drop: stop clean

# Список всех контейнеров
containers:
	sudo docker ps --all

# Список всех образов
images:
	sudo docker images --all

# Подключиться к контейнеру через оболочку fish
connect:
	sudo docker exec -it $(CONTAINER_NAME) "fish"

# Выдать полное разрешение на R/W/E для всей рабочей директории
permit:
	sudo docker exec -it $(CONTAINER_NAME) /bin/sh /permit.sh

# Выполнить команду над контейнером
exec:
	sudo docker exec $(FLAGS) $(CONTAINER_NAME) $(COMMAND)
