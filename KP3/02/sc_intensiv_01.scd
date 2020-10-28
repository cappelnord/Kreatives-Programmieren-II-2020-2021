// SuperCollider Intensiv 01
// 28.10.2020


// === Ausführung, Blöcke und Post Window ===
// Help: 02. First Steps

// Um Hilfe aufzurufen:
// ... einfach 02. First Steps markieren und mit Ctrl + D
// bzw. Cmd + D um der Hilfe danach zu suchen ...

// In SuperCollider werden oft einzelne Zeilen ausgeführt,
// hierfür den Text-Cursor auf die Zeile legen und mit Ctrl + Return
// bzw. Cmd + Return ausführen.

5 + 5;
"OK".postln;

// Man kann sogar Unter-Ausdrücke einzeln ausführen, hierzu den
// Text markieren (als Beispiel hier einfach mal 2 + 2
// markieren) und seperat ausführen.

2 * 2 + 2;

// Wenn wir mehrere Zeilen gleichzeitig ausführen wollen dann
// schreiben wir sie zusammen in runde Klammern. Mit dem Text-
// Cursor in diesem Block können wir den gesamten Block ausführen.

(
// Wichtig: Anweisungen müssen mit Semikolon beendet werden
// wenn weitere Anweisungen folgen ...
a = 5;
b = 10;
(b * a).postln;
// das Ergebnis des letzten Ausdrucks wird auch im Post window geposted ...
(a + b);
)

// === Arithmetische Operationen ===
// .. funktionieren erstmal so, wie wir es erwarten ...

-2 + 3.5
10 * 5
2  - 1
4  / 3

// Ausblick:
// Help: Operators (eine Auflistung von Binären und Unären Operatoren)



// === Messages ===
// Help: Messages (dort dann zu finden unter References)

// Alles in SuperCollider ist ein Objekt (auch Klassen, Zahlen, ...)
// Wir können Methoden von Objekten aufrufen bzw. den Objekten
// Nachrichten schicken. Das Objekt ist dann zuständig dafür,
// auf die Nachrict zu reagieren.

5.postln;

// .dump ist sehr hilfreich um mehr über ein Objekt zu erfahren
5.dump;
"Hallo".dump;
s.dump;

// Nachrichten können Argumente haben. Argumente stehen dann
// in runden Klammern und werden durch Kommas getrennt.
2.pow(4)
SinOsc.ar(440, 0.5pi)

// Nachrichten können an jegliche Ausdrücke geschickt werden.
// Wir können auch mehrere Nachrichten nacheinander notieren.
// Empfänger der Nachricht ist dann stets der Rückgabewert
// des letzen Ausdrucks.
(
x = 10;
x.sin.postln; // Sinus von 10 wird geposted.
(x + 20).sin.postln; // Sinus von 30
)


// Es gibt 3 verschiedene Notationen um Nachrichten an
// einen Empfänger-Objekt (quasi Methodenaufruf) zu schicken:

2.pow(4); // <-- SuperCollider-typisch
// [Empfänger].[Nachricht]([Argumente])
pow(2, 4);
// [Nachricht]([Empfänger], [Argumente])
2 pow: 4; // <-- in der Regel eher für Binäre Operatoren gedacht
// [Empfänger] [Nacricht]: [Argument 1]


// Wenn wir keine Argumente haben können wir die Klammern
// auch weglassen ...
5.sin();
5.sin;
sin(5);



// === Operatorpräzedenz ===

// WICHTIG: SuperCollider kennt keine Operatorenpräzedenz (Punkt vor Strich)
// ... alle Operationen werden grundlegend von Links nach Rechts ausgeführt.

2 * 4 + 1 * 3; // 27 anstatt 11 (wie wir vermuten könnten)

// Mit Klammern können wir Ausdrücke so gruppieren, dass die
// Auswertungsreihenfolge so ist, wie wir es wollen.

(2 * 4) + (1 * 3); // 11

// Methodenaufrufe bzw. Nachrichten haben trotzdem Vorrang und werden
// vor binären Operatoren ausgewertet.

10 * 2.pow(2)

// Auch hier können wir klammern falles wir es brauchen.

(10 * 2).pow(2)



