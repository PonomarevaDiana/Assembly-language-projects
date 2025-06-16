TITLE   Графическое приложение для Windows    (WinApp.asm)

   ; Эта программа отображает на экране основное окно, размеры которого
   ;  можно изменить и несколько окон сообщений.
   ; Выражаю особую благодарность Тому Джойсу (Tom Joyce),
   ;  написавшему первую версию этой программы.

   .386
    include masm32rt.inc

   ;==================== ДАННЫЕ =======================
   .data

   MAIN_WINDOW_STYLE = WS_VISIBLE+WS_DLGFRAME+WS_CAPTION+WS_BORDER+WS_SYSMENU \
	+WS_MAXIMIZEBOX+WS_MINIMIZEBOX+WS_THICKFRAME

   PopupTitle       BYTE   "Окно сообщения",0
   PopupText        BYTE   "Это окно было активизировано после "
                    BYTE   "получения сообщения WM_LBUTTONDOWN",0
   ErrorTitle       BYTE   "Ошибка!",0
   WindowName       BYTE   "Графическая ассемблерная программа",0
   className        BYTE   "ASMWin",0

   ; Определим структурную переменную, описывающую класс окна
   MainWin          WNDCLASS  <NULL,WinProc,NULL,NULL,NULL,NULL,NULL, COLOR_WINDOW,NULL,className>
   msg              MSG <>
   winRect          RECT      <>
   hMainWnd         DWORD     ?
   hInstance        DWORD     ?

   ;=================== КОД  =========================
   .code
   WinMain PROC
   ; Определим дескриптор текущего процесса
     INVOKE GetModuleHandle , NULL
     mov   hInstance        , eax
     mov   MainWin.hInstance, eax

   ; Загрузим образы пиктограммы и курсора программы.
     INVOKE LoadIcon, NULL, IDI_APPLICATION
     mov   MainWin.hIcon    , eax

     INVOKE LoadCursor, NULL, IDC_ARROW
     mov   MainWin.hCursor  , eax

   ; Зарегистрируем класс окна
     INVOKE RegisterClass, ADDR MainWin
     .IF eax == 0
         call  ErrorHandler
         jmp   Exit_Program
     .ENDIF

   ; Создадим основное окно программы
     INVOKE  CreateWindowEx, 0, ADDR className,
             ADDR WindowName,MAIN_WINDOW_STYLE,
             CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,
             CW_USEDEFAULT,NULL,NULL,hInstance,NULL

   ; Если функция CreateWindowEx завершилась аварийно, отобразим 
   ;  сообщение в выйдем из программы.
     .IF eax == 0
         call  ErrorHandler
         jmp   Exit_Program
     .ENDIF

   ; Запомним дескриптор окна, отобразим окно на экране и 
   ;  обновим его содержимое
     mov   hMainWnd     ,eax
     INVOKE ShowWindow  , hMainWnd, SW_SHOW
     INVOKE UpdateWindow, hMainWnd

   ; Создадим цикл обработки сообщений
  Message_Loop:

   ; Получим новое сообщение из очереди
     INVOKE GetMessage, ADDR msg, NULL,NULL,NULL

   ; Если в очереди больше нет сообщений, завершим
   ;  работу программы
   .IF eax == 0
       jmp Exit_Program
   .ENDIF

   ; Отправим сообщение на обработку процедуре WinProc нашей программы
     INVOKE DispatchMessage, ADDR msg
     jmp Message_Loop

   Exit_Program:
     INVOKE ExitProcess,0
   WinMain ENDP
   
   ; В предыдущем цикле программы функции GetMessage 
   ;  передается адрес структурной переменной msg. 
   ;  После вызова функции в эту переменную помещается текущее 
   ;  сообщение из очереди, которое затем передается на дальнейшую 
   ; обработку функции DispatchMessage системы Windows.


   PifagorTree PROC, hdc:HDC, x_M:DWORD, y_M:DWORD, a_x:DWORD, a_y:DWORD, b_x:DWORD, b_y:DWORD, rest: DWORD, s1:DWORD, s2: DWORD, s3: DWORD, s4: DWORD, s5: DWORD, s6: DWORD,p: POINT
     
     pushad
     ; начальные координаты M
     mov edi, x_M 
     mov esi, y_M 
     
     ; координаты новых векторов a и b
     mov eax, a_x
     sar eax, 1
     
     mov ebx, a_y
     sar ebx, 1
     
     mov ecx, b_x
     sar ecx, 1

     mov edx, b_y
     sar edx, 1

     ; рисуем 4 линии
     ; Первая линия
     


     pushad
     invoke MoveToEx, hdc, edi, esi, addr p
     popad


     
     add edi, eax
     add esi, ebx
     sub edi, ecx
     sub esi, edx

     
     pushad
     invoke LineTo, hdc, edi, esi
     popad
     
    ;Вторая линия

     pushad
     invoke MoveToEx, hdc, edi, esi, addr p
     popad
     
     add edi, eax
     add esi, ebx
     add edi, ecx
     add esi, edx

     
     pushad
     invoke LineTo, hdc, edi, esi
     popad

    ; Третья линия 


     pushad
     invoke MoveToEx, hdc, edi, esi, addr p
     popad

     
     sub edi, eax
     sub esi, ebx
     add edi, ecx
     add esi, edx

     
     pushad
     invoke LineTo, hdc, edi, esi
     popad

   ;Четвертая линия

     pushad
     invoke MoveToEx, hdc, edi, esi, addr p
     popad

     
     sub edi, eax
     sub esi, ebx
     sub edi, ecx
     sub esi, edx

     
     pushad
     invoke LineTo, hdc, edi, esi
     popad
     

     ; новые координаты M
     mov edi, x_M
     mov esi, y_M
     add edi, eax
     add edi, eax
     add edi, ecx
     

     add esi, ebx
     add esi, ebx
     add esi, edx
     
     
     ;новые координаты векторов
    
     mov s1, eax
     mov s2, ebx
    
     sub eax, ecx
     sub ebx, edx
     
     add ecx, s1
     add edx, s2     
     
     mov s1, edi
     mov s2, esi



     ; новые координаты M
     mov edi, x_M
     mov esi, y_M
     add edi, ecx
     add esi, edx   
     
     
     
     dec rest
     cmp rest, 0
     je @end
     invoke PifagorTree, hdc, s1, s2,  eax, ebx, ecx, edx,rest, 1, 1, 1,1,1,1, p
     mov s1, eax
     mov eax, 0
     sub eax, s1

     mov s2, ebx
     mov ebx, 0
     sub ebx, s2
     invoke PifagorTree, hdc, edi,esi, ecx, edx, eax, ebx,rest, 1, 1, 1,1,1,1, p
