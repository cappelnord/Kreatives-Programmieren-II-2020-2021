/* =====================================

   ------------------------------------
   Übungen zu Kreatives Programmieren 3
   ------------------------------------

   Sitzung 08 - 10.12.2020

===================================== */



//----------------
// DATENSTRUKTUREN
//----------------



// ------- ARRAYS & LISTEN -------

/*
  Bei Arrays handelt es sich um fixe Datenstrukturen
  d.h. sie müssen mit einer fixen größe initialisiert
  werden.
*/


a = [];
a.size;

a[0];  // gibt nil zurück
a[1];  // ...

a = Array.newClear(3);  // Initialisierung eines leeren Arrays
                        // mit fixer Größe.

// In Arrays können beliebige Datentypen abgespeichert werden.
a.put(0, "string");
a.put(1, 23.65);
a.put(2, \symbol);

a.put(3, 56);  // Wir bekommen hier einen Error da wir in einen
               // nicht existenten Index schreiben möchten.


// Auf Arrays kann man auch viele Methoden anwenden:
// z.B. die ".do" Methode mit der über jedes Element
// des Array iteriert und eine Funktion ausgeführt
// werden kann.
(
a.do(
	{ |item, i|
		if (item.isString) {
			(i + item.asString + ": yeah, i'm a string").postln
		} {
			(i + item.asString + ": nope, i'm not a string").postln
		};
	}
);
)


//---------------------------------------------
// Kurzes Beispiel zu Strings und "typecasting"
b = 3;
b.isString;
b = b.asString;
b.isString;

c = 2 + "zwei";
c;
c.isString;
//---------------------------------------------


// Um in der ".do" Methode Werte des Arrays tatsächlich
// ändern/überschreiben zu können muss explizit auf
// diese verwiesen werden. Das "item" Argument überschreibt
// die Werte nicht.
(
a.do(
	{ |item, i|
		var rndInt = 10.rand;

		rndInt.postln;

		//item = rndInt;  // wird nicht überschrieben

		a[i] = rndInt;
	}
);
)


// Da Arrays keine dynamischen Strukturen sind, müssen in
// Fällen in denen man eine variable Größe braucht Arrays
// explizit neu instanziert werden.
(
fork{
	var size, array;

	inf.do{

		size = 10.rand;
		array = [];

		("size: " ++ size).postln;

		size.do({ |item, i| array = array ++ 500.rand; });  // "array" wird hier explizit überschrieben.

		("array: " ++ array).postln;

		"--------".postln;

		0.3.wait;
	}
}
)


// Listen sind dxnamische Strukturen und können belibig in ihrer
// Größe variieren.
l = List.newClear();
l;

l.add(10.rand);


// Hier lassen wir eine Liste bis zur Größe "size" wachsen
// um dann eine neue Liste zu initialisieren und den gleichen
// Prozess von vorne zu starten.
(
var size = 20, list;

fork{
	inf.do{ |i|

		if ((i % size) == 0) {
			list = List.newClear();
		} {
			list.add(100.rand);
		};

		("i: " ++ i).postln;
		("size: " ++ list.size).postln;
		list.postln;
		"".postln;

		0.1.wait;
	}
}
)

//-------------------------------------------
// Arrays zur Speicherung von Synth-Instanzen

(
SynthDef(\daaa, { | freq = 400, pan = 0, amp = 0.5|

	var snd = SinOsc.ar(freq);

	Out.ar(0, Pan2.ar(snd, pan) * amp)
}).add;
)


// Wie erwähnt können Arrays sowie andere Datenstrukturen genutzt
// werden um Beliebige Datentypen/Objekte zu speichern, dies trifft
// auch auf z.B. Funktionen oder in diesem Fall Synth-Instanzen zu.

// Der Vorteil Synth-Instanzen in Arrays abzuspeichern ist, dass wir
// dann auf eben diese Instanzen über den Index im Array zugreifen
// können und einzelne Instanzen nicht jeweils unter einer eigenen
// Variable abspeichern oder explizit über die jeweiligen Node-IDs
// ansprechen müssen.

a = [Synth(\daaa)];
a[0].set(\freq, 200);


// Hier speichern wir beim ersten Durchgang unserer Schleife
// n (n = size) Synth-Instanzen in einen Array und verändern
// in den folgenden Durchläufen die Frequenzen der einzelnen
// Synths.
(
var size = 20, synthArray = Array.newClear(size);

fork{
	inf.do{ |i|

		synthArray.size.do{ |j|

			if (i == 0) {
				synthArray.put(j, Synth(\daaa, [\freq, (100 + 4000.rand), \pan, ((j / size) * 2) - 1, \amp, (1 / size)]));
			} {
				synthArray[j].set(\freq, (100 + 4000.rand));
			}
		};

		0.1.wait;
	}
}
)
//-------------------------------------------



// ------- DICTIONARIES, IDENTITY DICTIONARIES & EVENTS -------

