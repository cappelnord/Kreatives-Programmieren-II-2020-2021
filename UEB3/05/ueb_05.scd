/* =====================================

   ------------------------------------
   Übungen zu Kreatives Programmieren 3
   ------------------------------------

   Sitzung 05 - 19.11.2020

===================================== */


s.boot;
s.meter;
s.scope;
s.freqscope;

s.plotTree; // Node Tree GUI


// Node im Node Tree überwachen.

Ndef(\a, { | amp = 0.5 | SinOsc.ar(400) * amp });

Ndef(\a).play;
Ndef(\a).stop;
Ndef(\a).clear;



// ---------
// SynthDefs
// ---------


/*

 SynthDefs stellen im Gegensatz zu Ndefs nicht "einzigartige" Instrumente dar,
 sondern Instrument-Definitionen, aus denen man belibieg viele Instantzen d.h.
 "konkrete" Instrumente über die "Synth" Klasse erstellen kann.

*/


// Test-SynthDef

(
SynthDef(\test, { | freq1 = 400, freq2 = 50, amp = 0.5 |

	var snd;

	snd = SinOsc.ar(freq1) * SinOsc.ar(freq2);

	Out.ar(0, snd * amp);
}).add;
)


Synth(\test); // Einmaliges erstellen und direktes abspielen eines Synths
              // wie definiert im SynthDef "\test"

Synth(\test, [\freq1, 300, \freq2, 200]); // Erstellen mit expliziten Werten Werten
                                          // für Argumente. --> Array mit "key <-> value" Paaren


// Sobald man über "Synth" ein Instrument erstellt und ausführt wird eine neue Node erstellt
// (siehe Node Tree oder Post-Window). Bei mehrmaligem Ausführen werden weitere Synths auf
// neuen Nodes instanziiert.

// Wir haben über die obige Art Synths auszuführen nun aber keinen direkten Zugriff auf die Synths
// um diese stoppen zu können. Da keine Envelope im "SynthDef" angegeben ist spielen diese einfach
// weiter.

// Den Klang kann man nun mit "cmd ." stoppen.



// Alternativ können wir unsere Synths unter Variablen speichern auf die wir Zugriff haben um
// die darunter gespeicherten Synths/Nodes zu "freeen".

x = Synth(\test); // Hier ist zu beachten, dass durch mehrfaches Ausführen die Variable
                  // überschrieben wird und somit die Referenz auf davor abgespeicherte
                  // Synths/Nodes verloren geht.

x = Synth(\test, [\freq1, 300, \freq2, 200]);

x.set(\freq1, 500); // Über ".set" lassen sich Werte für Argumente setzten.
                    // hier nicht als Array.

x.set(\freq1, 300, \freq2, 100);

x.free; // Befreit die Node



//------------------------------------------------------------------------------

// Für besonders Interessierte:

// Es gibt die Möglichkeit "scsynth" explizit Nachrichten über OSC zu schicken.

// So könnte man z.B. im Node Tree die ID einer konkreten Node ermitteln und
// diese auch explizit befreien bzw. den darunter gespeicherten Synth stoppen.

s.sendMsg("/n_free", 1037); // Befreie Node "1037"

//------------------------------------------------------------------------------



// Einfacher FM-Synth mit Envelope

(
SynthDef(\simpleFM, { | carr_freq = 400, mod_freq = 50, amp = 0.5 |

	var carrier, modulator, env;

	modulator = SinOsc.ar(mod_freq).range(-100, 100);
	carrier = SinOsc.ar(carr_freq + modulator);

	//-------------------------------------------------------------------

	// Ohne Angabe von "doneAction: 2" wird nach Ausführung der Envelope
	// keine Aktion (bzw. "doneAction: 0") ausgeführt und der Synth/Node
	// bleibt bestehen.

	// Unter Angabe von "doneAction: 2" wird nach Beendigung der Envelope
	// Der Synth/Node befreit bzw. die Aktion "freeSelf" ausgeführt.

	// Beobachtet den Effekt im Node Tree!

	//env = EnvGen.ar(Env([0, 1, 1, 0], [0.05, 0.3, 0.05]));
	env = EnvGen.ar(Env([0, 1, 1, 0], [0.05, 0.3, 0.05]), doneAction: 2);

	//-------------------------------------------------------------------

	Out.ar(0, carrier * env * amp);
}).add;
)


Synth(\simpleFM);



// FM-Synth nach Beispiel von Chowning
// (JOHN M. CHOWNING - "The Synthesis of Complex Audio Spectra by Means of Frequency Modulation")

(
SynthDef(\chowFM, { | amp = 0.5, dur = 0.1, carr_freq = 100, mod_freq = 50, mod_index1 = 0, mod_index2 = 4 |

	var carrier, modulator, env_carr, env_mod, freq_dev1, freq_dev2, durations;

	freq_dev1 = mod_index1 * mod_freq;
	freq_dev2 = (mod_index2 - mod_index1) * mod_freq;

	durations = [0.01, 0.05, dur, 0.05];

	env_mod = EnvGen.kr(Env([0, 1, 0.75, 0.6, 0], durations, \sin), doneAction: 2);
	env_carr = EnvGen.kr(Env([0, 1, 0.75, 0.6, 0], durations, \sin), doneAction: 2);
	env_carr = env_carr * amp;

	modulator = SinOsc.ar(mod_freq);

	carrier = SinOsc.ar(carr_freq + (modulator * (freq_dev1 + (freq_dev2 * env_mod)))) * (env_carr * amp);

	Out.ar(0, carrier);
}).add;
)


Synth(\chowFM);

Synth(\chowFM, [\dur, 0.6, \amp, 0.9, \carr_freq, 440, \mod_freq, 440, \mod_index1, 0, \mod_index2, 8]); // Chowning's Beispiel Parameter-Kombination für ein Blechblaß-artiges Spektrum.

/*

 Probiert hier verschiedene Parameter-Kombinationen aus Chowning's Paper
 und auch eure eigenen aus!

 BEACHTEN!: Der Parameter "P4" (in unserem Synth das Argument "amp") ist
 natürlich in einer Range von 0 bis 1 zu setzten und nicht wie im Paper "1000".

*/
