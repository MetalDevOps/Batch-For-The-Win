# Batch For The Win

Ultimate Mux Subtitle

## Descrição

Esse script junta arquivos de video e legenda, utilizando o arquivo .json gerado pelo mkvtoolnix é possivel renomear as faixas conforme for necessario

## Dependencias

- [MKVToolNix](https://www.fosshub.com/MKVToolNix.html)
- [7zip](https://www.7-zip.org/)

## Como gerar um arquivo .json

1. Download MKVToolNix.
2. Abra `mkvtoolnix-gui.exe`.
3. Adicione os arquivos
4. Faça as mudanças que deseja replicar (Desabilitar faixas, renomear faixas, etc.).
5. Vá em `Menu Bar > Multiplexer > Create option file`, e salve como por exemplo 'options.json', salve o arquivo no mesmo diretorio onde estão os arquivos de que serão processados.
6. Abra o arquivo JSON com o seu editor favorito e delete:
   - A linha com `"--output",` e a linha abaixo dela
   - A linha que tiver`"(",` e `")",` e tudo que estiver entre elas

 Pronto, caso tenha dúvidas, consulte o arquivo de exemplo.

--Em construção--