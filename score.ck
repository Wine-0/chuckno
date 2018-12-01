Tempo t;
t.set(120.0);

Drums drums;
TechnoBass bass;
Pad pad;
SynthLead synth;

/* Programmed drum patterns
   Key:
	 --kick  == "a"
	 --clap  == "s"
	 --snare == "d"
	 --hihat == "f"
	 --rest  == "."
*/
"aaaa" => string kickPattern;
"....d......d..d.....d...dd.d.dd.....d......d..d.....d...dd.d.dd." => string snarePattern1;
"........................................................dd.d.dd." => string snarePattern2;
".......ffffffffff...f.f.f.f.f...f.....f...f...f.f....ffff...f.....f..ffff.f.f.f.f...f.fff....ffff.....f...f.f...f...f...f...f..." => string hihatPattern1;
"f...f...f...f..........ffffffffff...f.f.f.f.f...f.....f...f...f.f....ffff...f.....f..ffff.f.f.f.f...f.fff....ffff.....f...f.f..." => string hihatPattern2;
"....s.......s.ss....s.....s....s....s.......s.ss....s.....s....s" => string clapPattern;
/* Programmed Bass part */
[43, 31, 34, 38, 26, 29, 33, 27, 31, 34, 26, 38, 50, 38, 50, 38] @=> int bassNotes[];
[t.q, 1.5 * t.q, t.e, t.e, 3 * t.q, t.e, t.e, 3 * t.q, t.e, t.e, t.h, t.e, t.e, t.e, t.e, t.e] @=> dur bassDurations[];
/* Programmed Pad part */
["", "Gm", "", "Gm", "", "F", "", "F", "", "Gm", "", "Gm", "", "F#dim", "", "F#dim"] @=> string padChords[];
[t.h, t.s, t.s, t.s, 11 * t.s, t.s, 3 * t.s, t.e, 3 * t.q, t.s, t.s, t.s, 11 * t.s, t.s, 3 * t.s, 3 * t.e] @=> dur padDurations[];
/* Programmed lead part */
[55, 58, 55, 60, 58, -1, 53, 58, 53, 60, 58, 53, 54, 55, 58, 55, 60, 58, -1, 62, 54, 60, -1, 60, 58] @=> int leadNotes[];
[t.q, t.e, t.e, t.e, t.e, 3 * t.e, t.e, t.e, t.e, t.e, t.e, t.e, t.e, t.q, t.e, t.e, t.e, t.e, t.e, 3 * t.e, t.e, t.s, 3 * t.s, t.q, t.e] @=> dur leadDurations[];

drums.play(kickPattern, t.q, 48);
3.5 * t.w => now;
drums.play(hihatPattern1, t.t, 12.5);
4.5 * t.w => now;
drums.play(snarePattern1, t.s, 24);
8 * t.w => now;
drums.play(clapPattern, t.s, 55);
bass.play(bassNotes, bassDurations, 52);
7 * t.w => now;
drums.play(hihatPattern2, t.t, 25);
1 * t.w => now;
pad.play(padChords, padDurations, 8);
8 * t.w => now;
drums.play(snarePattern2, t.s, 16);
8 * t.w => now;
pad.play(padChords, padDurations, 8);
8 * t.w => now;
drums.play(snarePattern1, t.s, 16);
synth.play(leadNotes, leadDurations, 23.875);
4 * t.w => now;
drums.play(hihatPattern1, t.t, 12);
4 * t.w => now;
drums.play(kickPattern, t.q, 14);
pad.play(padChords, padDurations, 8);
18 * t.w => now;
