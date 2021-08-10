# Домашнее задание №10
____

## В ДЗ сделано:
____

1. Cоздал ansible-роли app, db для тестового приложения reddit.

```shell

cd ansible
mkdir roles
cd roles
ansible-galaxy init app
ansible-galaxy init db

```

2. Плейбуки app.yml, db.yml вместе с шаблонами и файлами из ДЗ №9 перенес в роли.

3. Установил коммюнити роль nginx:

```shell

cd ansible/roles
ansible-galaxy install -r environments/stage/requirements.yml

```

Теперь актуальные плейбуки имеют вид:

ansible/playbooks/app.yml

```shell

- name: Configure App
  hosts: app
  become: true
  roles:
    - app
    - jdauphant.nginx

```

```shell

ansible/playbooks/db.yml

- name: Configure MongoDB
  hosts: db
  become: true
  roles: 
    - db

```    

4. В каталоге environments создал папки окружений stage и prod.
Указал в них инвентори и создал необходимые папки и файлы (в group-vars храним переменные).
Структура каталога:

```shell

├── environments
│   ├── prod
│   │   ├── credentials.yml
│   │   ├── group_vars
│   │   │   ├── all
│   │   │   ├── app
│   │   │   └── db
│   │   ├── inventory
│   │   └── requirements.yml
│   └── stage
│       ├── credentials.yml
│       ├── group_vars
│       │   ├── all
│       │   ├── app
│       │   └── db
│       ├── inventory
│       └── requirements.yml

``` 

5. Создал новый плейбук ansible/playbooks/users.yml для создания пользователя admin на всех серверах.

6. Зашифровал ключом ansible-vault файлы credentials.yml, в которых содержатся пароли пользователей:

```shell

# создать файл ключа с паролем для шифрования
echo "somepass" > vault.key
# шифруем ключом файлы
ansible-vault encrypt environments/stage/credentials.yml
ansible-vault encrypt environments/prod/credentials.yml
# расшифровать
ansible-vault decrypt environments/stage/credentials.yml
ansible-vault decrypt environments/prod/credentials.yml

``` 

Путь к файлу ключа указал в ansible.cfg

```shell

[defaults]
inventory = ./environments/stage/inventory
remote_user = ubuntu
private_key_file = ~/.ssh/id_rsa
host_key_checking = False
retry_files_enabled = False
roles_path = ./roles
vault_password_file = vault.key

[diff]
# Включим обязательный вывод diff при наличии изменений и вывод 5 строк контекста
always = True
context = 5

```

7. Главный плейбук для запуска теперь имеет вид:

```shell

---
- import_playbook: db.yml
- import_playbook: app.yml
- import_playbook: deploy.yml
- import_playbook: users.yml

```

8. Старые файлы перенесены в каталог ansible/old, плейбуки в ansible/playbooks

9. Структура каталогов ansible в итоге выглядит следующим образом:

