# Домашнее задание к занятию "08.02 Работа с Playbook"

## Подготовка к выполнению
1. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
2. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
3. Подготовьте хосты в соотвтествии с группами из предподготовленного playbook. 
4. Скачайте дистрибутив [java](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) и положите его в директорию `playbook/files/`. 

## Основная часть
1. Приготовьте свой собственный inventory файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает kibana.
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, сгенерировать конфигурацию с параметрами.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, в ответ предоставьте ссылку на него.


```
Настроил среду и проверил.

playbook ► ansible-playbook -i inventory/prod.yml site.yml

PLAY [Install Java] ***************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
[DEPRECATION WARNING]: Distribution debian 10.9 on host localhost should use /usr/bin/python3, but is using
/usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using
 the discovered platform python for this host. See
https://docs.ansible.com/ansible/2.11/reference_appendices/interpreter_discovery.html for more information. This
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in
 ansible.cfg.
ok: [localhost]

TASK [Set facts for Java 11 vars] *************************************************************************************
ok: [localhost]

TASK [Upload .tar.gz file containing binaries from local storage] *****************************************************
changed: [localhost]

TASK [Ensure installation dir exists] *********************************************************************************
changed: [localhost]

TASK [Extract java in the installation directory] *********************************************************************
changed: [localhost]

TASK [Export environment variables] ***********************************************************************************
changed: [localhost]

PLAY [Install Elasticsearch] ******************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [localhost]

TASK [Upload tar.gz Elasticsearch from remote URL] ********************************************************************
changed: [localhost]

TASK [Create directrory for Elasticsearch] ****************************************************************************
changed: [localhost]

TASK [Extract Elasticsearch in the installation directory] ************************************************************
changed: [localhost]

TASK [Set environment Elastic] ****************************************************************************************
changed: [localhost]

PLAY RECAP ************************************************************************************************************
localhost                  : ok=11   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


дописал свой play 


playbook ► ansible-playbook -i inventory/prod.yml site.yml
PLAY [Install Java] ************************************************************

TASK [Gathering Facts] *********************************************************
[DEPRECATION WARNING]: Distribution debian 10.9 on host localhost should use
/usr/bin/python3, but is using /usr/bin/python for backward compatibility with
prior Ansible releases. A future Ansible release will default to using the
discovered platform python for this host. See https://docs.ansible.com/ansible/
2.11/reference_appendices/interpreter_discovery.html for more information. This
 feature will be removed in version 2.12. Deprecation warnings can be disabled
by setting deprecation_warnings=False in ansible.cfg.
ok: [localhost]

TASK [Set facts for Java 11 vars] **********************************************
ok: [localhost]

TASK [Upload .tar.gz file containing binaries from local storage] **************
ok: [localhost]

TASK [Ensure installation dir exists] ******************************************
ok: [localhost]

TASK [Extract java in the installation directory] ******************************
skipping: [localhost]

TASK [Export environment variables] ********************************************
ok: [localhost]

PLAY [Install Elasticsearch] ***************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [Upload tar.gz Elasticsearch from remote URL] *****************************
ok: [localhost]

TASK [Create directrory for Elasticsearch] *************************************
ok: [localhost]

TASK [Extract Elasticsearch in the installation directory] *********************
skipping: [localhost]

TASK [Set environment Elastic] *************************************************
ok: [localhost]

PLAY [Install Kibana] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [Upload kibana from remote URL] *******************************************
ok: [localhost]

TASK [Create directrory for kibana] ********************************************
ok: [localhost]

TASK [Extract Kibana in the installation directory] ****************************
skipping: [localhost]

TASK [Set environment Kibana] **************************************************
ok: [localhost]

TASK [Replace default kibana.yml] **********************************************
ok: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=14   changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0



playbook ► ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml

playbook ► ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Java] ************************************************************

TASK [Gathering Facts] *********************************************************
[DEPRECATION WARNING]: Distribution debian 10.9 on host localhost should use
/usr/bin/python3, but is using /usr/bin/python for backward compatibility with
prior Ansible releases. A future Ansible release will default to using the
discovered platform python for this host. See https://docs.ansible.com/ansible/
2.11/reference_appendices/interpreter_discovery.html for more information. This
 feature will be removed in version 2.12. Deprecation warnings can be disabled
by setting deprecation_warnings=False in ansible.cfg.
ok: [localhost]

TASK [Set facts for Java 11 vars] **********************************************
ok: [localhost]

TASK [Upload .tar.gz file containing binaries from local storage] **************
ok: [localhost]

TASK [Ensure installation dir exists] ******************************************
ok: [localhost]

TASK [Extract java in the installation directory] ******************************
skipping: [localhost]

TASK [Export environment variables] ********************************************
ok: [localhost]

PLAY [Install Elasticsearch] ***************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [Upload tar.gz Elasticsearch from remote URL] *****************************
ok: [localhost]

TASK [Create directrory for Elasticsearch] *************************************
ok: [localhost]

TASK [Extract Elasticsearch in the installation directory] *********************
skipping: [localhost]

TASK [Set environment Elastic] *************************************************
ok: [localhost]

PLAY [Install Kibana] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [Upload kibana from remote URL] *******************************************
ok: [localhost]

TASK [Create directrory for kibana] ********************************************
ok: [localhost]

TASK [Extract Kibana in the installation directory] ****************************
skipping: [localhost]

TASK [Set environment Kibana] **************************************************
ok: [localhost]

TASK [Replace default kibana.yml] **********************************************
ok: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=14   changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0


playbook ► ansible-playbook -i inventory/prod.yml site.yml --diff
PLAY [Install Java] ************************************************************

TASK [Gathering Facts] *********************************************************
[DEPRECATION WARNING]: Distribution debian 10.9 on host localhost should use 
/usr/bin/python3, but is using /usr/bin/python for backward compatibility with 
prior Ansible releases. A future Ansible release will default to using the 
discovered platform python for this host. See https://docs.ansible.com/ansible/
2.11/reference_appendices/interpreter_discovery.html for more information. This
 feature will be removed in version 2.12. Deprecation warnings can be disabled 
by setting deprecation_warnings=False in ansible.cfg.
ok: [localhost]

TASK [Set facts for Java 11 vars] **********************************************
ok: [localhost]

TASK [Upload .tar.gz file containing binaries from local storage] **************
ok: [localhost]

TASK [Ensure installation dir exists] ******************************************
ok: [localhost]

TASK [Extract java in the installation directory] ******************************
skipping: [localhost]

TASK [Export environment variables] ********************************************
ok: [localhost]

PLAY [Install Elasticsearch] ***************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [Upload tar.gz Elasticsearch from remote URL] *****************************
ok: [localhost]

TASK [Create directrory for Elasticsearch] *************************************
ok: [localhost]

TASK [Extract Elasticsearch in the installation directory] *********************
skipping: [localhost]

TASK [Set environment Elastic] *************************************************
ok: [localhost]

PLAY [Install Kibana] **********************************************************
```


---
