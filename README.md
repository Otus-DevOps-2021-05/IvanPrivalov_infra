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


