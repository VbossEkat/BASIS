PROCEDURE Close_pc
IF OS(11)='1'
* если это WinNT то нужно взять привилегии
DECLARE LONG GetCurrentProcess IN win32api
DECLARE LONG OpenProcessToken IN win32api LONG ProcessHandle,LONG DesiredAccess,;
LONG @hToken
DECLARE LONG LookupPrivilegeValue IN win32api STRING @lpSystemName,STRING @lpName,;
STRING @lpLuid
DECLARE LONG AdjustTokenPrivileges IN win32api LONG TokenHandle,LONG DisableAllPrivileges,;
STRING @NewState,LONG BufferLength,STRING @PreviousState,LONG @ReturnLength

TOKEN_ADJUST_PRIVILEGES=32
hToken=0
OpenProcessToken(GetCurrentProcess(),TOKEN_ADJUST_PRIVILEGES,@hToken)

lpSystemName=''
SE_SHUTDOWN_NAME='SeShutdownPrivilege'
lpLuid=SPACE(255)
LookupPrivilegeValue(@lpSystemName,@SE_SHUTDOWN_NAME,@lpLuid)

SE_PRIVILEGE_ENABLED=2
tkp=BINTOC(1,'RS')+ALLTRIM(lpLuid)+BINTOC(SE_PRIVILEGE_ENABLED,'RS')
PreviousState=.null.
ReturnLength=0
AdjustTokenPrivileges(hToken,0,@tkp,0,@PreviousState,@ReturnLength)
ENDIF

DECLARE LONG ExitWindowsEx IN win32api LONG uFlags,LONG dwReserved
EWX_LOGOFF=0
EWX_SHUTDOWN=1
EWX_REBOOT=2
EWX_POWEROFF=8
ExitWindowsEx(EWX_LOGOFF,0)

CLEAR DLLS