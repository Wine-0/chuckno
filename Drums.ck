/* Sample-Based Drum Class
   Loads all files from "./audio/*.wav"
   Control drum input with keyboard
     --kick  == "a"
     --clap  == "s"
     --snare == "d"
     --hihat == "f"
     --rest  == "."
*/
public class Drums {
	Tempo t;
	SndBuf kick, snare, hihat, clap;
	NRev rev;
	Gain g => dac;

	kick.read(me.dir() + "/audio/kick.wav");
	snare.read(me.dir() + "/audio/snare.wav");
	hihat.read(me.dir() + "/audio/hihat.wav");
	clap.read(me.dir() + "/audio/clap.wav");

	kick => rev => g;
	snare => rev;
	hihat => rev;
	clap => rev;

	kick.samples() - 1 => kick.pos;
	snare.samples() - 1 => snare.pos;
	hihat.samples() - 1 => hihat.pos;
	clap.samples() - 1 => clap.pos;

	g.gain(0.20);
	hihat.gain(0.8);
	snare.gain(0.8);
	clap.gain(0.8);
	rev.mix(0.01);

	/* Main interface for controlling the Drums class
	   Specify the score (see class comments), a division
	   (e.g., t.q means the given score is in quarter notes),
	   and the number of bars to loop
	*/
	fun void play(string score, dur division, float bars) {
		spork ~ playThread(score, division, bars);
	}
	/* Parses the score string, with each note being passed to the
	   relevant sound buffer and being played for the given duration */
	fun void playThread(string score, dur division, float bars) {
		bars * t.w + now => time stop;
		while (now < stop) {
			for(int beat; beat < score.length(); ++beat) {
				if (now >= stop) break;
				if      (score.charAt(beat) == 'a') playSamp(kick, division);
				else if (score.charAt(beat) == 'd') playSamp(snare, division);
				else if (score.charAt(beat) == 'f') playSamp(hihat, division);
				else if (score.charAt(beat) == 's') playSamp(clap, division);
				else if (score.charAt(beat) == '.') division => now;
				else <<< "Error: Drum Score Character ", score.charAt(beat), " Not Defined!" >>>;
			}
		}
	}
	/* Play one note from a given sound buffer */
	fun void playSamp(SndBuf s, dur division) {
		0 => s.pos;
		division => now;
	}
}
