# Autonmap 
**Autonmap** es una herramienta ligera escrita en Bash, diseñada para optimizar la fase de enumeración durante auditorías de red y exámenes de certificación como el **OSCP**.

El objetivo principal de este script es resolver el dilema entre **velocidad** y **precisión**. En entornos de red inestables, los escaneos agresivos (usando `--min-rate`) pueden omitir puertos abiertos. Autonmap elimina este riesgo mediante una técnica de verificación cruzada.

## Características
- **Escaneo de Doble Fase:** Combina un escaneo rápido inicial con un escaneo completo de seguridad.
- **Verificación de Integridad:** Compara los resultados de ambas fases para detectar puertos adicionales que podrían haber pasado desapercibidos inicialmente.
- **Detección Automática de Servicios:** Lanza escaneos de versiones y scripts predeterminados (`-sVC`) exclusivamente sobre los puertos detectados.
- **Salida Limpia y Visual:** Implementa códigos de colores para una lectura rápida de los resultados en la terminal.

## Metodología Técnica
El script sigue un flujo de trabajo lógico y automatizado:
1. **Fase Agresiva:** Escaneo de los 65,535 puertos TCP con `--min-rate 5000` para obtener resultados inmediatos.
2. **Reconocimiento Temprano:** Ejecuta `-sVC` sobre los primeros puertos encontrados para que el auditor pueda comenzar la explotación sin demora.
3. **Fase de Seguridad:** Realiza un escaneo completo a velocidad estándar para garantizar la detección de servicios más lentos o con respuestas filtradas.
4. **Diferenciación (Delta-Scan):** Utiliza herramientas de procesamiento de texto (`comm`, `sed`, `cut`) para identificar nuevos puertos detectados en la Fase 2 y lanza un reconocimiento adicional sobre ellos de forma automática.

##  Uso rápido

```bash
# Descargar el script
wget https://raw.githubusercontent.com/zilr4c/autonmap/main/autonmap.sh

# Dar permisos de ejecución
chmod +x autonmap.sh

# Ejecutar contra una IP objetivo
./autonmap.sh <IP_OBJETIVO>

```

<p align="center">
<a href="https://zilr4c.github.io/posts/autonmap/">
<b>📖 Leer el artículo detallado en mi Blog</b>
</a>
</p>


```
