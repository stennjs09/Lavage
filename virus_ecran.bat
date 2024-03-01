@echo off
echo Script d'extinction de l'écran lancé en boucle. Préparez-vous à une interruption constante.

:: Boucle d'extinction de l'écran en permanence
:loop
powershell (Add-Type '[DllImport(\"user32.dll\")]^public static extern int SendMessage(int hWnd,int hMsg,int wParam,int lParam);' -Name a -Pas)::SendMessage(-1,0x0112,0xF170,2)
goto loop
:: Fin de la boucle
