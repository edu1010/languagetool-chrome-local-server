# LanguageTool local

Servidor local LanguageTool para usar la extension sin depender del API remoto.

Extension instalada en dos variantes:

- `extension\webextension-mv3`: variante local para Chrome actual.
- `extension\languagetool-browser-addon\webextension`: variante clasica Manifest V2 si mantienes el clon upstream localmente.

Ambas estan configuradas por defecto para usar `http://localhost:8081/v2`.

Uso:

1. Instalar/descargar servidor:
   `powershell -ExecutionPolicy Bypass -File .\install-server.ps1`

2. Arrancar servidor:
   `powershell -ExecutionPolicy Bypass -File .\start-server.ps1`

3. Probar servidor:
   `powershell -ExecutionPolicy Bypass -File .\test-server.ps1`

4. Abrir Chrome con la extension cargada:
   `powershell -ExecutionPolicy Bypass -File .\open-chrome-with-extension.ps1`

En Chrome tambien puedes cargarla manualmente desde `chrome://extensions` activando "Developer mode" y usando "Load unpacked" sobre:

`C:\Users\ecorral9\Documents\languagetool\extension\webextension-mv3`

Notas:

- Esto usa el servidor open source local de LanguageTool. No incluye funciones premium/AI/parafraseo de pago.
- El repositorio publico de la extension de navegador esta marcado por LanguageTool como version antigua.
- La carpeta `webextension-mv3` es una adaptacion local para Chrome Manifest V3.