```shell

.
├── ansible.cfg
├── environments
│   ├── prod
│   │   ├── credentials.yml
│   │   ├── group_vars
│   │   │   ├── all
│   │   │   ├── app
│   │   │   └── db
│   │   ├── inventory
│   │   └── requirements.yml
│   └── stage
│       ├── credentials.yml
│       ├── group_vars
│       │   ├── all
│       │   ├── app
│       │   └── db
│       ├── inventory
│       └── requirements.yml
├── old
│   ├── files
│   │   └── puma.service
│   ├── inventory.json
│   ├── inventory.sh
│   ├── inventory.yml
│   └── templates
│       ├── db_config.j2
│       └── mongod.conf.j2
├── playbooks
│   ├── app.yml
│   ├── clone.yml
│   ├── db.yml
│   ├── deploy.yml
│   ├── packer_app.yml
│   ├── packer_db.yml
│   ├── reddit_app_multiple_plays.yml
│   ├── reddit_app_one_play.yml
│   ├── site.yml
│   └── users.yml
├── requirements.txt
├── roles
│   ├── app
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   │   └── puma.service
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── README.md
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   │   └── db_config.j2
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   ├── db
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── README.md
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   │   └── mongod.conf.j2
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   └── jdauphant.nginx
│       ├── ansible.cfg
│       ├── defaults
│       │   └── main.yml
│       ├── handlers
│       │   └── main.yml
│       ├── meta
│       │   └── main.yml
│       ├── README.md
│       ├── tasks
│       │   ├── amplify.yml
│       │   ├── cloudflare_configuration.yml
│       │   ├── configuration.yml
│       │   ├── ensure-dirs.yml
│       │   ├── installation.packages.yml
│       │   ├── main.yml
│       │   ├── nginx-official-repo.yml
│       │   ├── remove-defaults.yml
│       │   ├── remove-extras.yml
│       │   ├── remove-unwanted.yml
│       │   └── selinux.yml
│       ├── templates
│       │   ├── auth_basic.j2
│       │   ├── config_cloudflare.conf.j2
│       │   ├── config.conf.j2
│       │   ├── config_stream.conf.j2
│       │   ├── module.conf.j2
│       │   ├── nginx.conf.j2
│       │   ├── nginx.repo.j2
│       │   └── site.conf.j2
│       ├── test
│       │   ├── custom_bar.conf.j2
│       │   ├── example-vars.yml
│       │   └── test.yml
│       ├── Vagrantfile
│       └── vars
│           ├── Debian.yml
│           ├── empty.yml
│           ├── FreeBSD.yml
│           ├── main.yml
│           ├── RedHat.yml
│           └── Solaris.yml
└── vault.key

```

## Запуск проекта
____

После деплоя приложение должно быть доступно по адресам:

http://178.154.246.251:9292/ (основной порт приложения)
http://178.154.246.251/ (http-проксирование с nginx port 80 -> port 9292)
На всех серверах должен быть создан пользователь admin с паролем из своего окружения.

# Домашнее задание №9
____

## В ДЗ сделано:
____

В задании выполняется деплой тестового приложения reddit с помощью ansible-playbook на инстансах, созданных через terraform в YaCloud.
Вместо пользователя appuser указан ubuntu (т.к. в прошлых ДЗ публичный ключ пробрасывался для ubuntu, он и присутствует в системе).
На инстансе appserver репозиторий приложения клонируется в каталог пользователя ubuntu: /home/ubuntu.

## Основное задание
____

1. Запустил инфраструктуру terraform из окружения stage, описанную в ДЗ №6:

```shell

cd terraform/stage
terraform plan
terraform apply

```

2. Создал playbook reddit_app_one_play.yml с одним сценарием.

3. Создал шаблоны конфигов в каталоге templates: mongod.conf.j2, db_config.j2

4. Создал в каталоге files файл юнита puma.service.
Копируется на инстанс appserver в профиль пользователя ubuntu (куда деплоится приложение).

5. На основе reddit_app_one_play.yml создал playbook reddit_app_multiple_plays.yml с разбивкой на несколько сценариев. Названия тэгов и секция become: true указаны здесь для каждого сценария.

6. Далее вынес сценарии из reddit_app_multiple_plays.yml в отдельные плейбуки, из которых удалена секция tags: db.yml, app.yml, deploy.yml.

7. Создал файл основного playbook site.yml, в котором описывается управление всей конфигурацией инфраструктуры site.yml.

8. Изменил провижининг в Packer, создал плэйбуки ansible/packer_app.yml и ansible/packer_db.yml.

9. Заменил секцию Provision в образе packer/app.json и packer/db.json на Ansible.

10. Выполнил билд образов с использованием нового провижинера.

```shell

packer build -var-file=./variables.json ./app.json

==> Builds finished. The artifacts of successful builds are:
--> yandex: A disk image was created: reddit-app-1628239067 (id: fd8vn7c49v8t9t4fllbc) with family name reddit-base

packer build -var-file=./variables.json ./db.json

==> Builds finished. The artifacts of successful builds are:
--> yandex: A disk image was created: reddit-db-1628239737 (id: fd8t5g8ukshdpv5qpkmi) with family name reddit-base

```

