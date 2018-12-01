/* Pad class composed of a wurley and rhodes synth played together
   Interfaced via the play command
   Includes a reverb effect and envelope shaping
*/
public class Pad {
	3 => int NUMVOICES;
	Tempo t;
	Wurley w[NUMVOICES];
	Rhodey r[NUMVOICES];
	JCRev rev;
	LPF lpf;
	ADSR env;
	Gain g;

	1.0 / (w.size() + r.size()) => g.gain;

	lpf => env => rev => g;
	g.gain(0.25);
	env.set(15::ms, t.t, 0.3, t.s);
	rev.mix(0.05);
	lpf.freq(16000);

	for (int i; i < w.size(); ++i) w => lpf;
	for (int i; i < r.size(); ++i) r => lpf;
	/* Main interface for the Pad class
	   Takes an array of chords and corresponding durations as input
	   Accepted chords are:
	     --G minor ["Gm"]
	     --F       ["F"]
	     --F# dim  ["F#dim"]
	     --Rest    [""]
	   Chords can be added freely to the parseChord class
	*/
	fun void play(string chords[], dur ations[], float bars) {
		spork ~ playThread(chords, ations, bars);
	}
	/* Threaded function controlling the attachment of the pad to the
	   dac and the assignment of input parameters to UGens */
	fun void playThread(string chords[], dur ations[], float bars) {
		if (chords.size() != ations.size()) {
			<<< "Error in Pad::play: Must have same number of chords and durations!" >>>;
			return;
		}
		bars * t.w + now => time stop;
		g => dac;
		while (now < stop) {
			for (int beat; beat < chords.size(); ++beat) {
				if (chords[beat] == "") {
					for (int i; i < NUMVOICES; ++i) {
						w[i] =< lpf;
						r[i] =< lpf;
					}
					ations[beat] => now; //rest
					for (int i; i < NUMVOICES; ++i) {
						w[i] => lpf;
						r[i] => lpf;
					}
				}
				else {
					parseChord(chords[beat]);
					playChord(ations[beat]);
				}
			}
		}
		g =< dac;
	}
	/* Translates the input chord into frequencies and applies them to the relevant UGens */
	fun void parseChord(string chord) {
		if (chord == "Gm") setFreqs([55, 58, 62]);
		else if (chord == "F") setFreqs([53, 57, 60]);
		else if (chord == "F#dim") setFreqs([54, 57, 60]);
		else <<< "Error in Pad::parseChord: chord ", chord, " has not been defined" >>>;
	}
	/* Assigns an array of MIDI Notes to the frequencies of our UGen arrays */
	fun void setFreqs(int MIDINotes[]) {
		for (int i; i < NUMVOICES; ++i) Std.mtof(MIDINotes[i]) => w[i].freq => r[i].freq;
	} 
	/* Handles envelope and note cues for each voice */
	fun void playChord(dur ation) {
		for (int i; i < w.cap(); ++i) w[i].noteOn(1);
		for (int i; i < r.cap(); ++i) r[i].noteOn(1);
		env.keyOn(1);
		ation * 0.85 => now;

		for (int i; i < w.cap(); ++i) w[i].noteOff(1);
		for (int i; i < r.cap(); ++i) r[i].noteOff(1);
		env.keyOff(1);
		ation * 0.15 => now;
	}
}
