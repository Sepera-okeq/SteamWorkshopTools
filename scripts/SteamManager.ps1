function InstallSteamCMD {
    $currDirectory = [Environment]::CurrentDirectory
    $binFolder = Join-Path -Path $currDirectory -ChildPath './bin'
    $zipFilePath = Join-Path -Path $binFolder -ChildPath 'steamcmd.zip'

    $WebClient = New-Object System.Net.WebClient
    $url = "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" 
    $WebClient.DownloadFile($url, $zipFilePath)

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipFilePath, $binFolder)
}


function SaveConfigurationToFile {
    param (
        $iniFilePath,
        $configuration
    )

    Set-Content -Path $iniFilePath -Value "" -Force
    foreach ($entry in $configuration.GetEnumerator()) {
        Add-Content -Path $iniFilePath -Value "$($entry.Key) = $($entry.Value)"
    }
}

function GetConfigFromIni {
    param (
        $iniFilePath
    )

    $iniContent = Get-Content -Path $iniFilePath
    $openConfiguration = @{}
    foreach($row in $iniContent){
        if ($row -match '^([^#].*?)\s*=\s*(.*)') {
            $openConfiguration[$matches[1]] = $matches[2]
        }
    }
    return $openConfiguration
}


function UpdateConfigurationValue {
    param (
        $iniFilePath,
        $keyToChange,
        $newValue
    )

    # Загружаем текущую конфигурацию из ini файла
    $configurationOpenINI = GetConfigFromIni -iniFilePath $iniFilePath

    Write-Host "[SWST] Выберите параметр для редактирования:"
    $i = 1
    $configurationOpenINI.GetEnumerator() | ForEach-Object {
        Write-Host "  $i. $($_.Key): $($_.Value)"
        $i++
    }

    $keyIndex = Read-Host "Введите номер параметра"
    # Вычитаем 1, т.к. перечисление начинается с 0
    $keyToChange = ($configurationOpenINI.GetEnumerator() | Select-Object -Index ($keyIndex - 1)).Key
    $newValue

 

    if ($keyToChange -eq 'confAppID') {
        do {
            $newValue = Read-Host "Введите ваш AppID игры, для какой игры хотите выложить мод"
        } while ($newValue -notmatch '^\d+$')
    }

    if ($keyToChange -eq 'confSteamIDMod') {
        do {
            $newValue = Read-Host "Введите ваш Steam ID модификации"
        } while ($newValue -notmatch '^\d+$')
    }

    # Если обновляем 'confNameMod', удаляем изначальный файл конфигурации
    if ($keyToChange -eq 'confNameMod') {
        $newValue = Read-Host "Введите новое название модификации"
        Remove-Item $iniFilePath -Force
        $iniFilePath = "./data/config-$newValue.ini"
    }

    if ($keyToChange -eq 'confPathMod') {
        Add-Type -AssemblyName System.Windows.Forms

        $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
        $result = $folderBrowser.ShowDialog()

        if ($result -eq [System.Windows.Forms.DialogResult]::OK)
        {
            $path = $folderBrowser.SelectedPath
            Write-Host "Выбран путь к папке мода: $path"
        }
        else
        {
            Write-Host "Путь не выбран..."
        }
    }

    if ($keyToChange -eq 'confPathImageMod') {
        Add-Type -AssemblyName System.Windows.Forms
        $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $openFileDialog.Filter = "Images|*.png;*.jpg;*.jpeg;*.bmp;*.gif"

        if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $selectedImage = $openFileDialog.FileName
            Copy-Item -Path $selectedImage -Destination $thumbnailPath
            Write-Host "Изображение скопировано в: $thumbnailPath"
        } else {
            Write-Host "Файл изображения не выбран."
        }
    }

    # Обновляем значение для выбранного ключа
    $configurationOpenINI[$keyToChange] = $newValue

    # Сохраняем изменения в новый ini файл
    SaveConfigurationToFile -iniFilePath $iniFilePath -configuration $configurationOpenINI

    Write-Host "[SWST] Конфигурация для выбранного параметра была обновлена..."

    return $configurationOpenINI['confNameMod']
}


