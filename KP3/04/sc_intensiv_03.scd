// SuperCollider Intensiv 03
// 11.11.2020

// === Bonusaufgabe ===

// Euer Setup so einrichten, dass ihr direkt mit SuperCollider nach BigBlueButton streamen könnt.

// a) Audio-Interface mit Routing-Optionen
//   (Routing des SuperCollider-Signals zurück in einen Sound-Eingang)
// b) Virtuelles Audio-Interface


// => Linux: Jack

// => macOS: z.B. Blackhole (Nachfolger von Soundflower)
// https://github.com/ExistentialAudio/BlackHole

// Hilfreich bei macOS auch:
// https://support.apple.com/en-us/HT202000
// (Aggregate Audio Devices)

// => Windows: z.B. Cable
// https://vb-audio.com/Cable/

// Zur Auswahl des Audio-Interfaces:
s.options.outDevice = " ... ";
s.options.inDevice = " ...";

// Mikrofon in SuperCollider einbindein mit SoundIn

Ndef(\in, {SoundIn.ar(0) ! 2 * 0.5}).play;

// Zum Abhören braucht ihr dann eventuell noch ein weiteres Programm (z.B. Audacity; Eingang auf das virtuelle Audiointerface und Ausgang auf die Sound-Hardware)


// === Mac News Infos ===

// - SuperCollider ist noch nicht kompatibel zu macOS Big Sur (Don't Update!)
// - SuperCollider funktioniert bereits auf anderen ARM-Platformen (z.B. Raspberry Pi), von daher sollte eine native ARM-Version von SuperCollider wahrscheinlich nicht allzu lange brauchen.



// === Aufnehmen in SuperCollider ===

// Grundlegend wird hier der DiskOut UGen benutzt

// Startet Aufnahme
s.record;

Ndef(\blub, {SinOsc.ar(440) * 0.3}).play;
Ndef(\blub).stop;

// Stopt Aufnahme
s.stopRecording;

// Aufnahmeverzeichns Öffnen
Platform.recordingsDir.openOS;

// Wichtig: Standardmäßig speichert SuperCollider Aufnahmen
// als 32-Bit Float AIFF Dateien. Nicht alle DAWs kommen damit
// zurecht. Audacity öffnet die Dateien allerdings ohne Probleme.

// Vorteil: Auch Signale außerhalb des -1/1 Signalbereichs werden
// ohne Verzerrung aufgezeichnet.

// Achtung Achtung beim Ausprobieren: Auf dem Mac wird die
// Lautstärkeregelung des Betriebsystems Übergangen. Audiosignale
// können deutlich lauter aus eurem Lautsprecher/Kopfhörer kommen
// als ihr es erwartet.

// Um in einem anderen Format aufzunehmen am besten mit komplett
// frischem SuperCollider starten (Language => Recompile Class Library)

s.boot;
s.recSampleFormat = "int16";
s.recHeaderFormat = "wav";

s.record;
Ndef(\blub, {SinOsc.ar(440) * 0.3}).play;
Ndef(\blub).stop;
s.stopRecording;

// Hilfe dazu: Server

// Gültige Sample Formate bzw. Headerformate:
// Help: SoundFile (unter HeaderFormat und sampleFormat):


// === AM ===

s.freqscope

// Von Tremolo zu Amplitudenmodulation
(
Ndef(\am, {|freq=440|
	SinOsc.ar(440) * SinOsc.ar(XLine.ar(0.1, 880, 30)) ! 2 * 0.4;
});
)

Ndef(\am).play

// Einfache Ringmodulation
(
Ndef(\am, {|freq=440|
	SinOsc.ar(440) * SinOsc.ar(110) ! 2 * 0.4;
});
)

// Amplitudenmodulation mit Modulator von 0 bis 1:
// Carrier-Frequenz bleibt erhalten
(
Ndef(\am, {|freq=440|
	SinOsc.ar(440) * SinOsc.ar(XLine.ar(0.1, 880, 30)).range(0, 1) ! 2 * 0.4;
});
)


// Modulationsgrad gesteuert mit MouseX
(
Ndef(\am, {|freq=440|
	SinOsc.ar(400) * SinOsc.ar(200).range(MouseX.kr(-1, 1), 1) ! 2 * 0.4;
});
)

// AM bzw. Ringmodulation eures Mikrofons
(
Ndef(\am, {|freq=440|
	SoundIn.ar(0) * SinOsc.ar(200).range(MouseX.kr(-1, 1), 1) ! 2 * 0.4;
});
)


// === Envelopes ===
// Hüllkurven

// Help: Env (Bauplan einer Hüllkurve)
// Help: EnvGen (Erzeugt das Envelope-Signal)

Env.linen(0.2, 1.0, 3.0).test.plot
Env.sine(3.0).test.plot
Env.perc(0.01, 2).test.plot

Env([0, 1, 0.2, 0.8, 0], [0.2, 0.01, 3, 2], \lin).plot
Env([0, 1, 0.2, 0.8, 0], [0.2, 0.01, 3, 2], \sin).plot
Env([0.001, 1, 0.2, 0.8, 0.01], [0.2, 0.03, 3, 2], \exp).plot
Env([0.001, 1, 0.2, 0.8, 0.01], [0.2, 0.03, 3, 2], 4).plot
Env([0, 1, 0.2, 0.8, 0.01], [0.2, 0.03, 3, 2], [\lin, \exp, \exp, \lin]).plot


// Ein etwas sinnfreies Beispiel mit vielen Envelopes
// und AM als grundlegende Synthesetechnik.

( // Neu ausführen um den Envelope neu zu triggern
Ndef(\env, {|freq=100|
	var freqEnv = EnvGen.ar(Env([8, 1, 1.1], [0.03, 2], \exp)).poll;
	var freqRatioEnv = EnvGen.ar(Env([1, 0.5, 0.5], [0.3, 1]));
	var modEnv = EnvGen.ar(Env([0, 1], [2]));
	var ampEnv = EnvGen.ar(Env.perc(0.01, 2));

	var car = SinOsc.ar(freq * freqEnv);
	var mod = SinOsc.ar(freq * freqRatioEnv).range(modEnv, 1);

	car * mod * ampEnv ! 2;
});
)

Ndef(\env).play;


// Ndefs haben einen kurzen Fade-In am Anfang, daher können wir
// kein wirklich schnellen Attacks mit Ndefs realisieren. Bald
// werden wir SynthDefs kennenlernen. Hier werden wir keine
// einfachen statischen Klänge entwerfen sondern tatsächlich
// Instrumente. Envelopes werden hier dann auch noch viel mehr
// Sinn haben (und notwendiger sein).


// FM-Synthese (nur Kurz; natürlich bieten sich hier auch
// Envelopes an zur Steuerung der Parameter ...)
// Mehr Infos zu Modulations-Synthesen im CMT-Artikel im Slack

(
Ndef(\fm, {|freq=300, fmRatio=4, fmIndex=1|
	var mod = SinOsc.ar(freq * fmRatio) * (fmIndex * freq);
	var sig = SinOsc.ar(freq + mod);
	sig ! 2 * 0.3;
})
)

Ndef(\fm).play

// Parameter
NdefMixer(s)

