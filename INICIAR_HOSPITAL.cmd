@echo off
setlocal
cd /d "%~dp0"
title Hospital Infantil Arcoiris - Servidor local
echo Hospital Infantil Arcoiris
echo.
echo Si el hospital ya esta encendido, se abrira el sitio existente.
echo Si se inicia aqui, manten esta ventana abierta mientras lo utilizas.
echo Abre en tu navegador: http://127.0.0.1:8765/hospital/
echo Para detener el servidor, presiona Ctrl+C.
echo.
python -u "%~dp0sitio\iniciar_hospital.py"
if errorlevel 1 (
    echo.
    echo No fue posible abrir el hospital. Revisa el mensaje anterior.
    pause
    exit /b 1
)
exit /b 0
