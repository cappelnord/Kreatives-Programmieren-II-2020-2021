(
Ndef(\pan, {
	var num = 8;

	// erzeugt num eigenständige Dust2-UGens
	var sigs = Dust2.ar(3 ! num);

	/*
	Wichtiger Unterschied:
	Dust2.ar(5) ! 8 => ein Dust2 Generator wird 8 mal dupliziert, stets das selbe Signal
	Dust2.ar(5 ! 8) => 8 eigenständige Dust2 Generatoren, jeweils mit einer density von 5
	*/

	// filtert jedes Signal mit einer zufälligen Frequenz
	var filterFreqs = Array.exprand(num, 200, 4000);
	sigs = BPF.ar(sigs, filterFreqs, 0.03);

	// aus jedem Monosignal wird ein Stereosignal erzeugt
	// (Panorama durch jeweils ein LFNoise2 moduliert)
	sigs = Pan2.ar(sigs, LFNoise2.kr(1 ! num));

	// Aus einem flachen Array mit Signal
	// [A, B, C, D, ...]
	// Nun ein Array von Stereopaaren
	// [ [Al, Ar], [Bl, Br], [Cl, Cr], ...]

	// mischt Signale zusammen, effektiv:
	// [Al, Ar] + [Bl, Br] + [Cl, Cr] + ...
	// Oder:
	// [Al + Bl + Cl + ... , Ar + Br + Cr + ...]
	Mix.ar(sigs) * 10.0; // boost!

	// Alternativ:
	// sigs.sum * 10.0;
});
)

Ndef(\pan).play;