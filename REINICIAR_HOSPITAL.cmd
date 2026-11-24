@echo off
setlocal
cd /d "%~dp0"
title Hospital Infantil Arcoiris - Reiniciar
python -u "%~dp0sitio\iniciar_hospital.py" --reiniciar
if errorlevel 1 (
    echo No fue posible reiniciar. Revisa el mensaje anterior.
    pause
    exit /b 1
)
exit /b 0
