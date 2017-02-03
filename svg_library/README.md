Lehre-Versionsverwaltung

(c) 2015 Lehrstuhl für Angewandte Mechanik, Technische Universität München

Autoren: Alexander Ewald, Johannes Rutzmoser

Übersicht: 
----------
1.  [Philosophie der Lehre-Versionsverwaltung](#1-philosophie-der-lehre-versionsverwaltung)
2.  [Installation](#2-installation)
3.  [Ordnerstruktur](#3-ordnerstruktur)
4.  [Grafiken](#4-grafiken)
5.  [Referenzen in LaTeX](#5-referenzen-in-latex)
6.  [Builder](#6-builder)
7.  [Typischer Workflow](#7-typischer-workflow)
8.  [Todo](#8-todo)
9.  [Benutzung unter Windows](#9-benutzung-unter-windows)
10. [Hinweise und Fehlerbehebung](#10-hinweise-und-fehlerbehebung)
11. [Git Guidelines](#11-git-guidelines)

1. Philosophie der Lehre-Versionsverwaltung
-------------------------------------------
Die Lehre-Versionsverwaltung entstand aus dem Gedanken, ein einheitliches und 
zuverlässiges Rahmenwerk für die Erstellung und Wartung von LaTeX-Dokumenten zu 
schaffen. Ziel ist es, in einem übersichtlichen und umfassenden System die 
Dokumente, die für die Lehre am Lehrstuhl erstellt werden, zu pflegen und 
laufend zu verbessern. Zudem sollen alle Teilnehmer im Lehre-Team einen 
einfachen und problemlosen Zugriff auf alte und neue Aufgaben erhalten. 

Als Haupttool zur Synchronisierung dient hierfür das quelloffenen Programm 
git, LaTeX zur Erstellung der Dokumente und Inkscape zur 
Manipulation der Vektorgrafiken. 


2. Installation
---------------
Zu Beginn muss das Paket vom git-Server geklont werden. Um Zugriff auf den Server zu erhalten, ist eine legitimierte LRZ-ID (vom Typ *ab12cde*) notwendig. Mit nachfolgendem Befehl mit der eigenen LRZ-ID (hier ist *ab12cde* angegeben) wird das git-Repository im aktuellen Verzeichnis geklont:
```bash
git clone https://ab12cde@gitlab.lrz.de/AM/Lehre.git AMLehre
```
Wechsel in das geklonte Verzeichnis:
```bash
cd AMLehre
```
Zum Bauen der LaTeX-Dokumente den Befehl 
```bash
./scons.py
```
eingeben. Der erste Lauf kann einige Minuten dauern, es werden alle Dokumente 
von Grund auf neu erstellt. Die anschließenden Läufe gehen wesentlich schneller,
da nur veränderte Dokumente neu erstellt werden. 

Voraussetzungen für einen erfolgreichen Lauf (auf einem Linux-System) sind:
- LaTeX installiert
- Inkscape ab Version 0.48 installiert 


3. Ordnerstruktur
-----------------
Die Ordnerstruktur der Lehre-Dokumente ist so ausgelegt, dass keine Dopplungen 
auftreten, und einmal erzeugte Dokumente an vielen Stellen verwendet und 
eingebunden werden können. Hauptdatenbank ist der [lib](lib)-Ordner, in ihm sind
z.B. alle Aufgaben für die Übungen abgelegt. 

Im Ordner [build](build) sind alle erzeugten fertigen Dokumente ohne 
Systemdateien abgelegt. 

In jedem Ordner befindet sich eine `SConscript`-Datei, die in der nachfolgenden 
Verzeichnisübersicht nicht aufgeführt ist. In ihr sind die Anweisungen für den 
Builder festgelegt (siehe [6. Builder](#6-builder)).

### Verzeichnisstruktur:

+ [scons.py](scons.py) *ausführbare Datei zum Bauen der LaTeX- und 
Inkscape-Dokumente*
+ build [*Fertig erstellte Dokumente (ohne LaTeX-Systemdateien); werden 
in dieses Verzeichnis nach Lauf kopiert*]
    + TM1
        + Tutoruebung [*Ordner mit Tutorübungen*]
            - W10_Uebung_1_Angabe.pdf
            - ...
        - Formelsamlung.pdf
        - ...
    - TM2 [*analoger Aufbau wie TM1*]
    - TM3 [*analoger Aufbau wie TM1*]
    - ...
+ [documents](documents) *Dokumente*
    * [TM1](documents/TM1)
        - [Formelsammlung](documents/TM1/Formelsammlung)
        - [Bilder](documents/TM1/Formelsammlung/Bilder) *Ordner mit
        Zeichnungen für Formelsammlung*
        - [Formelsammlung.tex](documents/TM1/Formelsammlung/Formelsammlung.tex) 
        *LaTeX-Datei der Formelsammlung*
        - [Skript](documents/TM1/Skript) *analoger Aufbau wie Formelsammlung*
        - ...
        - Tutorübung
            + W10_Uebung_1 [*Wintersemester 10/11, 1. Übung*]
                - Aufgabe1 [*Link auf 1. Aufgabe der Tutorübung im 'lib'-Verzeichnis*]
                - Aufgabe2 [*analog wie Aufgabe 1*]
            + W10_Uebung_1_Angabe.tex [*tex-Datei der Angabe; 
            die Aufgabe wird aus dem [lib](lib)-Verzeichnis mit `\input`
            eingebunden*]
            + W10_Uebung_1_Loes.tex [*tex-Datei der Lösung; auch sie wird aus dem
            [lib](lib)-Verzeichnis mit `\input` eingebunden*]
            + ... [*Dateien, die beim ersten Latex-Lauf erstellt werden*]
            + ... [*weitere Tutorübungen*]
    * [TM2](documents/TM2) *analog wie TM1*
    * [TM3](documents/TM3) *analog wie TM1*
+ [lib](lib) *Bibliothek aller Aufgaben und Vorlagen*
    * [Aufgaben](lib/Aufgaben) *Alle Aufgaben für Übungen, Tutorübungen 
    und ehemalige Prüfungsaufgaben*
        + [TM1/Virtuelle_Arbeit_1](lib/Aufgaben/TM1/Virtuelle_Arbeit_1) *Aufgabe 
        für z.B. virtuelle Arbeit*
            - [Angabe.tex](lib/Aufgaben/TM1/Virtuelle_Arbeit_1/Angabe.tex) *Angabentext 
            mit Bild; ohne Überschrift*
            - [Loesung.tex](lib/Aufgaben/TM1/Virtuelle_Arbeit_1/Loesung.tex) 
            *Lösungstext mit Bilder; ohne Überschriften*
            
            Bilder werden mit Befehl 
            
            `\import{lib/Aufgaben/TM1_Virtuelle_Arbeit_1/Bilder/}{Angabe.pdf_tex}`
            
            eingebunden; die pdf_tex-Datei wird automatisch aus der svg-Datei 
            generiert. 
            
            __WICHTIG__: Die svg-Datei darf nicht im gleichen 
            Verzeichnis wie die tex-Datei, in der sie eingebunden wird sein
            - [Bilder](lib/Aufgaben/TM1/Virtuelle_Arbeit_1/Bilder) *Bilderdateien*
                - [Angabe.svg](lib/Aufgaben/TM1/Virtuelle_Arbeit_1/Bilder/Angabe.svg)
                *svg-Datei der Angabe* 
                
                wird automatisch in pdf_tex-Datei 
                umgewandelt; Dabei wird Text in Grafik als LaTeX-Text ersetzt, 
                auch Formeln sind in Grafik möglich (z.B. `$\frac{1}{2}$` in 
                Grafik wird als LaTeX-Bruch ausgegeben)
    * [Bilder](lib/Bilder) *Logos der TU und der Fachschaft*
    * [Inkscape](lib/Inkscape) *Inkscape-Bibliothek mit Standard-Zeichnungselementen*
    - Klassen [Klassen der unterschiedlichen Dokumenttypen] Nur hier neue
    Befehle einführen und Packages einbinden!]
    * [Skripten](lib/Skripten) *Quelldateien der Skripte*
    * [Tabellen](lib/Tabellen) *allgemeine Tabellen* (z.B. Trägheitsmomente für 
    Formelsammlung)
    * [Tools](lib/Tools) *LaTeX-Toolpakete*
    - AMtools.sty [Lehrstuhl-Paket für vereinfachten LaTeX-Formelsatz]
    - ...
  

4. Grafiken
------------
Die Grafiken für die Dokumente müssen im svg-Format vorliegen. Empfohlenes 
Programm für die Erstellung ist das quelloffene Inkscape. Soll in den Grafiken 
Text enthalten sein, so wird dieser automatisch in LaTeX-Text umgewandelt. Dies 
bedeutet, dass die Schriftart und Schriftgröße aus dem LaTeX-Dokument, in dem 
die Grafik eingebunden wird, angewandt wird. Da die Textersetzung direkt in 
LaTeX durchgeführt wird, können auch Formeln und andere LaTeX-Befehle ausgeführt
werden, d.h. der Text `$\frac{1}{2}$` in der Grafik wird durch einen 
mathematischen Bruch in der Grafik des Dokuments ersetzt. 

Damit die Ausrichtung der Textboxen in der SVG-Datei im LaTeX-Dokument erhalten 
bleibt, soll im Hintergrund ein weißes viereckiges Element angelegt werden, das 
die komplette Grafik umschließt. Nur so ist eine Konsistenz der Anordnung von 
Schrift und Grafik gewährleistet. 

In der LateX-Datei wird die Grafik mit dem Befehl 
```latex
  \import{Dateipfad-ausgehend-von-Lehre-bis-Bildordner/}{Bildname.pdf_tex}
```
eingebunden. Beim Bauen des Dokuments mit `./scons.py` wird aus der svg-Datei 
automatisch eine pdf-Datei ohne Beschriftung und eine pdf_tex-Datei, in der die 
Beschriftungen festgelegt sind, erstellt. Durch das Einbinden der pdf_tex-Datei,
in der wiederum (automatisch) die unbeschriftete pdf-Datei eingebunden wird, 
wird die Grafik und die Beschriftung eingefügt. **WICHTIG: Die svg-Datei darf 
nicht im gleichen Verzeichnis wie die tex-Datei, in der sie eingebunden wird, 
sein.**

Sind keine Beschriftungen in der Grafik vorhanden, reicht das Einbinden im 
LaTeX-Dokument über den Befehl 
```latex
  \includegraphics{Dateipfad-ausgehend-von-Lehre-bis-Bildordner/Bildname.pdf}
```
Der Builder erkennt automatisch, dass keine Schriftersetzungen nötig sind. 
Soll direkt eine .pdf-Datei eingebunden werden, die nicht als .svg-Datei 
vorliegt, so ist die Datei mit dem Befehl
```latex
  \includegraphics{Dateipfad-ausgehend-von-Lehre-bis-Bildordner/Bildname.pdf}%SCONS_IGNORE
```
einzubinden.

5. Referenzen in LaTeX
----------------------
Zum Einbinden von LaTeX-Dateien gibt es zwei Befehle: `\input` und `\import`

Beide können jedoch nicht beliebig verwendet werden. Zum Einbinden einer Grafik 
wird der import-Befehl verwendet:
```latex
  \import{Relativer-Pfad-zum-Ordner/}{Dateiname.pdf_tex}
```
also beispielsweise 
```latex
  \import{lib/Aufgaben/TM1_Virtuelle_Arbeit_1/Bilder/}{Angabe.pdf_tex}
```
Der Pfad zum Dateinamen ist relativ zum Ordner [Lehre](.), muss also mit 
[lib](lib) oder [documents](documents) beginnen. Wichtig ist der Schrägstrich 
(slash) am Ende des Dateipfads. Die Datei muss mit Endung angegeben werden.

Der Befehl `\input` ist zum Einfügen von kompletten LaTeX-Dateien samt Bilder 
geeignet. Er funktioniert so, dass der Text der eingebundenen Datei ohne 
Veränderung eingefügt wird (analog zur `#include`-Anweisung in C++). Daher sind 
alle Pfade relativ zum Basisordner [Lehre](.) anzugeben.  

Der input-Befehl wird folgendermaßen verwendet:
```latex
\input{Relativer-Pfad-zur-Datei}
```
also beispielsweise
```latex
\input{lib/Aufgaben/TM1_Virtuelle_Arbeit_1/Angabe}
```
Hier ist die Dateiendung nicht nötig, es wird automatisch die Datei mit der 
Endung `.tex` eingebunden. 


6. Builder
----------
Das Kompilieren der Quelldateien wird mit einem in Python geschriebenen Skript 
durch den Befehl
```bash
./scons.py
```
ausgeführt. Folgende Optionen stehen zur Verfügung:

| Option Name            | Beschreibung                                                                            |
| ---------------------- | --------------------------------------------------------------------------------------- |
| `--clean` oder `-c`    | Alle zuvor von scons kompilierten Dateien werden gelöscht.                              |
| `--repo` oder `-r`     | Es wird überprüft, ob alle Quelldateien in das Repository eingecheckt sind.             | 
| `--thorough` oder `-t` | Es wird überprüft, ob alle kompilierten Dateien vorhanden sind und ggf. neu kompiliert. |
| `-j4`                  | Starten von vier Prozessen zum Zwecke der Ausnutzung mehrerer Kerne.                    |
| `--silent` oder -`s`   | Unterdrückt die Ausgabe von LaTeX beim Kompilieren                                      |


In den von scons ausgeführten SConscript-Dateien sind die Anweisungen zum 
Bauen der Dokumente aus den Quelldateien angegeben und es wird eine Liste der 
Abhängigkeiten erstellt. Die Abhängigkeitsliste gibt an, welche Quelldateien von
anderen Quelldateien abhängen. Wird beispielsweise in die Datei `Skript.tex` 
durch den `\input`-Befehl die Datei `Kapitel.tex` sowie mit dem `\import`-Befehl 
das Bild `Bild.pdf_tex` eingebunden, so wird mit der Abhängigkeitsliste 
sichergestellt, dass die Hauptdatei auch dann neu kompiliert wird, wenn das Bild
oder die eingebundene TeX-Datei verändert wurde.

In der Datei `scons.py` wird außerdem eine Liste mit SConscript-Dateien angelegt, die
sich in den Unterordnern des [Lehre](.)-Ordners befinden. Diese Dateien werden 
ebenfalls als Python-Skript ausgeführt. Die SConscript-Dateien selbst können 
wiederum Verweise auf andere SConscript-Dateien haben. Der Aufruf der 
SConscript-Dateien als Python-Skript erfolgt rekursiv.

Anstelle einer regulären SConscript-Datei kann eine lokale SConscript-Datei mit 
dem zusätzlichen Suffix `_local` erstellt werden. Wird also beispielsweise in 
einer SConscript-Datei als Skriptname [TM2/SConscript](documents/TM2/SConscript)
angegeben, so kann im Ordner [TM2](documents/TM2) eine Datei `SConscript_local` 
erstellt werden. Liegt diese Datei vor, so wird sie anstelle der regulären 
SConscript-Datei verwendet. Die `_local`-Dateien dürfen nicht committed werden!

In den SConscript Dateien werden die Dateien definiert, die kompiliert werden 
sollen. Derzeit können Dateien vom Typ `.tex` und `.svg` kompiliert werden. 
In den SConscript-Dateien können Dateien mit dem Befehl
```python
add_files(files=[], install_path=None)
```
hinzugefügt werden.

```python
install_path (Optionales Argument, Default=None)
```
Wird ein Installationspfad angegeben, so werden die aus den angegebenen 
Quelldateien erzeugten Dokumente in den angegebenen Ordner kopiert. Dieser Pfad 
ist relativ zum [Lehre](.)-Ordner anzugeben. Bei Inkscape-Dateien muss ein 
Installationspfad angegeben werden.

Die Dateien, die hinzugefügt werden sollen können entweder manuell eingegeben 
werden, z. B. mit
```python
add_files(files=['MechanikSymbolBib/Uebersicht.svg'], install_path='lib/Inkscape')
```

oder alternativ über den Befehl
```python
scan_files(endswith, maxdepth)
```
hinzugefügt werden. 

Sollen beide Methoden kombiniert werden, wäre beispielsweise diese Vorgehensweise möglich:
```python
tex_files=scan_files(endswith='.tex', maxdepth=2)
all_files=['MechanikSymbolBib/Uebersicht.svg']+tex_files
add_files(files=all_files, install_path='build/')
```

| Variable        | Beschreibung |
| --------------- | ------------ |
| `files`         | Ist ein Array mit den Pfaden der Dateien, die kompiliert werden sollen. Es können ausschließlich LaTeX-Dateien (Endung `.tex`) und Inkscape-Dateien (Endung `.svg`) hinzugefügt werden. Es sind die Pfade relativ zu dem Ordner, in dem die SConscript-Datei liegt anzugeben. |
| `endswith`      | Gibt an, mit welcher Zeichenfolge die zu findenden Dateien enden. |
| `maxdepth`      | Gibt die Suchtiefe an, bis zu der die Dateien mit dem angegebenen Suffix gesucht und hinzugefügt werden. `depth=1` bedeutet, es werden nur Dateien, die sich im Basisordner befinden, hinzugefügt. Für `depth=2` werden zusätzlich die Dateien in den Unterordnern des Basisordners hinzugefügt, aber nicht die Dateien die sich in Unterordnern der Unterordner befinden. |


7. Typischer Workflow
---------------------
Soll eine neue Übungsserie für beispielsweise die TM1-Tutorübung entwickelt werden, gestaltet sich der Workflow etwa folgendermaßen:

### 1) Erstellen der Aufgabe
Erstellen eines Ordners für jede Aufgabe im Verzeichnis lib/Aufgaben/ mit dem Befehl
```bash
mkdir <Ordnername>
```
und den entsprechenden Dateien Aufgabe.tex, Loesung.tex und dem Unterordner 
Bilder/ wenn nötig1. 
Entwicklung der Aufgabe mit Zeichnungen im svg-Format, die im Unterordner 
Bilder/ gespeichert werden. 

### 2) Erstellen des Übungsblatts
Erstellen eines Ordners im Verzeichnis documents/TM1/Tutoruebung/
```bash
mkdir <Ordnername>
```
beispielsweise 
```bash
mkdir W10_Uebung_1
```
Erstellung von Verlinkungen zu Aufgaben im lib-Verzeichnis:
```bash
ln -s <Dateipfad zur Aufgabe> <Link-Name>
```
beispielsweise
```bash
ln -s ../../../../lib/Aufgaben/TM1_Virtuelle_Arbeit_1/ Aufgabe1
```
Erstellung der Datei mit Angabe und Lösung, in die Aufgaben aus dem 
lib-Verzeichnis eingebunden werden. Angabe sieht z.B. so aus:
```latex
  % Beginn Angabe.tex
  \documentclass{lib/Klassen/dokument}
  \begin{document}
  \section*{Aufgabe 1} 
  \input{lib/Aufgaben/TM1_Virtuelle_Arbeit_1/Angabe} 
  \section*{Aufgabe 2} 
  \input{lib/Aufgaben/TM1_Virtuelle_Arbeit_2/Angabe}
  \end{document}
  % Ende Angabe.tex
```

### 3) Erstellung der LaTeX-Dokumente:
Ausführen des scons-Skripts im Hauptverzeichnis (Lehre):
```bash
./scons.py
```
Die Dokumente für die neue Übung ist als pdf im Verzeichnis documents/TM1/Tutoruebung/W10_Uebung_1/ enthalten

### 4) Hochladen 
Die neu generierten Dateien und Ordner können, wenn die Erstellung der 
LaTeX-Dokumente problemlos verlief, auf den git-Server hochgeladen werden:
```bash
git add <Dateinamen>
```
also beispielsweise
```bash
git add Aufgabe.tex Loesung.tex Bilder/
git commit -m"<Kommentar>"
git push
```
Mit der Option `--repo` beim Ausführen von `scons.py` kann geprüft werden, ob alle 
Dateien in das git-Repository hinzugefügt wurden. Updates, die von anderen Teilnehmern am 
git-Server durchgeführt wurden, können heruntergeladen werden mit dem Befehl:
```bash
git pull
```

8. Todo
-------

| Beschreibung | Status |
| ------------ | ------ |
| Python Funktion um zu prüfen, ob alle notwendigen Dateien hinzugefügt wurden. | Erledigt: 29.11.2011 |
| Verbesserung des SConstruct Skriptes (Geschwindigkeit bei der Generierung der Abhängigkeiten) | Erledigt: 18.11.2012 |
| Anpassung von scons.py auf Inkscape 0.91 | Erledigt: 10.05.2016 |

9. Benutzung unter Windows
--------------------------
Das scons-Skript kann auch unter Windows verwendet werden. Wichtig ist, dass die
Pfadvariable für die cmd-Konsole so gesetzt ist, dass inkscape, pdflatex und 
python (Wichtig: Version 2.7, nicht 3.?) direkt von der cmd-Konsole gestartet 
werden können. 


10. Hinweise und Fehlerbehebung
-------------------------------
- Pixelige Vektorgraphiken beim Druck oder bei der Bildschirmdarstellung: Es 
gibt ein Problem beim Export von halbtransparenten Elementen in Inkscape. 
Das bedeutet, dass die Graphik verpixelt dargestellt wird, wenn halbtransparente
Elemente in der Zeichnung sind. Diese können auch verdeckt sein. 
Ist eine Graphik verpixelt, kann die `.svg`-Datei nach dem Stichwort `opacity` 
durchsucht werden. Ein opacity-Wert ungleich 0 oder 1 ist in der Regel die 
Ursache.
- Update auf SuSe 12.3: Manche Pakete sind evtl. nicht mehr installiert. 
Es gibt jedoch die Möglichkeit, mit zypper die Pakete einfach 
nachzuinstallieren. Angenommen, es fehlt das Paket `capt-of`, führt man als 
root den Befehl `zypper in 'tex(capt-of.sty)'` aus. Schriftarten können ebenso installiert werden, z.B.
`zypper in 'tex(pzdr.tfm)'`


11. Git Guidelines
------------------

1. Es ist kein direktes Pushen in den Branch `master` möglich!
2. Es werden nur stabile Versionen aus dem Branch `developer` in den Branch `master` gemerged 
(was nur von den Mitgliedern von AM/Lehre mit Status "Master" gemacht werden kann).
3. `developer` ist der Hauptentwicklungs-Branch. 
4. Feature Branches gehen immer vom Branch `developer` aus und werden immer zurück in `developer` gemerged.