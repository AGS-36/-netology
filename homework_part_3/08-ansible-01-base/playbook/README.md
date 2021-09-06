# Самоконтроль выполненения задания

1. Где расположен файл с `some_fact` из второго пункта задания?
08-ansible-01-base/playbook/group_vars/all
2. Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?
ansible-playbook site.yml -i inventory/test.yml
3. Какой командой можно зашифровать файл?
ansible-vault encrypt 
4. Какой командой можно расшифровать файл?
ansible-vault decrypt
5. Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?
ansible-vault view filename
6. Как выглядит команда запуска `playbook`, если переменные зашифрованы?
ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
7. Как называется модуль подключения к host на windows?
WinRM
8. Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh
08-ansible-01-base ► ansible-doc --type connection ssh
> ANSIBLE.BUILTIN.SSH    (/home/q/.local/lib/python3.9/site-packages/ansible/plugins/connection/ssh.py)

        This connection plugin allows ansible to communicate to the target machines via normal
        ssh command line. Ansible does not expose a channel to allow communication between the
        user and the ssh process to accept a password manually to decrypt an ssh key when using
        this connection plugin (which is the default). The use of ``ssh-agent`` is highly
        recommended.

OPTIONS (= is mandatory):

- control_path
        This is the location to save ssh's ControlPath sockets, it uses ssh's variable
        substitution.
        Since 2.3, if null (default), ansible will generate a unique hash. Use `%(directory)s`
        to indicate where to use the control dir path setting.
        Before 2.3 it defaulted to `control_path=%(directory)s/ansible-ssh-%%h-%%p-%%r`.
        Be aware that this setting is ignored if `-o ControlPath` is set in ssh args.
        [Default: (null)]
        set_via:
          env:
          - name: ANSIBLE_SSH_CONTROL_PATH
          ini:
          - key: control_path
            section: ssh_connection
          vars:
          - name: ansible_control_path
            version_added_collection: ansible.builtin

            ...//...
9. Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?
ansible ssh