/*
  Dictionaries (sowie IdentityDictionaries & Events) sind Datensrukturen, die einem
  "Key -> Value" Paar Prinzip folgen. Unter spezifischen Keys werden Daten (Values)
  abgespeichert, welche dann über die jeweiligen Keys abgerufen werden können.

  Bei Dictionaires handelt es sich im Gegensatz zu Arrays um nicht geordnete
  Datenstrukturen.

  Dictionaries, IdentityDictionaries & Events bieten ein gutes Interface zum
  Erstellen eigener Datenstrukturen und können beliebige Datentypen/Objekte
  speichern.
*/


d = Dictionary.new(3);  // Erstellen eines Dictionaries mit initial Kapazität 3.
d;

// Hinzufügen von Einträgen ("key -> value" Paaren) in das Dictionary
// über die Association-Notation (->).
d.add(\wert -> 10);
d.add(\neuerWert -> 34);
d.add(\nochEinWert -> 5);
d.add(\andAgain -> 4);

// Hinzufügen von Einträgen in das Dictionary über die ".put" Methode.
// "key -> value" Paare werden hier von der Methode aus den Argumenten
// erzeugt.
d.put("key", 56.345);
d.put(12312, "value");

d.put(\myFunc, { |x| x * x; });

d.at(\wert);
d.at("key");
d.at(12312);

d.at(\myFunc);
d.at(\myFunc).value(3);


// Gegensatz zu Dictionaries werden in IdentityDictionaries Keys nach
// "Identities" abgefragt und nicht nach "Equalities".

e = IdentityDictionary.new(3);
e.put("key", 56.345);

e.at("key");  // gibt nil aus da der string "key" nicht auf das selbe
              // Objekt verwiest unter welchem wir den Eintrag abgespeichert
              // haben, obwohl beide string "equal" sind.

"key" == "key";  // erfüllt die "Equality"
"key" === "key";  // erfüllt NICHT die "Identity"

// Wenn wir den string den wir als Key benutzte möchten hingegen unter einer
// Variable abspeichern, können wir diese dann zur Abfrage nutzen und würden
// auf das selbe Objekt verweisen und somit die "Identity" erfüllen.
k = "newKey";
e.put(k, 34.76);
e.at(k);


// Events bilden von der Nutzung her, das einfachste Interface um eigene
// Datenstrukturen zu ertellen.

e = ();  // Leeres Event.

(
e = (
	\haha: 5,  // erster Eintrag
	123: { |x = 2| x + x }  // zweiter Eintrag
);
)

// Auf Keys kann über die Index-Notation, die uns von Arrays bekannt ist
// zugegriffen werden.
e[\haha];
e[123];



// ------- EVENTS & MARKOV-KETTEN -------

/*
  Markov-Ketten bilden einfache stochastische Prozesse und eignen sich sehr gut
  dazu Zustandsänderungen eines Systems zu modellieren.

  Das Basis Prinzip beschreibt mit welcher Wahrscheinlichkeit ein gewisser
  Zustand in einen anderen Übergeht.

  --------

  Inspiriert von etwas Funktionsharmonik möchten wir nun als Bepisiel anhand
  von Events Datenstrukturen bauen um mögliche Zustandsübergänge zwischen
  Akkorden (Dreiklängen) zu beschreiben und somit harmonische Bewegungen zu
  modellieren.
*/


(
var transitionMatrix, chords, currChord = \cmaj, nextChord;

// Dieses Event sperchert eine Übergangsmatrix, die beschreibt
// in welche möglichen folgenden Zustände (Values bestehend aus Arrays)
// ein Akkord (hier die Keys) übergehen kann.
transitionMatrix = (
	\cmaj: [\gmaj, \amin],  // C-Dur kann nach G-Dur und A-Moll
	\gmaj: [\cmaj, \amin],  // G-Dur kann nach C-Dur und A-Moll
	\amin: [\cmaj]          // A-Moll kann nach C-Dur
);

// In diesem Event weisen wir den Keys die jeweiligen Dreiklänge
// (ausgedrückt in Arrays mit Midi-Noten) zu.
chords = (
	\cmaj: [60, 64, 55],
	\gmaj: [55, 59, 62],
	\amin: [57, 60, 64]
);

fork{
	inf.do{ |i|

		"------------".postln;
		("current chord: " ++ currChord.asString + chords[currChord]).postln;

		// ----------------------------------------------------------------------
		// Hier ermitteln wir anhand des aktuellen Zustands "currChord" den
		// folgenden Zustand "nextChord" in dem wir in unserer "transitionMatrix"
		// den Value der unter dem Key "currChord" abgespeichert ist abfragen
		// und aus diesem Array der möglichen Folgezustände einen beliebigen
		// Zustand über die ".choose" Methode auswählen.

		nextChord = transitionMatrix[currChord].choose;

		// Man könnte hier mit gewichteten Wahrscheinlichkeiten experimentieren
		// und nicht nur über ".choose" einen beliebigen Folgezustand auswählen.
		// ----------------------------------------------------------------------

		("next chord: " ++ nextChord.asString + chords[nextChord]).postln;
		"------------".postln;
		"".postln;

		currChord = nextChord;  // Aktualisieren von "currChord" auf "nextChord"

		0.3.wait;
	}
}
)
