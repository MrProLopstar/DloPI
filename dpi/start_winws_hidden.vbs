Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colProcesses = objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name = 'winws.exe'")
For Each objProcess in colProcesses
    objProcess.Terminate()
Next

Set WshShell = CreateObject("WScript.Shell")

Dim command
command = "./dpi/winws.exe --wf-tcp=443-65535 --wf-udp=443-65535 " & _
          "--filter-udp=443 --hostlist=""../list-discord.txt"" --hostlist=""../list-youtube.txt"" --hostlist=""../list-main.txt"" " & _
          "--dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=6 " & _
          "--dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""quic_initial_www_google_com.bin"" " & _
          "--new --filter-udp=50000-65535 --dpi-desync=fake,tamper --dpi-desync-any-protocol " & _
          "--dpi-desync-fake-quic=""quic_initial_www_google_com.bin"" --new " & _
          "--filter-tcp=443 --hostlist=""../list-discord.txt"" --hostlist=""../list-youtube.txt"" --hostlist=""../list-main.txt"" " & _
          "--dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig " & _
          "--dpi-desync-fake-tls=""tls_clienthello_www_google_com.bin"""


WshShell.Run command, 0, False