11. На основе созданных app и db образов запустите stage окружение.

```shell

terraform apply -auto-approve=false

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_app = "178.154.231.2"
external_ip_address_db = "178.154.240.229"

```

12. Запустил плэйбук site.yml и проверил работу приложения.

```shell

ansible-playbook site.yml --check
ansible-playbook site.yml

PLAY RECAP *******************************************************************************************************************************************
appserver                  : ok=9    changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
dbserver                   : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

13. Проверка деплоя приложения: http://178.154.231.2:9292/

# Домашнее задание №8
____

## В ДЗ сделано:
____

    1. Установил ansible на локальной машине.
    2. Запустил инфраструктуру terraform из окружения stage, описанную в прошлом ДЗ.
    3. Создал конфигурационный файл ansible.cfg с необходимыми параметрами:

```shell

[defaults]
inventory = ./inventory, inventory.sh
remote_user = ubuntu
private_key_file = ~/.ssh/id_rsa
host_key_checking = False
retry_files_enabled = False

```
    4. Создал файлы статического инвентори, inventory и inventory.yml

inventory:

```shell

[app]
appserver ansible_host=178.154.241.146

[db]
dbserver ansible_host=178.154.222.132

```

inventory.yml

```shell

app:
  hosts:
    appserver:
      ansible_host: 178.154.241.146
db:
  hosts:
    dbserver:
      ansible_host: 178.154.222.132

```

    5. Создал и выполнил playbook:

clone.yml

```shell

---
- name: Clone
  hosts: app
  tasks:
    - name: Clone repo
      git:
        repo: https://github.com/express42/reddit.git
        dest: /home/ubuntu/reddit

```

После выполнения playbook проверяем результат:

```shell

otus@otus-VirtualBox:~/Desktop/IvanPrivalov_infra/ansible$ ansible-playbook clone.yml

PLAY [Clone] *****************************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 16.04 on host appserver should use /usr/bin/python3, but is using /usr/bin/python for backward 
compatibility with prior Ansible releases. A future Ansible release will default to using the discovered platform python for this host. See 
https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 
2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [appserver]

TASK [Clone repo] ************************************************************************************************************************************
ok: [appserver]

PLAY RECAP *******************************************************************************************************************************************
appserver                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

Изменений нет changed=0, т.к ansible поддерживает идемпотентность. Поскольку ожидаемый результат уже был достигнут на удаленном хосте, сценарий повторно не выполнился.

Удалим каталог коммандой ansible app -m command -a 'rm -rf ~/reddit' и запустим заного playbook.

```shell

otus@otus-VirtualBox:~/Desktop/IvanPrivalov_infra/ansible$ ansible-playbook clone.yml

PLAY [Clone] *****************************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 16.04 on host appserver should use /usr/bin/python3, but is using /usr/bin/python for backward 
compatibility with prior Ansible releases. A future Ansible release will default to using the discovered platform python for this host. See 
https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 
2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [appserver]

TASK [Clone repo] ************************************************************************************************************************************
changed: [appserver]

PLAY RECAP *******************************************************************************************************************************************
appserver                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

Теперь изменения будут отображены при выводе: changed=1

## Задание со *

Приложен bash-скрипт inventory.sh - во время выполнения формирует динамически список хостов для Ansible (динамический инвентори). IP-адреса определяются в соответствии с названиями инстансов в YaCloud, созданными ранее через terraform: reddit-app, reddit-db.

Создан файл inventory.json

Его создание выполнил командой:

```shell

./inventory.sh --list > inventory.json

```

Скрипт добавил в ansible.cfg, чтобы постоянно не ссылаться на него при запуске Ansible.

```shell

inventory = ./inventory, inventory.sh

```

После этого проверил доступность всех хостов, указанных в статическом и динамическом инвентори командой ansible all -m ping

```shell

otus@otus-VirtualBox:~/Desktop/IvanPrivalov_infra/ansible$ ansible all -m ping
178.154.222.132 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
dbserver | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
appserver | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
178.154.241.146 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}