// === Funktionen, Argumente ===
// Help: Functions

// Eine Funktion die nichts kann ...
{}

// ... alle Ausdrücke in geschweiften Klammern bilden eine Funktion!

// Mit Funktionen werden wir uns noch später mehr beschäftigen, hier
// aber ein kurzes Beispiel: Übertragung einer Python-Funktion nach
// SuperCollider.


/*
def mal(a, b):
   return a * b

mal(2, 10)
*/

(
var mal = {arg a, b;
	// Der letze Ausdruck wird zurückgegeben ...
	// ... kein 'return' notwendig!
	a * b;
};

mal.value(2, 10); // .value ruft die Funktion auf
)

(
// Eine alternative Schreibweise für Parameter/Argumente
// (ich bevorzuge diese ...)
var mal = {|a, b|
	a * b;
};

mal.value(2, 10);
)

(
// Wir können auch Standard-Argumente angeben. Diese
// Argumente werden benützt, falls beim Funktionsaufruf
// nicht alle Argumente angegeben sind ...
var mal = {|a=10, b=3|
	a * b;
};

mal.value(2);
)


// ... erstmal wichtig für uns: Wir könnten Funktione
// (die .ar UGens beinhalten) als Klang abspielen und dann
// hören! (Wenn der scsynth Server gebooted ist ...)

// Help: 05. Functions and Sound

{ SinOsc.ar(440) * 0.1 }.play

// !!!
// Beendet den Klang wieder mit Ctrl + . bzw. Cmd + .
// !!!

// ... vielleicht nervt es euch, dass der Klang nur
// aus einem Lautsprecher (von links) kommt. Ein ! 2
// am Ende des Klangs erweitert ihn auf 2 Kanäle.

{ SinOsc.ar(440) * 0.1 ! 2}.play

// (zu Mehrkanal-Klang später mehr ...)

// Das Scope hilft uns den Klang visuell zu inspizieren:

s.scope;

// Mit .plot können wir kurze Segmente des Klangs
// plotten ohne ihn zu hören.

{ SinOsc.ar(440)}.plot(0.025);

// Multipliziert man ein Signal mit einer Konstanten
// skaliert man die Amplitude. Im Idealfall
// haben Audiosignale bei der Ausgabe einen
// Umfang von -1 bis 1. (wie auch in Max/MSP).

{ SinOsc.ar(440) * 0.1}.plot(0.025);

// Addition von Signalen mischen diese zusammen.

// Bei diesem Beispiel auch die Operatorpräzedenz beachten!
// Beide Sinus-Oszillatoren werden erst vermischt, dann skaliert.

{ SinOsc.ar(440) + SinOsc.ar(220) * 0.1 }.plot(0.025);
{ SinOsc.ar(440) + SinOsc.ar(220) * 0.1 ! 2}.play;

// Wichtig: Schaut auch mal in die Hilfe von SinOsc rein!
// Help: SinOsc

// Signale können miteinander multipliziert werden ...
// (AM-Synthese anybody ??)

{ SinOsc.ar(440) * SinOsc.ar(0.2)}.play
{ SinOsc.ar(440) * SinOsc.ar(0.5)}.plot(2)

// Mit .poll können wir bei laufenden Syntheseprozessen
// uns einzelnen Werte kontinuierlich ausgeben lassen

{ SinOsc.ar(440) * SinOsc.ar(0.2).poll ! 2}.play


// === .ar/.kr ===

// Help: 08_Rates

// .ar - Audio Rate (z.B. 44100 Werte pro Sekunde)
// .kr - Control Rate (in der Regel 1 Wert je 64 Audio Samples)

// .kr Vorteil: Weniger Werte müsse berechnet werden.

// In einigen Kontexten ist .kr notwendig (z.B. Arbeit
// mit .kr Bussen, bestimmte UGens die nur .kr unterstützen, ...).
// In der Regel sind aber unsere Rechner schnell genug um
// Kontrollsignale auch in .ar zu berechen.


{ SinOsc.ar(440) * SinOsc.kr(0.2).poll ! 2}.play


// Hinweis: Bei schnellen Signalen kommt es zu Verzerrungen:

// klingt sauber
{ SinOsc.ar(440) * SinOsc.kr(0.2) * 0.1 ! 2}.play