function CreateNewConfiguration {
    Clear-Host
    Write-Host "[SWST]: Конфигурация файла для отправки в Steam.."



    do {
        $appid = Read-Host "Введите AppID игры (hoi4 - 394360) (с.м https://github.com/Sepera-okeq/SteamWorkshopTools/README.MD#SteamID)"
    } while ($appid -notmatch '^\d+$')
    $nameMod = Read-Host "Введите ваше название мода в Steam или в дескрипторе модификации"
    do {
        $steamIdWorkShop = Read-Host "Введите ваш Steam ID модификации (0 - если вы не заливали мод) (с.м https://github.com/Sepera-okeq/SteamWorkshopTools/README.MD#SteamID)"
    } while ($steamIdWorkShop -notmatch '^\d+$')
    Add-Type -AssemblyName System.Windows.Forms

    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $result = $folderBrowser.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $path = $folderBrowser.SelectedPath
        Write-Host "Выбран путь к папке мода: $path"
    }
    else
    {
        Write-Host "Путь не выбран..."
    }

    $thumbnailPath = Join-Path -Path $path -ChildPath "thumbnail.png"

    if (-Not (Test-Path -Path $thumbnailPath)) {
        Add-Type -AssemblyName System.Windows.Forms
        $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $openFileDialog.Filter = "Images|*.png;*.jpg;*.jpeg;*.bmp;*.gif"

        if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $selectedImage = $openFileDialog.FileName
            Copy-Item -Path $selectedImage -Destination $thumbnailPath
            Write-Host "Изображение скопировано в: $thumbnailPath"
        } else {
            Write-Host "Файл изображения не выбран."
        }
    } else {
        Write-Host "Файл $thumbnailPath уже существует. Автоматически пропускаю этап."
    }


    Clear-Host
    Write-Host "[SWST]: Вы ввели следующие данные:"
    Write-Host "  AppID: $appid"
    Write-Host "  Название: $nameMod"
    Write-Host "  Steam ID: $steamIdWorkShop"
    Write-Host "  Путь к моду: $path"
    Write-Host "  Путь к изображению мода: $thumbnailPath"

    $configuration = @{
        "confAppID" = $appid 
        "confNameMod" = $nameMod
        "confSteamIDMod" = $steamIdWorkShop
        "confPathMod" = $path
        "confPathImageMod" = $thumbnailPath
    }

    $confirmation = Read-Host "Если данные верны, введите Y, иначе просто N"

    if ($confirmation -eq 'Y') {
        Clear-Host
        Write-Host "[SWST]: Данные были подтверждены.. Создаю конфигурационный файл..."
        $tempNewConfigNameFile = $nameMod.Replace(" ", "")
        $iniFilePath = "./data/config-$tempNewConfigNameFile.ini"
        SaveConfigurationToFile -iniFilePath $iniFilePath -configuration $configuration
    } else {
        Clear-Host
        Write-Host "[SWST]: Данные не были подтверждены... Отмена создания конфигурации..."
    }
}

Clear-Host

$iniFiles = Get-ChildItem -Path .\data\ -Filter *.ini
$idx =1

if (!$iniFiles) {
    CreateNewConfiguration
    Write-Host "[SWST] Изменены конфигурации.. Запустите снова скрипт...  Выхожу из программы..."
} else {
    Write-Host "[SWST] Выберите конфигурацию:"
    foreach ($file in $iniFiles) {
        $content = Get-Content $file.FullName
        $confNameMod = ($content | Select-String -Pattern "confNameMod\s*=\s*(.*)").Matches.Groups[1].Value
        $confNameMod = $confNameMod.Trim()
        Write-Host "  $idx. $($confNameMod)"
        $idx++
    }

    Write-Host "  0. Создать новую конфигурацию"

    $configurationIndex = Read-Host "Введите выбор от (0 - $($idx-1))"

    do {
        if ($configurationIndex -notmatch '^\d+$') {
          Write-Host "[SWST] Введенное значение - это не число, пожалуйста, повторите попытку!"
          $configurationIndex = Read-Host "Введите выбор от (0 - $($idx-1))"
        } elseif (($configurationIndex -lt 0) -or ($configurationIndex -ge $idx)) {
          Write-Host "[SWST] Номер не в зоне действия, пожалуйста, повторите попытку!"
          $configurationIndex = Read-Host "Введите выбор от (0 - $($idx-1))"
        } else {
          $selectedOption = $configurationIndex
          break
        }
    } while($true)

    if ($configurationIndex -eq 0) {
        CreateNewConfiguration
        Write-Host "[SWST] Изменены конфигурации.. Запустите снова скрипт...  Выхожу из программы..."
    } else {
        Clear-Host
    }
}