```

### Отличия схем JSON для динамического и статического инвентори

Имеются отличия в синтаксисе файлов, например в JSON динамического инвентори хосты перечисляются в квадратных скобках. Кроме того, в динамическом инвентори используется секция _meta, которой нет в статическом инвентори.
# Домашнее задание №7
____

## В ДЗ сделано:
____

    1. Удалены результаты выполнения предыдущего ДЗ со звездочкой
    2. База данных и приложения вынесены на отдельные инстансы
    3. Конфигурация разделена по файлам
    4. Добавлены отдельные модули для DB и app
    5. Созданы окружения для stage и prod

## В ДЗ выполняется:
____

1. Cоздание сетевых ресурсов - yandex_vpc_network, yandex_vpc_subnet и инстанса - yandex_compute_instance, определенных в файле main.tf. Для того, чтобы сетевые ресурсы с IP-адресами создались до инстанса, используется неявная зависимость.

2. В каталоге packer созданы 2 новых шаблона:
db.json для сборки образа reddit-db-base (содержит mongodb).

```shell

packer validate -var-file=./variables.json ./db.json
packer build -var-file=./variables.json ./db.json

```

app.json для сборки образа reddit-app-base (содержит ruby).

```shell

packer validate -var-file=./variables.json ./app.json
packer build -var-file=./variables.json ./app.json

```

app.tf - создается инстанс из образа reddit-app-base
db.tf - создается инстанс из образа reddit-db-base
vpc.tf - создается сетевой ресурс.
В outputs.tf добавлены nat адреса инстансов

3. После запуска инфраструктуры в следующем задании db.tf, app.tf, vpc.tf были удалены.

    - созданы модули в каталоге modules (конфиги лежат в каталогах app, db, vpc)

    - Файл main.tf, в котором вызываются модули, а также переменные лежат в каталогах для разных окружений - stage и prod

Для загрузки модулей необходимо перейти в stage и prod и выполнить комманду:

```shell

# инциализация terraform в новом каталоге
terraform init
# загрузка модулей (если были изменения)
terraform get

```

Модули будут загружены в директорию .terraform, в которой уже содержится провайдер Yandex Cloud.

```shell

otus@otus-VirtualBox:~/Desktop/IvanPrivalov_infra/terraform$ tree .terraform
.terraform
├── modules
│   └── modules.json
└── providers
    └── registry.terraform.io
        └── yandex-cloud
            └── yandex
                └── 0.61.0
                    └── linux_amd64
                        ├── CHANGELOG.md
                        ├── LICENSE
                        ├── README.md
                        └── terraform-provider-yandex_v0.61.0


```

4. Конфигурационный файлы отредактированы коммандой

```shell

terraform fmt

```

5. Проверим сборку VM для stage и prod - terraform apply, и удаление terraform destroy.
____
# Домашнее задание №6
____

## В ДЗ сделано:
____

    1. Настроены конфигурационные файлы Terraform и отработано создание VM.
    2. Работа с Provisioners - деплой тестового приложения.
    3. Вынос переменных в Inputs vars

____

## Самостоятельное задание:

    1. Определим переменную для приватного ключа использующегося в определении подключения для провижинеров (connection).

```shell

variable private_key_path {
  # Описание переменной
  description = "Path to the private key used for ssh access"
} 

private_key_path = "~/.ssh/id_rsa"

```

    2. Определим input переменную для зоны в ресурсе "yandex_compute_instance" "app" и ее значение по умолчанию.

```shell

variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}

```

    3. Создание файла terraform.tfvars.example примера в переменными.

## Дополнительное задание
____

    1. Настройка балансировщика в Yandex Cloud. Конфигурационный файл lb.tf. При обращении к адресу балансировщика должно открываться задеплоенное приложение.
    2. Добавление второго инстанса в main.tf
    3. Добавим вывод IP Адреса балансирощика в output переменную:

```shell

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_app = [
  "178.154.223.158",
  "178.154.220.221",
]
lb_ip_address = tolist([
  "84.252.129.123",
])

