#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOTVSWEBSRV.CH'

WSSERVICE SERVERTIME
	WSDATA Horario as String
	WSMETHOD GetServerTime
	ENDWSSERVICE

	WSMETHOD GetServerTime WSRECEIVE NULLPARAM WSSEND Horario WSSERVICE SERVERTIME
	::Horario := TIME()
Return .T.