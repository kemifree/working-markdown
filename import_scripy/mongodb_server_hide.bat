%����mongodb_server%
echo mongodb_server.bat ������������
echo cd C:\Program Files\MongoDB\Server\3.4\bin
echo mongod.exe --dbpath C:\MongoDB\data\db
echo mongo.exe
echo pause
echo ����mongodb_server.bat����

Set ws = CreateObject("Wscript.Shell")
ws.run "cmd \C:\Users\Acer\Desktop\import_scripy\mongodb_server.bat",vbhide
