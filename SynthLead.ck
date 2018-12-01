/* Synth sound composed of doubled Moog instruments
   Interfaced via the play command
   Includes spectral and dynamic shaping as well as reverb
*/
public class SynthLead {
	Tempo t;
	Moog m[2];
	JCRev rev;
	ADSR env;
	LPF lpf;
	ResonZ filt;
	Gain g;

	m[0] => lpf => filt => rev => env => g;
	m[1] => lpf => rev;

	g.gain(0.5);
	rev.mix(0.35);
	env.set(20::ms, 100::ms, 0.3, 600::ms);
	lpf.freq(15000);
	filt.set(1000, 0.8);
	filt.gain(-0.4);

	/* Main interface for the SynthLead class
	   Takes as input an array of MIDI notes and their respective durations */
	fun void play(int notes[], dur ations[], float bars) {
		spork ~ playThread(notes, ations, bars);
	}
	/* Threaded function controlling the attachment of the synth to the dac
	   and the assignment on input parameters to the Ugens */
	fun void playThread(int notes[], dur ations[], float bars) {
		if (notes.size() != ations.size()) {
			<<< "Error in SynthLead::play: Must have same number of notes and durations!" >>>;
			return;
		}
		bars * t.w + now => time stop;
		g => dac;
		int i;
		while (now < stop) {
			for (int beat; beat < ations.size(); ++beat) {
				if (now >= stop) {
					env.releaseTime(3::second);
					rev.mix(0.5);
					t.w * 2 => now;
					break;
				}
				if (notes[beat] != -1) {
					Std.mtof(notes[beat]) => m[0].freq;
					Std.mtof(notes[beat] - 12) => m[1].freq;
					for (int i; i < 2; ++i) m[i].noteOn(1);
					env.keyOn(1);
					ations[beat] * 0.9 => now;
					for (int i; i < 2; ++i) m[i].noteOff(1);
					env.keyOff(1);
					ations[beat] * 0.1 => now;
				}
				else {
					m[0] =< lpf;
					m[1] =< lpf;
					ations[beat] => now;
					m[0] => lpf;
					m[1] => lpf;
				}
			}
		}
		g =< dac;
	}
}
