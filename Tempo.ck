/* Tempo class for global bpm control and duration conversion */
public class Tempo {
	/* Global duration variables for thirty-second, sixteenth,
	   eighth, quarter, half, and whole notes */
	static dur t, s, e, q, h, w;
	/* Update all duration values based on user-input bpm */
	fun float set(float bpm) {
		(240.0 / bpm)::second => w;
		w * 0.5 => h;
		h * 0.5 => q;
		q * 0.5 => e;
		e * 0.5 => s;
		s * 0.5 => t;
		return bpm;
	}
	/* Returns the current BPM setting of the Tempo class */
	fun float get() {
		return (240.0::second / w) $ float;
	}
}
