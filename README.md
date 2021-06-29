# Домашнее задание №4
____

## В ДЗ сделано:
____


    1. Установлен и настроен yc CLI для работы с аккаунтом Yandex Cloud;
    2. Создан инстанс с помощью CLI;
    3. Установклен на хост ruby, mongodb для работы приложения, деплой тестового приложения;
    4. Созданы bash-скрипты для установки на хост необходимых пакетов и деплоя приложения;
    5. Создан startup-сценарий init-cloud для автоматического деплоя приложения после создания хоста. Данные для проверки деплоя приложения:

```shell

testapp_IP=217.28.230.170
testapp_port=9292

```

## Основное задание

____

Созданы bash-скрипты для деплоя приложения:

    1. Скрипт install_ruby.sh содержит команды по установке Ruby;
    2. Скрипт install_mongodb.sh содержит команды по установке MongoDB;
    3. Скрипт deploy.sh содержит команды скачивания кода, установки зависимостей через bundler и запуск приложения.

Для создания инстанса используется команда:

```shell

yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=otus-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --ssh-key ~/.ssh/appuser.pub

```

## Дополнительное задание

____

Создан файл metadata.yaml (startup-сценарий init-cloud), используемый для provision хоста после его создания. Для создания инстанса и деплоя приложения используется команда (запускаем из директории где лежит metadata.yaml):

```shell

yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=otus-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --metadata-from-file user-data=./metadata.yaml

```

Подключение к хосту выполняем командой:

```shell

ssh yc-user@217.28.230.170

```

# Домашнее задание №3
____

## Решение
____

Адреса хостов:

```shell

bastion_IP = 217.28.229.184
someinternalhost_IP = 172.16.0.29

```

1.Создаем на локальном хосте файл *config* в каталоге ~/.ssh

2.Добавляем в него следующую конфигурацию ssh:

```shell

# bastion
Host bastion
   HostName 217.28.229.184
   User appuser
   IdentityFile ~/.ssh/appuser

# someinternalhost
Host someinternalhost
   HostName 172.16.0.29
   User appuser
   IdentityFile ~/.ssh/appuser
   ProxyJump appuser@217.28.229.184

```

3.Подключаемся к someinternalhost по алиасу, используя ProxyJump через bastion:

```shell

ssh someinternalhost

```

<details>
  <summary>Пример вывода:</summary>
```
otus@otus-VirtualBox:~/.ssh$ ssh someinternalhost
The authenticity of host '172.16.0.29 (<no hostip for proxy command>)' can't be established.
ECDSA key fingerprint is SHA256:dfpr2X/5nNa7jUi9s4kGQbUMvW23Gs51QRrSxONAEJk.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '172.16.0.29' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

Last login: Tue Jun 22 10:11:32 2021 from 172.16.0.22
appuser@someinternalhost:~$ hostname
someinternalhost
appuser@someinternalhost:~$ 

otus@otus-VirtualBox:~/.ssh$ ssh bastion
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Last login: Tue Jun 22 10:11:24 2021 from 91.197.107.129
appuser@bastion:~$ hostname
bastion
appuser@bastion:~$ 
```


