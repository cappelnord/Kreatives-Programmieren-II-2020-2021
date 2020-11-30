/* =====================================

   ------------------------------------
   Übungen zu Kreatives Programmieren 3
   ------------------------------------

   Sitzung 06 - 26.11.2020

===================================== */


s.boot;
s.scope;


//------------------
// VARIABLEN & SCOPE
//------------------


// Mit "Scope" bezeichnet man die Sichtbarkeit bzw. den Gültigkeitesbereich
// von Variablen.


//---------------------------------------------------------------------------
// INTERPRETER-VARIABLEN

// SuperCollider stellt uns per default Interpreter-Variablen zur Verfügung.
// Diese werden mit den Buchstaben a..z (klein geschrieben) gekennzeichnet
// und sind global gültig d.h. man hat von überall (im Programm) Zugriff
// darauf.

a;  // Interpreter-Variable
a = 3;  // Zuweisung eines Wertes


a = 1;
b = 5;

a + b;

b = a;

a + b;

c = a + b;
c;


A  // Wenn wir das großgeschriebene "A" ausführen sehen wir das wir den
   // Fehler "Class not defined." bekommen. Das liegt daran, dass Super-
   // Collider bei einer Großeschreibweise von einer Klasse ausgeht.


// Per default ist die Interpreter-Variable "s" an den default Server
// gebunden. Es empfiehlt sich diese nicht zu überschreiben.

s;  // Interpreter-Variable "s" gebunden an den default Server.
Server.default;  // Default Server


this; // "this" verweist auf den Interpreter.
this.inspect;  // mit der ".inspect" Methode kann man alle Variablen per
               // GUI einsehen.
//---------------------------------------------------------------------------


//---------------------------------------------------------------------------
// LOKALE VARIABLEN

// Lokale Variablen werden mit dem Keyword "var" gekennzeichnet und haben
// wie der Namen schon sagt nur einen lokalen Gültigkeitsbereich z.B. in
// Codeblöcken und Funktionen.

(
var a = 3;  // Lokale Variable "a" und Wertzuweisung.

a
);


(
var a = a;  // Der Versuch die Interpreter-Variable "a" der lokalen
            // Variable "a" zuzuweisen scheitert, da der Interpreter
            // bei der Zuweisung schon die lokale Variable "a" definiert
            // hat und im lokalen Kontext "a" nun auf die lokale Variable
            // verweist.

a
);


(
var local = a;  // Um den Konflikt von oben zu lösen muss man auf die
                // Namensgebung achten.

                // ACHTUNG: Es empfiehlt sich jedoch nicht Variablen
                // aus lokalen und globalen Kontexten zu vermischen.

                // Es gilt: "So lokal wie möglich, so global wie nötig!"

local
);
//---------------------------------------------------------------------------


//---------------------------------------------------------------------------
// UMGEBUNGSVARIABLEN

// In SuperCollider besteht die Möglichkeit eigene Umgebungen ("Environments")
// für den Gültigkeitsbereich von sogenannten Umgebungsvariablen zu definieren.
// Umgebungsvariablen werden mit der "~" Notation gekennzeichnet.

~envVar = 5;  // Umgebungsvariable und Wertzuweisung.
~envVar;



// Ein Environment ist ein IdentityDictionary in dem die der Umbgebung zugehörigen
// Variablen jeweils einem Wert zugewiesen sind.

IdentityDictionary  // Ein IdentityDictionary ist eine Datenstruktur, die "key->value"
                    // Paare abspeichert.

// Im Gegensatz zu einem normalen Dictionary handelt es sich bei IdentityDictionaries
// um Identities.

// Der Unterschied zwischen Identities und Equalities lässt sich gut mit den
// jeweiligen logischen Operatoren demonstrieren.

[1, 2] == [1, 2]; // Equality Operator
[1, 2] === [1, 2]; // Identity Operator

a = [1, 2];
b = [1, 2];

a == b;  // Die Werte der Arrays "a" und "b" sind gleich und bestätigen somit
         // den Equality Operator

a === b; // Die Werte der Arrays "a" und "b" sind zwar gleich aber die Variablen
         // verweisen nicht auf das selbe Objekt und bestätigen somit NICHT den
         // Identity Operator

a = [1, 2];
b = a;

a == b;  // Equality ergibt weiterhin "true".
a === b;  // Identity ergibt jetzt auch "true" da a und b aud das selbe Objekt
          // verweisen.



// Per default befindet man sich im "topEnvironment" gekennzeichnet durch die
// gleichnamige Pseudovariable.

// Die Pseudovariable "currentEnvironment" speichert hingegen die aktuelle
// Umgebung und ist somit per default gleich dem "topEnvironment".

topEnvironment;
currentEnvironment;

topEnvironment === currentEnvironment;


// Alle Umgebungsvariablen die im "topEnvironment" gespeichert sind lassen sich
// als "globale" Variablen nutzen.

// ACHTUNG: Dies kann jedoch zu Problemen führen sobald sich die Umgebung ändert.
// Es wird geraten Vorsicht walten zu lassen!


