/* =====================================

   ------------------------------------
   Übungen zu Kreatives Programmieren 3
   ------------------------------------

   Sitzung 07 - 03.12.2020

===================================== */



//----------------------------
// VARIABLEN, SCOPE & CLOJURES
//----------------------------


(
f = { | a, b |
	var c;

	c = a * b;

	c
};
)

f.value(2, 3);



// ------- CLOJURE -------

/*
  Unter Clojures bezeichnet man ein Konstrukt nachdem Variablen einer
  äußeren Funktion auch für Funktionen die innerhalb eben einer sochen
  "kapselnden" Funktion definiert sind sichtbar bleiben (bzw. einen
  Zugriff erlauben) auch wenn die äußere Funktion schon ihre
  Ausführung terminiert hat.
*/


(
var counter;

// Definition der Funktion "counter" (Äußerer Kontext)
counter = { | currVal = 0, step = 1 |

	// Innere Funktion und Rückgabewert von "counter" (Innerer Kontext)
	{
		var tmp;  // Lokale Variable des inneren Kontexts

		// Auf die Variablen "currVal" und "step" des äußeren
		// Kontexts wird auch hier zugegriffen.
		tmp = currVal;
		currVal = currVal + step;

		tmp;  // Ruckgabewert der inneren Funktion
	}
};

// Abspeicherung der Rückgabewerte zweier Instanzen der Funktion "counter"
// mit unterschiedlichen Werten für die Argumente "currVal" und "step"
// unter den Variablen "x" und "y"
x = counter.value(5, 2);
y = counter.value(12, 3);
)

// Da der Rückgabewert der Funktion "counter" eine Funktion ist
// (die Funktion, die den inneren Kontext definiert) sind jetzt
// unter den Variablen "x" und "y" zwei Funktionen abgespeichert.
x;
y;

// Wenn wir nun die Funktionen ausführen bekommen wir die jeweiligen
// Rückgabewerte ("tmp").

// Obwohl die unter "x" und "y" abgespeicherten Funktionen die
// ursprüglichen Rückgabewerte zweier Instanzen der Funktion "counter"
// sind und die jeweiligen Instanzen der Funktion "counter" ihre Ausführung
// schon terminiert haben, ist es den unter "x" und "y" abgespeicherten
// Funktionen dennoch weiterhin möglich auf die im äußeren Kontext
// definierten Variablen "currVal" und "step", die für die Berechnung
// im inneren Kontext verwendet werden, zuzugreifen.

// Das kann man sich nun veranschaulichen in dem man die Funktionen,
// die unter "x" und "y" abgespeichert sind mehrmals ausführt.
// Man sieht in beiden Fällen inkrementiert der Rückgabewert "tmp"
// dadurch, dass er weiterhin Zugriff auf die Variablen "currVal"
// und "step" hat.

x.value;  // ---> mehrmals ausführen!
y.value;  // ---> mehrmals ausführen!




//-----------
// FUNKTIONEN
//-----------


// ------- FUNKTIONSSCHACHTELUNGEN -------

f = { 2 };
f.value;


g = { | func | func.value + 1 };  // Die Funktion bekommt eine Funktion als Argument,
                                  // dessen Rückgabewert für in der Addition verrechnet
                                  // wird.
g.value(f);


f = { SinOsc.ar(400) };  // Funktion hat ein UGen als Rückgabewert
f.value;
f.play;

g = { | func | func.value * SinOsc.ar(10) }; // Funktion hat ein BinaryOpUGen als Rückgabewert
                                             // d.h. eine Binäre Operation auf Zwei UGens
g.value(f);

g.value(f).play;  // das geht nicht...
{ g.value(f) }.play;  // das geht!



// --------------------------------------------------
// Verschachtelung von audioverarbeitenden Funktionen
// (Ringmodulation & Frequenzmodulation)