// klingt genauso sauber ...
{ SinOsc.ar(440) * SinOsc.ar(0.2) * 0.1 ! 2}.play

// klingt dirty
{ SinOsc.ar(440) * SinOsc.kr(110) * 0.1 ! 2}.play

// klingt sauber
{ SinOsc.ar(440) * SinOsc.ar(110) * 0.1 ! 2}.play

// ... hierzu an anderer Stelle auch noch mehr.


// === Ndef ===

// Help: Ndef

// Es gibt viele ...def Objekte in SuperCollider, sie alle haben einen
// ähnlichen Aufbau. Wichtig ist: Wir legen hier ein Objekt unter einem Namen
// ab (der Name in Form eines Symbols) und könne dann wieder auf unser
// Objekt zurückgreifen. Außerdem umschließt der Ndef das Objekt (in unserem
// Fall eine Synthese-Funktion) und ermöglicht weitere Funktionalitäten.

// !!!
// Wir wollen im Kurs erstmal für alle Syntheseprozesse Ndefs nutzen.
// !!!

Ndef(\nix, {})

// === Symbole ===

// Help: Symbol

// In SuperCollider werden oft Dinge mit Symbolen benannt. Sie sind
// dabei weniger vergleichbar mit Variablen-Namen, mehr mit Strings
// die als Schlüssel zur Speicherung und Wiederauffindung von Objekten
// benützt werden (z.B. Keys in Dictionaries).

\apfel.dump
\birne.dump
'apfel'.dump
'birne'.dump

// Beide Schreibweisen sind äquivalent.
// .. mehr zu Symbolen in der Zukunft.


// Definiert den Ndef
Ndef(\sinus, {SinOsc.ar(440) * 0.1 ! 2})

// Spielt den Ndef ab!
Ndef(\sinus).play
Ndef(\sinus).stop

Ndef(\sinus).play

// Wir können den Klang durch einen neuen Klang ersetzen.
Ndef(\sinus, {SinOsc.ar(220) * 0.1 ! 2})

// Durch das Setzen einer fadeTime können wir Crossfades
// zwischen alten und neuen Klängen ermöglichen.
Ndef(\sinus).fadeTime = 2;

Ndef(\sinus, {SinOsc.ar(880) * 0.1 ! 2})
Ndef(\sinus, {SinOsc.ar(100) * 0.1 ! 2})

// Tipp: Manchmal kann es sinnvoll sein einen Ndef
// neu zu initalisieren ...

Ndef(\sinus).clear; // einfach Code oben wieder ausführen ...


// Wir können mehrere Ndefs paralell laufen lassen.

// (alternative Symbol-Schreibweise)
Ndef('saw', {Saw.ar(200) * 0.1 ! 2});
Ndef('saw').play
Ndef('saw').fadeTime = 2

// Mit Line und XLine können wir einfache Verläufe über die Zeit
// erstellen ...
Ndef('saw', {Saw.ar(Line.kr(220, 880, 30).poll) * 0.2 ! 2});
Ndef('saw', {Saw.ar(XLine.kr(220, 880, 30).poll) * 0.2 ! 2});

// Help: Line bzw. XLine

// Unsere Synthese-Funktionen können auch Parameter haben ...
Ndef(\bass, {|freq=50, amp=0.3| Saw.ar(freq) * amp ! 2})
Ndef(\bass).play

// Über .set können wir den Parametern dann Werte zuweisen
Ndef(\bass).set(\freq, 200)
Ndef(\bass).set(\amp, 0.05)


// BONUS BONUS: Für unsere Ndefs wird auch automatisch ein GUI erstellt.
// Hier können wir Output-Level anpassen, Prozesse starten/stoppen und
// sogar Parameter steuern.

NdefMixer(s);
// (s ist aktueller Klangsynthese Server)


// MouseX und MouseY zur Steuerung
Ndef(\theremin, {SinOsc.ar(MouseY.kr(220, 880)) * MouseX.kr(0, 1) * 0.2 ! 2});
Ndef(\theremin).play

// Und noch ein kryptisches Kommando um alle Ndefs zu stoppen ...
Ndef.all.do(_.stop)