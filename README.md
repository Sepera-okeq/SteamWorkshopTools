# SteamWorkshopTools

OS:
- [Windows](#Windows)
- [Linux](#Linux)
- [MasOS](#MasOS)


## Windows
1. Установите SteamCMD, скачав данный репозиторий или [здесь](https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip)
2. Распакуйте в удобную для вас папку. Например ``C:\SteamCMD``
3. Откройте PowerShell в ``C:\SteamCMD`` или перейдите туда с помощью ``cd C:\SteamCMD``
4. Создайте vdf файл для отправки в Steam.
```
 "workshopitem"
{
"appid" "394360" 
"publishedfileid" "0"
"contentfolder" "D:\Users\User\Documents\EC_2013"
"previewfile" "D:\Users\User\Documents\EC_2013\thumbnail.png"
"visibility" "0"
"title" "Heart of Iron IV: Economic Crisis"
"description" "сюда описание на англ.языке"
"changenote" "Обновление v0.7.6"
}
```
- appid - ID приложения в Steam. В нашем случаи Heart of Iron IV - 394360
- publishedfileid - ID контента в Steam Мастерской. Установите 0 - если публикуете в первый раз. Если нет, то скопируйте его из вашей страницы через ``Скопировать адрес вашей страницы`` и выписать ID мода. 
Т.е ``https://steamcommunity.com/sharedfiles/filedetails/?id=2000532465`` из ссылки ID мода это 2000532465
- contentfolder - Путь к контенту, т.е к моду.
- previewfile - Файл превью контента. Т.е картинка в папке мода *thumbnail.png*.
- visibility - Видимость предмета. 0 - открытый, 1 - только для друзей, 2 - скрытый
- title - Заголовок продукта 
- description - Описание продукта на Английском языке.
- changenote - Описание обновления на Английском языке.
5. Сделали? Теперь настало время отправить мод в Steam! 
Либо изменяем script-windows.bat, или открываем PowerShell где установлен SteamCMD и пишем:

``./steamcmd.exe +login myLoginName myPassword +workshop_build_item "C:\SteamCMD\economic-crisis.vdf" +quit``

Где:
- myLoginName - ваш логин Steam
- myPassword - ваш пароль Steam
- "C:\SteamCMD\economic-crisis.vdf" - путь к вашему файлу.

После того как SteamCMD закачает к вам на комп необходимые либы, начнется процесс заливки мода в Steam. Если у вас включен SteamGuard - то SteamCMD попросит вас ввести ключ, чтобы можно было залить вам мод.


## Linux
1. Воспользуйтесь скриптами в bin/linux для вашей ОС
  - [Debian/Ubuntu](https://github.com/Sepera-okeq/SteamWorkshopTools/blob/main/bin/linux/debian_ubuntu.sh)
  - [RedHat/CentOS](https://github.com/Sepera-okeq/SteamWorkshopTools/blob/main/bin/linux/redhat_centos.sh)
  - [Arch Linux](https://github.com/Sepera-okeq/SteamWorkshopTools/blob/main/bin/linux/arch_linux.sh)
2. После того как вы скачали, создайте vdf файл так-же, как это описано у Windows в 4 пункте.
3. Сделали? Теперь отправим мод в Steam!

Либо изменяем script-linux.sh, или открываем Terminal и пишем:

``steamcmd +login myLoginName myPassword +workshop_build_item - "home\user\economic-crisis.vdf" +quit``

Где:
- myLoginName - ваш логин Steam
- myPassword - ваш пароль Steam
- "home\user\economic-crisis.vdf" - путь к вашему файлу.

Если у вас включен SteamGuard - то SteamCMD попросит вас ввести ключ, чтобы можно было залить вам мод.

## MasOS
1. Установка производится через Terminal - [команды](https://github.com/Sepera-okeq/SteamWorkshopTools/blob/main/bin/macos/macos.txt)
2. После этого воспользуйтесь такими же инструкциями, как и описано в Linux по созданию vdf и заливке мода, указав лишь путь в вашей системе.

Если у вас включен SteamGuard - то SteamCMD попросит вас ввести ключ, чтобы можно было залить вам мод.
