# 13.01.2021; Kreatives Programmieren 3

* [Feedback Intro](feedback_intro.scd)
* [Feedback mit Laptop](feedback_laptop.scd)
* [Weitere Feedback Beispiele](feedback.scd)

## Feedback

* Ouroboros
* Kybernetik
* Positives / Negatives Feedback
* Feedback im Audiobereich
* [Videofeedback](https://www.youtube.com/watch?v=B4Kn3djJMCE)

## Feedback in SuperCollider

* Feedbacks und SuperCollider
* Delays (v.a. auch sehr kurze Delays)
* Feedback mit Ndefs (simpelster Weg; im Zweifel hierauf in der Übung beschränken)
* [Feedback Quark](https://github.com/supercollider-quarks/Feedback)
* [LocalIn/LocalOut](http://doc.sccode.org/Classes/LocalIn.html)
* [InFeedback](http://doc.sccode.org/Classes/InFeedback.html)
* [Single Sample Feedback](https://zenodo.org/record/3898757#.X_3NiuhKhhE) (more advanced)

## Übungsaufgabe

Baut einen (oder mehrere miteinander verbundene) Ndefs zur Exploration von Feedbacks. Das Feedback soll über einen Regelmechanismus verfügen - entweder manuell (z.B. [MouseX/Y](https://doc.sccode.org/Classes/MouseX.html), [MouseButton](https://doc.sccode.org/Classes/MouseButton.html), [MIDI](https://github.com/cappelnord/Kreatives-Programmieren-II-2020-2021/blob/master/FAQ/midi_cc.scd), NdefMixer ...) oder automatisch (z.B. [Amplitude](https://doc.sccode.org/Classes/Amplitude.html) oder zeitgesteuert via Envelopes, LFOs, etc.).

Seid vorsichtig mit den Feedbacks! Am besten zumindest erstmal für den Anfang die Amplitude begrenzen (z.B. durch tanh). Dringende Empfehlung für Mac-User: Der [SafetyNet](https://supercollider.github.io/download) Quark. Auch der Feedback Quark ist sehr hilfreich!

Euer Netzwerk kann einem zeitlichen Ablauf folgen, sich periodisch wiederholen, ein komplexes Eigenleben haben oder als 'Instrument' mit Controllern (MIDI, NdefMixer, ...) gespielt werden. Erstellt auch eine kurze Demoaufnahme eures Systems.

Zur Gestaltung des Klangs stehen euch alle Möglichkeiten in SuperCollider zur Verfügung. Nutzt auch gerne Samples, Live-Input oder externe Geräte (wenn euch welche zur Verfügung stehen). Siehe dazu: [PlayBuf](https://doc.sccode.org/Classes/PlayBuf.html), [BufRd](https://doc.sccode.org/Classes/BufRd.html), und [SoundIn](https://doc.sccode.org/Classes/SoundIn.html) - dies soll in der Übung auch noch weiter thematisiert werden. Lasst euch auch von nicht-musikbezogenen Feedback-Systemen inspirieren!