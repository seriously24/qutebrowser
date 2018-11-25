Name "qutebrowser"

Unicode true
RequestExecutionLevel admin
SetCompressor /solid lzma

!ifdef X64
  OutFile "..\dist\qutebrowser-${VERSION}-amd64.exe"
  InstallDir "$ProgramFiles64\qutebrowser"
!else
  OutFile "..\dist\qutebrowser-${VERSION}-win32.exe"
  InstallDir "$ProgramFiles\qutebrowser"
!endif

;Default installation folder
  
!include "MUI2.nsh"
;!include "MultiUser.nsh"

!define MUI_ABORTWARNING
;!define MULTIUSER_MUI
;!define MULTIUSER_INSTALLMODE_COMMANDLINE
!define MUI_ICON "../icons/qutebrowser.ico"
!define MUI_UNICON "../icons/qutebrowser.ico"

!insertmacro MUI_PAGE_LICENSE "..\LICENSE"
Page custom nsDialogsPage
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

; depends on admin status
;SetShellVarContext current
Var Dialog
Var CheckBox

Function nsDialogsPage
  nsDialogs::Create 1018
  Pop $Dialog

  ${If} $Dialog == error
  	Abort
  ${EndIf}

  ${NSD_CreateCheckbox} 0 30u 100% 10u "&Make Qutebrowser my default browser"
  Pop $Checkbox

  nsDialogs::Show
FunctionEnd


Section "Install"

  ; Uninstall old versions
  ExecWait 'MsiExec.exe /quiet /qn /norestart /X{633F41F9-FE9B-42D1-9CC4-718CBD01EE11}'
  ExecWait 'MsiExec.exe /quiet /qn /norestart /X{9331D947-AC86-4542-A755-A833429C6E69}'
  IfFileExists "$INSTDIR\uninst.exe" 0 +2
  ExecWait "$INSTDIR\uninst.exe /S _?=$INSTDIR"
  CreateDirectory "$INSTDIR"

  SetOutPath "$INSTDIR"

  !ifdef X64
	file /r "..\dist\qutebrowser-${VERSION}-x64\*.*"
  !else
	file /r "..\dist\qutebrowser-${VERSION}-x86\*.*"
  !endif

  SetShellVarContext all
  CreateShortCut "$SMPROGRAMS\qutebrowser.lnk" "$INSTDIR\qutebrowser.exe"
  
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\uninst.exe"

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\qutebrowser" "DisplayName" "qutebrowser"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\qutebrowser" "UninstallString" '"$INSTDIR\uninst.exe"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\qutebrowser" "QuietUninstallString" '"$INSTDIR\uninst.exe" /S'

  # Setup default browser if chosen by user
  ${NSD_GetState} $CheckBox $0
  ${If} $0 == 1
    WriteRegStr HKLM "Software\Classes\qutebrowserHTML" "" "qutebrowser HTML Document"
    WriteRegStr HKLM "Software\Classes\qutebrowserHTML\DefaultIcon" "" "%~dp0qutebrowser.exe,0"
    WriteRegStr HKLM "Software\Classes\qutebrowserHTML\shell\open\command" "" "%~dp0qutebrowser.exe %%1"

    WriteRegStr HKLM "Software\Classes\qutebrowserURL" "" "qutebrowser URL Protocol"
    WriteRegDWORD HKLM "Software\Classes\qutebrowserURL" "EditFlags" "2"
    WriteRegStr HKLM "Software\Classes\qutebrowserURL" "FriendlyTypeName" "qutebrowser URL"
    WriteRegStr HKLM "Software\Classes\qutebrowserURL" "URL Protocol" ""
    WriteRegStr HKLM "Software\Classes\qutebrowserURL\DefaultIcon" "" "%~dp0qutebrowser.exe,0"
    WriteRegStr HKLM "Software\Classes\qutebrowserURL\shell\open\command" "" "%~dp0qutebrowser.exe %%1"

    WriteRegStr HKLM "Software\RegisteredApplications" "qutebrowser" "Software\Clients\StartMenuInternet\qutebrowser\Capabilities"

    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser" "" "qutebrowser"

    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\DefaultIcon" "" "%~dp0qutebrowser.exe,0"

    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\shell\open\command" "" "%~dp0qutebrowser.exe"

    WriteRegDWORD HKLM "Software\Clients\StartMenuInternet\qutebrowser\InstallInfo" "IconsVisible" "1"

    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities" "ApplicationIcon" "%~dp0qutebrowser.exe,0"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities" "ApplicationName" "qutebrowser"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities" "ApplicationDescription" "Keyboard driven web browser"

    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\FileAssociations" ".htm" "qutebrowserHTML"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\FileAssociations" ".html" "qutebrowserHTML"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\FileAssociations" ".shtml" "qutebrowserHTML"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\FileAssociations" ".xht" "qutebrowserHTML"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\FileAssociations" ".xhtml" "qutebrowserHTML"

    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\StartMenu"  "StartMenuInternet" "qutebrowser"

    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\URLAssociations" "ftp" "qutebrowserURL"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\URLAssociations" "http" "qutebrowserURL"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\URLAssociations" "https" "qutebrowserURL"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\URLAssociations" "mailto" "qutebrowserURL"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\URLAssociations" "webcal" "qutebrowserURL"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\URLAssociations" "urn" "qutebrowserURL"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\URLAssociations" "tel" "qutebrowserURL"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\URLAssociations" "smsto" "qutebrowserURL"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\URLAssociations" "sms" "qutebrowserURL"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\URLAssociations" "nntp" "qutebrowserURL"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\URLAssociations" "news" "qutebrowserURL"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\URLAssociations" "mms" "qutebrowserURL"
    WriteRegStr HKLM "Software\Clients\StartMenuInternet\qutebrowser\Capabilities\URLAssociations" "irc" "qutebrowserURL"

  ${EndIf}

SectionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  SetShellVarContext all
  Delete "$SMPROGRAMS\qutebrowser.lnk"

  RMDir /r "$INSTDIR\*.*"
  RMDir "$INSTDIR"

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\qutebrowser"

  #TODO: Unregister all keys if default browser
SectionEnd