# Путь до INI файла выбранного
$iniFilePath = $iniFiles[$selectedOption-1] #выбранный ini файл

do {
    $configurationOpenINI = GetConfigFromIni -iniFilePath $iniFilePath
    Clear-Host
    Write-Host "[SWST] Выберите, что сделать с модом: $($configurationOpenINI["confNameMod"])"
    Write-Host "  1. Загрузить новое обновление в Steam"
    Write-Host "  2. Изменить конфигурацию"
    Write-Host "  3. Открыть конфигурацию"
    Write-Host "  0. Выход из программы"

    $input = Read-Host "Выберите (0-3)"

    switch ($input) {
        '1' {
            Clear-Host
            Write-Host "[SWST] Подготавливаем обновление в Steam...."

            $tempVdfName = $configurationOpenINI["confNameMod"].Trim();

            $changenoteUpdate = Read-Host "Введите название вашего обновления"
            $descriptionUpdate = Read-Host "Введите описание вашего обновления"


            $vdfFilePath = "./data/config-$($tempVdfName).vdf"

$vdfContent = @"
 "workshopitem"
{
"appid"             "$($configurationOpenINI["confAppID"])"
"publishedfileid"   "$($configurationOpenINI["confSteamIDMod"])"
"contentfolder"     "$($configurationOpenINI["confPathMod"])"
"previewfile"       "$($configurationOpenINI["confPathImageMod"])"
"visibility"        "0"
"title"             "$($configurationOpenINI["confNameMod"].Trim())"
"description"       "$($descriptionUpdate)"
"changenote"        "$($changenoteUpdate)"
}
"@

            # Запись VDF содержимого в новый файл
            $vdfContent | Out-File -FilePath $vdfFilePath -Encoding utf8

            Write-Host "[SWST] VDF-файл успешно создан в: $vdfFilePath"

            # Проверяем наличие "./bin/steamcmd.exe"
            if (-not (Test-Path './bin/steamcmd.exe')) {
                InstallSteamCMD
            }

            # Запрашиваем у пользователя логин и пароль
            $myLoginName = Read-Host 'Введите ваш логин'
            $myPassword = Read-Host 'Введите ваш пароль'

            $vdfFileFullPath = (Resolve-Path $vdfFilePath).Path

            # Вызываем "./bin/steamcmd.exe" с аргументами
            $arguments = "+login $myLoginName $myPassword", "+workshop_build_item $vdfFileFullPath", "+quit"
            Write-Host = $arguments
            Start-Process -FilePath './bin/steamcmd.exe' -ArgumentList $arguments -NoNewWindow -Wait
            Write-Host " "
            Read-Host "Нажмите любой символ...."
        }
        '2' {
            Clear-Host
            $tempUpdate = UpdateConfigurationValue -iniFilePath $iniFilePath

            if ($tempUpdate -ne $configurationOpenINI["confNameMod"]) {
                Write-Host "[SWST] Изменены конфигурации.. Запустите снова скрипт...  Выхожу из программы..."
                exit                
            }
        }
        '3' {
            Clear-Host
            Write-Host "[SWST] Просмотор конфигурации файла $($iniFilePath.Name)"
            $configurationOpenINI.GetEnumerator() | ForEach-Object {
                Write-Host "  Параметр $($_.Key): $($_.Value)"
            }
            Write-Host " "
            Read-Host "Нажмите любой символ...."
        }
        '0' {
            Write-Host "Выхожу...."
            exit
        }
        default {
            Write-Host "Неверный вариант, пожалуйста, введите 0, 1, 2 или 3."
        }
    }
} while ($true)