@end:
     popad
     ret
   PifagorTree ENDP

   ;-----------------------------------------------------
   WinProc PROC,
           hWnd:DWORD, localMsg:DWORD, wParam:DWORD, lParam:DWORD
   ; Эта процедура обрабатывает некоторые сообщения, посылаемые
   ;  системой Windows нашему приложению.
   ; Обработка остальных сообщений выполняется стандартной
   ;  процедурой системы Windows.
   ;-----------------------------------------------------
   LOCAL hdc:HDC, ps:PAINTSTRUCT 
   LOCAL p:POINT

     mov   eax,localMsg
     .IF eax == WM_LBUTTONDOWN     ; Щелчок левой кнопкой мыши?
         INVOKE MessageBox, hWnd, ADDR PopupText,
                ADDR PopupTitle, MB_OK
         jmp WinProcExit


     .ELSEIF eax == WM_PAINT       ; Требуется перерисовка окна?
         ;готовим окно для рисования и заполняем структуру ps
         invoke BeginPaint,hMainWnd, ADDR ps
         ;функция вернула дескриптор контекста устройства отображения - сохраняем его
	 mov hdc,eax 

	 invoke GetStockObject, DC_PEN
	 invoke SelectObject, hdc, eax
	 invoke SetDCPenColor, hdc, Magenta

	 ;рисуем эллипс
	 ;invoke Ellipse, hdc, 100, 100, 200, 200
	 invoke PifagorTree, hdc, 500, 500, 100, -100, -100, -100, 10, 1, 1, 1,1,1,1, p
         ;завершаем рисование
         invoke EndPaint,hMainWnd, ADDR ps

     .ELSE                         ; Другие сообщения
         INVOKE DefWindowProc, hWnd, localMsg, wParam, lParam
         jmp WinProcExit
     .ENDIF

   WinProcExit:
      ret
   WinProc ENDP
   ;---------------------------------------------------
   ErrorHandler PROC
   ; Выведем системное сообщение об ошибке
   ;---------------------------------------------------
   .data
    pErrorMsg   DWORD   ?          ; Адрес сообщения об ошибке
    messageID   DWORD   ?

   .code
    INVOKE GetLastError            ; В EAX возвращается код ошибки
    mov   messageID,eax

   ; Определим адрес текстового сообщения об ошибке
    INVOKE FormatMessage, FORMAT_MESSAGE_ALLOCATE_BUFFER + \
                          FORMAT_MESSAGE_FROM_SYSTEM,NULL,messageID,NULL,
                          ADDR pErrorMsg,NULL,NULL

   ; Отобразим сообщение об ошибке
    INVOKE MessageBox,NULL, pErrorMsg, ADDR ErrorTitle,
                     MB_ICONERROR+MB_OK

   ; Освободим память, занимаемую текстовой строкой
   ;  сообщения об ошибке
    INVOKE LocalFree, pErrorMsg
    ret
   ErrorHandler ENDP
   END WinMain