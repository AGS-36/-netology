# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
```
playbook ► ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python, but future
installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible/2.11/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]

TASK [Print OS] *******************************************************************************************************
ok: [localhost] => {
    "msg": "Archlinux"
}

TASK [Print fact] *****************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
```
playbook ► ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python, but future
installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible/2.11/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]

TASK [Print OS] *******************************************************************************************************
ok: [localhost] => {
    "msg": "Archlinux"
}

TASK [Print fact] *****************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ************************************************************************************************************
localhost
```
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
► docker run -d --name centos7 pycontribs/centos:7 sleep 50000000
4864c0feefef92603cd89c8bc7415b53bf72120a862d9540a09f7989d4fe3f93
► docker run -d --name ubuntu pycontribs/ubuntu sleep 50000000
442ac97e0359ad1278cecf1d710dd3bda952abd575555c746343942bb7c8cb13

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
```
playbook ► ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using
/usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using
 the discovered platform python for this host. See
https://docs.ansible.com/ansible/2.11/reference_appendices/interpreter_discovery.html for more information. This
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in
 ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu
```
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
```
---
  some_fact: "ideb default fact"


---
  some_fact: "el default fact"
```

6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
```
playbook ► ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using
/usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using
 the discovered platform python for this host. See
https://docs.ansible.com/ansible/2.11/reference_appendices/interpreter_discovery.html for more information. This
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in
 ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "ideb default fact"
}

PLAY RECAP ************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu
```

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
```
playbook ► ansible-vault encrypt group_vars/deb/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
playbook ► ansible-vault encrypt group_vars/el/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
```
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
```
playbook ► ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] *************************************************************************************************
ERROR! Attempting to decrypt but no vault secrets found
playbook ► ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using
/usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using
 the discovered platform python for this host. See
https://docs.ansible.com/ansible/2.11/reference_appendices/interpreter_discovery.html for more information. This
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in
 ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [ubuntu] => {
    "msg": "ideb default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}

PLAY RECAP ************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu
```
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
ansible-doc --type connection --list
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
```
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
```
playbook ► ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python, but future
installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible/2.11/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using
/usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using
 the discovered platform python for this host. See
https://docs.ansible.com/ansible/2.11/reference_appendices/interpreter_discovery.html for more information. This
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in
 ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************
ok: [localhost] => {
    "msg": "Archlinux"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "ideb default fact"
}

PLAY RECAP ************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu
```
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
```
deb ► ansible-vault decrypt examp.yml
Vault password:
Decryption successful

el ► ansible-vault decrypt examp.yml
Vault password:
Decryption successful
```

2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
```
all ► ansible-vault encrypt_string PaSSw0rd --ask-vault-pass
New Vault password:
Confirm New Vault password:
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          65623034313534303737306563666365376335633966313133346133346137306435623532363866
          3062316135643639353837653530396539653964623834350a613634336137613736663062633261
          62363331306261333331636230323864613533376538643734313137336132353136313534396231
          6133663061653236380a393933656535316632336234623964616563333165353336653239366238
          6230
Encryption successful

all ► cat examp.yml 
---
  some_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          65623034313534303737306563666365376335633966313133346133346137306435623532363866
          3062316135643639353837653530396539653964623834350a613634336137613736663062633261
          62363331306261333331636230323864613533376538643734313137336132353136313534396231
          6133663061653236380a393933656535316632336234623964616563333165353336653239366238
          6230
```

3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
```
playbook ► ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python, but future
installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible/2.11/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using
/usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using
 the discovered platform python for this host. See
https://docs.ansible.com/ansible/2.11/reference_appendices/interpreter_discovery.html for more information. This
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in
 ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************
ok: [localhost] => {
    "msg": "Archlinux"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}

TASK [Print fact] *****************************************************************************************************
fatal: [localhost]: FAILED! => {"msg": "Attempting to decrypt but no vault secrets found"}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "ideb default fact"
}

PLAY RECAP ************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=2    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
ubuntu


playbook ► ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python, but future
installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible/2.11/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using
/usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using
 the discovered platform python for this host. See
https://docs.ansible.com/ansible/2.11/reference_appendices/interpreter_discovery.html for more information. This
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in
 ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************
ok: [localhost] => {
    "msg": "Archlinux"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "ideb default fact"
}

PLAY RECAP ************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu 
```

4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
```
playbook ► ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:
[WARNING]: Found both group and host with same name: fedora

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python, but future
installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible/2.11/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]
ok: [fedora]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using
/usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using
 the discovered platform python for this host. See
https://docs.ansible.com/ansible/2.11/reference_appendices/interpreter_discovery.html for more information. This
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in
 ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************
ok: [localhost] => {
    "msg": "Archlinux"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] *****************************************************************************************************
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "ideb default fact"
}
ok: [fedora] => {
    "msg": "fedora default fact"
}

PLAY RECAP ************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu
```
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
```
!#/bin/bash

docker run --name ubuntu  -d pycontribs/ubuntu:latest sleep 999999999
docker run --name centos7 -d pycontribs/centos:7 sleep 999999999
docker run --name fedora -d pycontribs/fedora sleep 999999999
cd playbook
ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
docker stop ubuntu centos7 fedora
docker rm ubuntu centos7 fedora
```
https://github.com/AGS-36/devops-netology/blob/master/homework_part_3/08-ansible-01-base/script.sh
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