(
var wrapper, ring_mod, inner_func;

// Funktion zur Kapselung einer inneren Funktion
wrapper = { | func |

	// Innere Funktion zur Frequenzodulation
	{
		| in |

		var freq_mod = SinOsc.ar(40 + in.range(-180, 180));

		func.value(freq_mod);
	}
};

// Funktion zur Ringmodulation
ring_mod = { | in |
	in * SinOsc.ar(MouseX.kr(0.2, 20))
};

// Input für "wrapper" und Speichern des Rückgabewertes von "wrapper"
inner_func = wrapper.value(ring_mod);

// Input für die innere Funktion von "wrapper" und Ausführung
// der ganzen Kette!
{ inner_func.value(SinOsc.ar(MouseY.kr(50, 500))) }.play;
)
// --------------------------------------------------




//------------------------
// SCHLEIFEN & BEDINGUNGEN
//------------------------

(
10.do{ |i|

	i.postln;

	0.5.wait;    // Wartezeit kann hier NICHT benutzt werden
	             // da außerhalb einer Routine aufgerufen.
};
)


(
var wt;

// Durch das Kapseln der Schleife in einer Routine (fork)
// kann eine Wartezeit eingeführt werden.
fork{
	10.do{ |i|

		i.postln;

		wt = 5.0.rand;

		wt.wait;
		wt.postln;
	};
}
)


(
var wt;

fork{
	10.do{ |i|

		i.postln;

		wt = 5.0.rand;
		wt.postln;

		// ---- IF-ELSE-BLOCK -----
		if (wt >= 3) {
			// if
			"too much to wait!".postln;
			wt = 0.1;
		} {
			// else
			"alright, still have a couple of instants...".postln;
		};
		// ------------------------

		wt.wait;
	};
}
)



// ------- COLLATZ-PROBLEM -------

/*
  Mit Schleifen lassen sich auch ganz gut rekursive Algorithmen implementieren.

  Als Beispiel wollen wir uns das Collatz-Problem auch gennant die (3n+1)-Vermutung
  anschauen. Es handelt sich hierbei um einen einfachen rekursiven Algorhitmus zur
  Erzeugung von Zahlenreihen.

  Trotz seiner Enfachheit, weisen die daraus resultierenden Zahlenfolgen eine
  verblüffende Eigenschaft auf für die es bisher noch keine Erklärung gibt:
  Sie münden alle in der Zahlenfolge (4, 2, 1, ...).

  Bei dem Collatz-Problem handelt es sich um eines der großen noch nicht
  gelösten Probleme der Mathematik.

  ------------------

  Der Algorithmus:

  - Beginne mit einer beliebigen natürlichen Zahl n > 0.
  - Ist n gerade, nimm als nächstes n / 2.
  - Ist n ungerade, nimm als nächstes 3n + 1.
  - Wiederhole die Schritte mit der erhaltenen Zahl.
*/


// ----------------------------------------------------------------
// Generierung der Collatz-Zahlenfolge in einer Schleife.

(
var collatz, init = 19, an, anm1;

// Funktion zur Berechnung der nächsten Zahl in der
// Collatz-Zahlenfolge
collatz = { | prev |

	var curr;

	if ((prev % 2) == 0) {
		curr = prev / 2
	} {
		curr = (3 * prev) + 1
	};

	curr
};

an = init;  // Anfangswert

fork{
	inf.do{

		anm1 = an;  // Aktualisieren des vorherigen Wertes auf den
		            // aktuellen Wert.

		an = collatz.value(anm1);  // Berechnung des neuen "aktuellen" Wertes.

		an.postln;

		0.1.wait;
	};
}
)
// ----------------------------------------------------------------


// ----------------------------------------------------------------
// Hier generieren wir pro Iteration in unserer inf-Schleife Listen
// mit Collatz-Zahlenfolgen der Länge "numIter" mit randomisierten
// Anfangswerten ("init").

(
var collatz, list, numIter = 30, init, an, anm1;

collatz = { | prev |

	var curr;

	if ((prev % 2) == 0) {
		curr = prev / 2
	} {
		curr = (3 * prev) + 1
	};

	curr
};

fork{
	inf.do{

		list = List.newClear();

		init = (1 + 19.rand);
		an = init;

		numIter.do{

			anm1 = an;

			an = collatz.value(anm1);

			list.add(an);
		};

		list.postln;

		1.0.wait;
	};
}
)
// ----------------------------------------------------------------