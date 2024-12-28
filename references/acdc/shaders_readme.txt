###########################################################
S.T.A.L.K.E.R. shaders.xr compiler/decompiler

=========Использование============

Декомпиляция:	sxrcdc.pl -d <input_file> [-o <outdir> -m <ltx|bin> -l <logfile>]

-d <input_file> - входной файл (shaders.xr)
-o <outdir> - папка, куда сохранять шейдеры

Компиляция:	sxrcdc.pl -c <input_dir> [-o <outfile> -mode <ltx|bin> -l <logfile>]

-c <input_dir> - папка, где лежат шейдеры
-o <outfile> - выходной файл

Общие опции:
-m <ltx|bin> - режим декомпиляции. bin -разбивать на бинарные файлы, ltx - полная декомпиляция.
-l <logfile> - файл лога

История версий:
[0.2]:
	полный рефакторинг кода
[0.1]:
	начальный релиз