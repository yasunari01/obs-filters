# PROJECT_STATUS - Filtros OBS

## Estado Actual

Activo / Tres plugins independientes compilados, pendiente prueba visual en OBS.

Proyecto para crear tres filtros nuevos para OBS como plugins independientes:

- Temperature + Tint.
- Colorist Tone.
- SkinSoft.

## Objetivo

Construir filtros utiles para mejorar imagen/camara en OBS, con controles claros y resultado visual rapido.

## Siguiente Paso Registrado

Preparar publicacion en pagina web/Gumroad/Facebook y definir siguiente paso de Windows.

## Bloqueos

- El stack tecnico queda definido: plugins nativos OBS con shaders `.effect`.
- Cada filtro tiene su propio proyecto, bundle id, instalador `.pkg` y README.
- CMake del sistema esta en 3.27.8; cada proyecto tiene `.build-venv` con CMake 3.30.9.
- Falta prueba visual dentro de OBS para Colorist Tone y SkinSoft.
- Material de lanzamiento creado en `launch-material/`.
- Zips macOS publicables creados en `release/macOS/`.
- Windows no esta empaquetado todavia.

## Pendientes

- [ ] Filtro Temperature + Tint
  - [x] Definir control de temperatura fria/calida.
  - [x] Definir tint verde/magenta.
  - [x] Definir rango y valor default.
  - [x] Crear esqueleto nativo OBS.
  - [x] Compilar en macOS.
  - [x] Instalar localmente en la carpeta de plugins de OBS.
  - [x] Probar con camara/webcam.
- [ ] Filtro Colorist Tone
  - [x] Definir controles: sombras, lower mids, mids, upper mids, highlights.
  - [x] Definir contraste, pivot, exposure y mix.
  - [x] Crear plugin nativo independiente.
  - [x] Compilar en macOS.
  - [x] Instalar localmente en la carpeta de plugins de OBS.
  - [ ] Probar con material real.
- [ ] Filtro SkinSoft
  - [x] Definir mascara manual por hue, saturation y luma.
  - [x] Definir controles: mask softness, smooth amount, blur radius, detail protection, texture restore, show mask.
  - [x] Crear plugin nativo independiente.
  - [x] Compilar en macOS.
  - [x] Instalar localmente en la carpeta de plugins de OBS.
  - [ ] Probar con rostro/camara real.

## Ideas Pendientes

- Crear presets rapidos: Natural, Stream, Cinematico, Limpio.
- Comparar antes/despues dentro de OBS.
- Guardar presets por camara.
- Crear build Windows y probarlo en OBS para Windows.
- Convertir logo concept a SVG/PNG final por producto.

## Historial Corto

- 2026-07-09: Se crea proyecto y pendientes iniciales.
- 2026-07-09: Se decide plugin nativo con shader `.effect`, se crea `obs-colorist-filters`, compila en macOS y se instala localmente.
- 2026-07-09: Se cambia arquitectura a un plugin por filtro. Se crean `temperature-tint-filter`, `colorist-tone-filter` y `skinsoft-filter`, todos con `.pkg` independiente.
- 2026-07-09: Se crea launch kit para web, Gumroad y Facebook. Se crean zips macOS individuales y pack completo.
