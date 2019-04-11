@CHCP 1252 >NUL
@ECHO OFF
:: =======================
:: ||     Batch For The Win
:: ||       for MKVmerge
:: ||        v1.0 by kyO
:: =======================
:: Este script irá scanear o diretório fornecido (ou a pasta atual)
:: em busca de arquivos de video para tentar combinar com arquivos de legenda
:: e juntar tudo em um único arquivo usando o MKVMERGE.
:: ---- ---- ---- ----
:: || CONFIGURAÇÕES DE USUARIO
:: // diretorio completo do mkvmerge.exe
        SET "muxpath=C:\Program Files\MKVToolNix\mkvmerge.exe"
:: \\ -- -- -- -- --
:: // diretorio completo do 7z, só é necessario em alguns casos.
        SET "rarpath=C:\Program Files\7-Zip\7z.exe"
        SET "rarcmd=e"
:: \\ -- -- -- -- --
:: // diretorio de saida
:: ++ deixe em branco caso queira usar o diretorio de trabalho
        SET "outputdir=out/"
::  default: SET "outputdir="
:: \\ -- -- -- -- --
:: // prefixo para o arquivo de saida
:: ++ OBRIGATORIO se o diretorio de saida foi deixado em branco, ou se a extensão de saida for a mesma da extensão de entrada
        SET "fileprefix="

:: // Idioma padrão da legenda
		SET "lang=por"

:: // muda a extensão do arquivo de saida
		SET "outext=mkv"

:: // Coloque aqui a extensão dos arquivos de entrada
		SET "inext=mp4"

:: // Coloque aqui a extensão do arquivo de legenda
		SET "subext=vtt"

:: // Nome do arquivo .json
		SET "json=options.json"
:: // Para aprender a gerar um arquivo .json, consultar o README!

:: \\ -- -- -- -- --
:: || FIM DAS CONFIGURAÇÕES
:: \\ ---- ---- ---- ----
:: -- qualquer edição abaixo deverá ser feita com cautela. (Ou não...)
:: ===========================================================================

:: contadores
		SET /A "mc=0"
		SET /A "me=0"

:: diretorio de trabalho padrão
		SET "wp=."

:: diretorio de trabalho opcional via argument
IF EXIST "%~1" SET "wp=%~1"

:: pronto? vamos lá!
CLS
ECHO ===========================================================================

:: vamos tentar usar uma configuração personalizada para o diretorio de saida
IF EXIST "%outputdir%" (
:: foi configurado um diretorio de saida
	ECHO == Configuração do usuario -- Diretorio de saida: [%outputdir%]
) ELSE (
:: nenhuma configuração personalizada encontrada, verificar se tem algum prefixo
	IF [%fileprefix%]==[] (
        ECHO @@ ERRO: o campo [fileprefix] esta vazio, caso queira permanecer assim o campo [outputdir] precisa ser configurado
		SET /A me+=1
		GOTO:done
	)
:: usar o diretorio de trabalha como saida
		SET "outputdir=%wp%\"
)
FOR %%H IN ("%wp%") DO (
:: porque "." não nos diz onde estamos
	ECHO == Verificando [%%~dpfH\] por arquivos de video...
)

:getfiles
FOR %%I IN ("%wp%\*.%inext%",
		::"%wp%\*.customVideoExtension",
			"%wp%\*.mkv",
			"%wp%\*.mp4") DO (
:: @@ achamos o arquivo de video, agora vamos verificar a legenda
	CALL:getsubs "%%~I"
)
GOTO:done

:getsubs
FOR %%J IN ("%wp%\%~n1.%subext%",
::			"%wp%\%~n1.customSubtitleExtension",
			"%wp%\%~n1.srt") DO (
:: @@ vamos verificar se tem legendas semelhantes. talvez seja necessario verificar USF/XML
	IF %%~xJ==.idx IF EXIST "%wp%\%%~nJ.idx" IF NOT EXIST "%wp%\%%~nJ.sub" (
		IF EXIST "%wp%\%%~nJ.rar" (
			ECHO -- [%%~nJ.sub] -- Achado um potencial .rar
			ECHO | SET /p extdone=">> "
			"%rarpath%" "%rarcmd%" "%%~dpJ%%~nJ.rar" | FIND "Extracting"
		) ELSE (
			ECHO @@ ERROR: [%%~nJ.idx] -- Faltando um arquvo .sub
			SET /A me+=1
			GOTO:eof
		)
	)
::legenda encontrada, agora vamos juntar tudo
	IF EXIST "%wp%\%%~nJ%%~xJ" CALL:muxit "%%~f1" "%%~xJ"
)
GOTO:eof

:muxit
::vamos ter certeza que o arquivo de destino não existe
IF EXIST "%outputdir%%fileprefix%%~n1%~x1" (
	ECHO @@ ERROR: [%~n1%~x1] -- Arquivo de saida já existe
			SET /A me+=1
			GOTO:eof
)

::Conseguimos!!
		SET /A mc+=1
::agora, vamos deixar o mkvmerge fazer a mágica // %~x1
ECHO | SET /p muxdone="++ Muxing: (%mc%) [%~n1%~x1]"
"%muxpath%" --default-language "%lang%" @"%json%" -q -o "%outputdir%%fileprefix%%~n1.%outext%" "%~1" "%wp%\%~n1%~2"
ECHO  ..completo
::SUCESSO!!
GOTO:eof

:done
ECHO == Processamento finalizado: %mc% completado / %me% erros
ECHO ===========================================================================
::CABOU, É TETRA!!!
pause