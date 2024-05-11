#!/bin/bash

# Проверка на наличие файла steamcmd.exe
if [ ! -f "steamcmd.exe" ]; then

    # Загрузка файла
    curl -O https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip

    # Распаковка файла
    unzip steamcmd.zip

    # Удаление скачанного файла после распаковки
    rm steamcmd.zip
else
    echo "steamcmd.exe уже существует."
fi