// Eine neue Umgebung kann mit der "Environment" Klasse erstellt werden.

e = Environment.make{ ~newEnvVar = 9 };  // Erstellen einer neuen Umgebung mit
                                         // der Variable "~newEnvVar"

topEnvironment === currentEnvironment;  // "currentEnvironment" ist nicht mehr
                                        // das "topEnvironment"

~newEnvVar;  // Die Variable ist hier noch nicht gültig da wir das Environment
             // noch nicht aktiviert haben und uns noch im "topEnvironment"
             // befinden.

e.push;  // Aktivieren des Environments

~newEnvVar;

~envVar;  // Die Variable ist nicht mehr in unserem neuen Environment gültig.

a;  // Interpreter-Variablen sind nach wie vor in allen Umgebungen gültig.

e.pop;  // Deaktivieren der Umgebung und Rückkehr zum "topEnvironment".
//---------------------------------------------------------------------------



//-----------
// FUNKTIONEN
//-----------


// Funktionen werden mit geschweiften Klammern definiert und definieren Operationen
// die ausgeführt werden sobald eine "value" Nachricht erhalten wird.
// Funktionsdefinitionen haben keine Typen-Angabe.

{};  // Eine Leere Funktion

f = {};
f;

f.value;  // Der "return" Wert einer leeren Funktion ist "nil"
f.();  // Alternative Schreibweise für ".value"


f = { 2; };  // Es wird immer der letzte Wert einer Funktion ausgegeben
f.value;


(
f = { | a |

	a
}
)

f.value(10);
f.value(0.234);
f.value("hallo");
f.value('hallo');
f.value(10.rand);


(
f = { | a |

	a * a;
}
)

f.value(10);
f.value(0.234);
f.value("hallo");
f.value('hallo');
f.value(10.rand);


(
f = { | a, b, c |  // Angabe der Argumente einer Funktion mit "pipe" Schreibweise

	// Alternative Schreibweise für Argumnete
	/* arg ... , ... , ... ; */

	var d;  // Lokale Variable mit Gültigkeit innerhalb der Funktion

	d = a + b;

	c * d;  // "return" Wert
}
)

f.value;  // Wir bekommen einen Fehler da wir die Funktion aufrufen jedoch
          // weder Werte für die Argumente im Funktionsaufruf angegeben noch
          // Argumnete auf default Werte in unserer Funktion initialisiert haben.

f.value(2, 3, 4);


(
f = { | a = 2, b = 3, c = 4 |  // Initialisierung der Argumente mit default Werten.
	var d;

	d = a + b;

	c * d;
}
)

f.value;  // Die Funktion berechnet jetzt die Operationen mit den default Werten
f.value(3, 4, 5);


(
f = { | a ... b |  // Durch diese Schreibweise kann man nun nach Angabe des Wertes
	               // für das erste Argument "a" unserem Funktionsaufruf beliebig
	               // viele weitere Werte angeben, die als Array dem Argument "b"
	               // zugewiesen werden.
	var c, d;

	c = b[1];

	d = a + b[0];

	c * d;
}
)

f.value(2, 3, 4, 5, 6, 7);



// Funktionen findet man z.B. auch in Methoden die auf Arrays angewandt
// werden können.

a = [1, 2, 3, 4];

a.do({ | item, i | (item * 2).postln; });

a.do({ | item, i | item = (item * 2); });  // Nicht destruktive Operation

a.do({ | item, i | a[i] = (item * 2); });  // Um die Werte im Array zu überschreiben
                                           // muss man explizit auf das Element
                                           // verweisen.
a;


(
f = { | a ... b |

	b.do({ | item, i | b[i] = (item * a) });  // Auf das Argument "a" hat man auch in
                                              // der inneren Funktion der ".do" Methode
	                                          // Zugriff.

	b
}
)

f.value(2, 1, 2, 3, 4);
f.value(2, 1, 2, 3, 4, 5, 6, 7, 8, 9);
f.value(2, 1);
f.value(2);



// Funktionen können auch UGens zurückgeben bzw. Operationen auf
// UGens ausführen.

f = { SinOsc.ar() };
f.value;  // Rückgabe Wert ist "a SinOsc"
f.play;  // Wendet die ".play" Methode auf die Funktion an


f = { SinOsc.ar() * 0.5 };
f.value;  // Rückgabe Wert ist "a BinaryOpUGen" da es das Resultat einer Operation
          // auf das UGen ist.
f.play;


{ SinOsc.ar() * 0.5 }.play;  // Die ".play" Methode wrappt das UGen in unserer Funktion
                             // in einen SynthDef und startet danach eine Synth Instantz.



// Funktionen akzeptieren auch andere Funktionen als Eingabewert.
// Somit kann man Funktionen beliebig verschachteln.

f = { | x | x * x };
f.value(2);

f.value(f.value(2));
f.(f.(f.(f.(2))));

g = { | x | x + f.(2) };
g.value(10);

g = { | func | func.(2) };
g.value(f);