```

    4. Проблемы конфигурации деплоя приложения на два инстанса - т.к. у нас в развертываемом приложении используется база данных MongoDB на каждом инстансе, то получается должно быть настроено зеркалирование или репликация данных между БД, для корректной работы приложения с балансировщиком. А также присутсвует избыточная конфигурация в коде.

    5. Описание создания идентичных инстантов через парметр count, в main.tf добавим:

```shell

resource "yandex_compute_instance" "app" {
  name = "reddit-app-${count.index}"
  count = var.count_of_instances
  allow_stopping_for_update = true

```

    В variables.tf добавим:

```shell

variable count_of_instances {
  description = "Count of instances"
  default     = 2
}

```

    В lb.tf добавим:

```shell

resource "yandex_lb_target_group" "app_lb_target_group" {
  name      = "app-lb-group"
  region_id = var.region_id

    dynamic "target" {
      for_each = yandex_compute_instance.app.*.network_interface.0.ip_address
        content {
          subnet_id = var.subnet_id
          address   = target.value
        }
    }
}

```

    В outputs.tf добавим:

```shell

output "external_ip_address_app" {
  value = yandex_compute_instance.app[*].network_interface.0.nat_ip_address
}

```

# Домашнее задание №5
____

## В ДЗ сделано:
____

    1. Создан базовый образа ВМ при помощи Packer в Yandex Cloud (в образ включены mongodb, ruby - установлены через bash-скрипты с помощью shell-provisioner packer).
    2. Деплой тестового приложения при помощи ранее подготовленного образа.
    3. Параметризация шаблона Packer (с использованием var-файла и переменных в самом шаблоне).
    4. Создан скрипт create-reddit-vm.sh в директории config-scripts, который создает ВМ из созданного базового образа с помощью Yandex Cloud CLI.
____
## Основное задание
____

Приложены файлы:

    1. Шаблон Packer ubuntu16.json
    2. В рамках задания в данный шаблон добавлены дополнительные опции билдера (их значения указаны в секции variables шаблона)
    3. Пример var-файла с переменными variables.json.examples, который может использоваться вместе с шаблоном Packer. В нем могут храниться секреты (не должен отслеживаться в git). Реальный файл на локальной машине variables.json добавлен в .gitignore.
____
## Как запустить проект
____
Команда для валидации шаблона с указанием var-файла (запускаем из каталога ./packer):

```shell

packer validate -var-file=variables.json ubuntu16.json

```
Команда для билда образа с указанием var-файла (запускаем из каталога ./packer):

```shell

packer build -var-file=variables.json ubuntu16.json

```

```shell

otus@otus-VirtualBox:~/Desktop/IvanPrivalov_infra/conﬁg- scripts$ yc compute image list
+----------------------+------------------------+-------------+----------------------+--------+
|          ID          |          NAME          |   FAMILY    |     PRODUCT IDS      | STATUS |
+----------------------+------------------------+-------------+----------------------+--------+
| fd8rjogu4lej2vbdfbpu | reddit-base-1626792584 | reddit-base | f2el9g14ih63bjul3ed3 | READY  |
+----------------------+------------------------+-------------+----------------------+--------+

```

После сборки образа создаем ВМ, выбрав его (в качестве пользовательсвого образа) в Yandex Cloud. Затем подключаемся к ВМ и деплоим приложение командами:

```shell

cd /home 
sudo apt-get update 
sudo apt-get install -y git 
git clone -b monolith https://github.com/express42/reddit.git 
cd reddit && bundle install puma -d

```

Проверку запуска приложения можно выполнить, перейдя по адресу: http://<публичный IP ВМ>:9292
____
## Дополнительное задание
____
Приложен скрипт ./config-scripts/create-reddit-vm.sh, который запускается на локальной машине и создает ВМ в Yandex Cloud из базового образа, хранящегося в облаке (собранного ранее в Packer):

После создания ВМ, подключаемся к инстансу через ssh:

ssh -i ~/.ssh/id_rsa packer@<публичный IP-адрес>

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
=======
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
