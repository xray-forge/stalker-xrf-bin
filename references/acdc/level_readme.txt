###########################################################
S.T.A.L.K.E.R. level compiler/decompiler v.0.4


Usage:	lcdc -d <input_file> [-o outdir]
	lcdc -c <input_dir> [-o outfile]

Скрипт предназначен для распаковки и запаковки файла level. Поддерживаются форматы всех финалок и всех 
известных билдов. Кроме распаковки также подробно разбираются следующие секции:

FSL_HEADER - заголовок с версией xrlc  и качеством сборки
FSL_SHADERS - таблица пар текстура/шейдер (engine shader). В билдах 1558-1569 только текстура.
FSL_LIGHT_DYNAMIC - источники света (в основном, для R1)
FSL_GLOWS - отблески
FSL_TEXTURES - текстуры (билды 749-1098).

Можно редактировать, изменения при запаковке сохранятся. В билдах часть секций находится в запакованном виде,
текущая версия скрипта их не распаковывает.

Некоторые хинты:
-в FSL_LIGHT_DYNAMIC у каждой секции есть параметр type (тип). Доступные варианты: point|spot|directional.
-в FSL_GLOWS shader_index означает номер пары в таблице текстура/шейдер. Внимание! Под индексом 0 в таблице
нет пары, так и должно быть.

История версий:
[v.0.4]: введено логирование, адаптирован новый модуль отладки

[v.0.3]: исправлен баг запаковки, если паковался чанк FSL_CFORM

[v.0.2]: добавлена поддержка билдов 749-1555

[v.0.1]: начальный релиз, основная функциональность.

Автор данного скрипта - K.D., разбор формата level - bardak.