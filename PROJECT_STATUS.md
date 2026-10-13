# PROJECT_STATUS - Filtros OBS

Última actualización: 2026-10-13.

## Estado actual

Tres filtros nativos para OBS Studio, publicados en Gumroad. Este repositorio
es la fuente de verdad del código y del instalador de Windows: no depender de
copias en discos portátiles.

| Filtro | Código en este repo | macOS en Gumroad | Windows en Gumroad |
| --- | --- | --- | --- |
| Temperature + Tint | 1.0.1 | 1.0.1 (`.pkg`) | paquete 1.0.2, publicado el 2026-10-13 |
| SkinSoft | 1.0.1 | 1.0.1 (`.pkg`) | paquete 1.0.1 con el instalador nuevo, listo para subir |
| Colorist Tone | 1.0.0 | 1.0.0 (`.pkg`) | paquete 1.0.0 con el instalador nuevo, listo para subir |

Colorist Plus es un producto aparte y no vive en este repositorio.

El detalle de cada versión está en [CHANGELOG.md](CHANGELOG.md).

## Último cambio: instalador de Windows (2026-10-13)

Problema reportado por clientes: el filtro no aparecía en OBS cuando OBS no
estaba instalado en `C:\Program Files\obs-studio`.

Causa: el instalador 1.0.1 de Temperature + Tint siempre proponía esa carpeta,
no buscaba OBS y no validaba la carpeta elegida.

Solución: instalador nuevo y compartido en
[`installer/windows`](installer/windows/README.md).

- Modo automático: instala en `%ProgramData%\obs-studio\plugins\<plugin>`, que
  OBS lee sin importar en qué disco esté instalado.
- Modo portátil: el cliente elige la carpeta de OBS y el instalador la valida.
- Desinstala solo las versiones anteriores para que no tapen a la nueva.

Pruebas hechas el 2026-10-13 con Temperature + Tint:

- Lógica en seco (`-DryRun`): modo automático, carpeta de OBS, subcarpeta de
  OBS, carpeta que contiene a OBS y carpeta equivocada.
- Instalación real en modo automático: quitó las versiones 1.0.0 y 1.0.1 de
  `C:\Program Files\obs-studio` y OBS 32.2.1 cargó el filtro.
- OBS 31.1.1 portátil no carga desde `%ProgramData%` (comprobado), por eso
  existe el modo portátil. Instalación real en modo portátil: correcta.

## Pendientes y problemas conocidos

- [ ] Revisar a ojo las pantallas del instalador (textos y tamaños). La lógica
      se probó en modo silencioso; falta la revisión visual.
- [x] Subir a Gumroad el paquete de Windows 1.0.2 de Temperature + Tint
      (2026-10-13).
- [ ] Subir a Gumroad los paquetes de Windows de SkinSoft 1.0.1 y Colorist
      Tone 1.0.0. Empacados el 2026-10-13 con el instalador nuevo. Probado: el
      contenido de cada instalador, la prueba en seco y la carga de ambos
      plugins en OBS 31.1.1. Falta: ejecutar estos dos instaladores de verdad
      en una PC (con Temperature + Tint sí se hizo; el instalador es el mismo).
- [ ] Los instaladores de Windows no tienen firma digital: Windows muestra el
      aviso de SmartScreen. El Read me explica cómo continuar.
- [ ] Un OBS portátil sin archivo `portable_mode.txt` (abierto con
      `--portable`) solo se detecta si está abierto o tiene acceso directo. En
      otro caso el cliente debe elegir la opción portátil a mano.
- [ ] `CMakePresets.json` apunta a Visual Studio 2022. Con Visual Studio 2026
      hay que cambiar el generador a `Visual Studio 18 2026` y el SDK a
      `10.0.26100` en una copia local, sin subir ese cambio.
- [ ] El README de SkinSoft todavía describe los nombres de controles y los
      valores sugeridos de 1.0.0.
- [ ] Prueba visual con material real de Colorist Tone y SkinSoft.

## Ideas pendientes

- Presets rápidos: Natural, Stream, Cinemático, Limpio.
- Comparar antes/después dentro de OBS.
- Guardar presets por cámara.

## Historial corto

- 2026-07-09: Se crea el proyecto. Tres plugins independientes con `.pkg` para
  macOS.
- 2026-07-21: Primeros instaladores de Windows (1.0.0) de los tres filtros.
- 2026-08-06: SkinSoft 1.0.1 para macOS: controles agrupados por pasos.
- 2026-09-24: Temperature + Tint 1.0.1 para macOS y Windows: balance de
  blancos, control Intensidad, interfaz en español.
- 2026-10-13: Instalador nuevo de Windows que funciona con OBS en cualquier
  disco. Paquete de Windows 1.0.2 de Temperature + Tint, publicado en Gumroad.
  Se sube a este repo el código 1.0.1 de Temperature + Tint y de SkinSoft, que
  solo existía en copias locales. Se empacan SkinSoft 1.0.1 y Colorist Tone
  1.0.0 para Windows con el instalador nuevo.
