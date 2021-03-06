#!/bin/bash

# Функция подтверждения (да-нет)
confirm() {
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

# Функция создания пользователя:
read -p "Введите имя нового пользователя: " user
if id -u "$user" >/dev/null 2>&1; then
    echo "Пользователь $user уже существует. Выберите другое имя пользователя."
else
    echo "Создаю пользователя с именем $user"
    read -p "Введите пароль нового пользователя:" pass
    
    if confirm "Добавить пользователя в группу Docker? (y/n or enter for n)"; then
        useradd -m -s /bin/bash -G docker ${user}
        #echo "%$user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$user
    else
        useradd -m -s /bin/bash ${user}
    fi

    # set password
    echo "$user:$pass" | chpasswd

    echo "Пользователь $user успешно создан!"
fi
