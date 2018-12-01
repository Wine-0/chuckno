/* Bass instrument class with triangle oscillator bass and sine wave sub-bass
   Interfaced via the play command
   Uses a ResonZ filter for filter sweep effects
*/
public class TechnoBass {
	Tempo t;
	TriOsc tri;
	SinOsc sub;
	ResonZ filt;
	HPF hpf;
	NRev rev;
	ADSR env;
	Dyno comp;
	Dyno limit;
	Gain g;

	tri => hpf => filt => comp => limit => rev => g;
	sub => hpf;

	sub.gain(0.5);
	g.gain(0.7);
	comp.compress();
	comp.thresh(0.1);
	limit.limit();
	limit.thresh(0.9);
	rev.mix(0.01);
	hpf.freq(70);

	/* Main interface for the TechnoBass class
	   Takes as input an array of MIDI notes and their respective durations */
	fun void play(int notes[], dur ations[], float bars) {
		spork ~ playThread(notes, ations, bars);
	}
	/* Threaded function controlling the connection of the bass to the dac and assignment of
	   input parameters to the UGens */
	fun void playThread(int notes[], dur ations[], float bars) {
		if (notes.size() != ations.size()) {
			<<< "Error in TechnoBass::play: Must have same number of notes and durations!" >>>;
			return;
		}
		bars * t.w + now => time stop;
		g => dac;
		while (now < stop) {
			for (int beat; beat < ations.size(); ++beat) {
				Std.mtof(notes[beat]) => tri.freq;
				Std.mtof(notes[beat]) => sub.freq;
				spork ~ filterSweep(ations[beat]);
				ations[beat] => now;
			}
		}
		g =< dac;
	}
	/* Controls the filter sweep of the ResonZ filter over the course of each note */
	fun void filterSweep(dur ation) {
		ation / 50.0 => dur increment;
		for (int i; i < 50; ++i) {
			50.0 + 1.25 * i * ((increment / ms) $ float) => filt.freq;
			increment => now;
		}
	}
}
