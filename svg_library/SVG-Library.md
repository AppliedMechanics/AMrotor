***SVG-Converter***

Der SVG-Converter stellt ein Python-Skript zur Verfügung, das .svg-Dateien automatisiert in verschiedene Ausgabeformate formatiert. Das besondere daran ist die Möglichkeit mittels LaTeX in .svg-Bilder integrierte Formeln zu rendern und ebenfalls wieder als plain-svg oder andere Formate darzustellen.

Aufbau durch Johannes Maierhofer (danke an Philipp Seiwald für die gute Grundlage!)

**Unterstütze Ausgabeformate**

- .pdf
- .png
- .eps
- .emf

**Notwendige installierte Module**

- Python v3 + Jjinja2
- inkscape
- ghostscript (Achtung: Für Windows muss die Datei gswin64c.exe kopiert und dann in gs.exe umbenannt werden!)

**Benutzung**

Um das System zu verwenden ist folgende Ordnerstruktur nötig:

_base_ 

​	-- build

​	-- pure_svg

​	-- tex_svg

​		-- prebuild

​	-- tools

