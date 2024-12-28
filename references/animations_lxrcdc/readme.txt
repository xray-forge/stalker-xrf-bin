###########################################################
S.T.A.L.K.E.R. lanims.xr compiler/decompiler

=========Использование============

Декомпиляция:	lxrcdc.pl -d <input_file> [-o <outfile> -l <logfile>]

-d <input_file> - входной файл (shaders_xrlc.xr)
-o <outfile> - выходной ltx-файл

Компиляция:	sexrcdc.pl -c <input_file> [-o <outfile> -l <logfile>]

-c <input_file> - входной ltx-файл
-o <outfile> - выходной файл

Общие опции:
-l <logfile> - имя лог-файла

История версий:
[0.2]:
	[+] полный рефакторинг кода
[0.1]:
	начальный релиз