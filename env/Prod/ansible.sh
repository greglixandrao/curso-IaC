#!/bin/bash
cd /home/ubuntu
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install ansible
tee -a playbook.yml > /dev/null <<EOT
---
  - hosts: localhost
    tasks:
    - name: Install python3 and virtualenv
      apt:
        pkg:
        - python3
        - virtualenv
        update_cache: yes
      become: yes

    - name: Clone project
      ansible.builtin.git:
        repo: https://github.com/alura-cursos/clientes-leo-api.git
        dest: /home/ubuntu/tcc
        version: master
        force: yes

    - name: Install dependenci with pip
      pip:
        virtualenv: /home/ubuntu/tcc/venv
        requirements: /home/ubuntu/tcc/requirements.txt

    - name: Changing hosts from settings
      lineinfile:
        path: /home/ubuntu/tcc/setup/settings.py
        regexp: 'ALLOWED_HOSTS'
        line: 'ALLOWED_HOSTS = ["*"]'
        backrefs: yes

    - name: Configure Database
      shell: '. /home/ubuntu/tcc/venv/bin/activate; python /home/ubuntu/tcc/manage.py migrate'
    - name: Load inicial data
      shell: '. /home/ubuntu/tcc/venv/bin/activate; python /home/ubuntu/tcc/manage.py loaddata clientes.json'

    - name: Starting server
      shell: '. /home/ubuntu/tcc/venv/bin/activate; nohup python /home/ubuntu/tcc/manage.py runserver 0.0.0.0:8000 &'
EOT

ansible-playbook playbook.yml
