/* Add the metronome */
Machine.add(me.dir() + "/Tempo.ck") => int tempoID;
/* Now the instruments */
Machine.add(me.dir() + "/Drums.ck") => int drumsID;
Machine.add(me.dir() + "/Bass.ck") => int bassID;
Machine.add(me.dir() + "/Pad.ck") => int padID;
Machine.add(me.dir() + "/SynthLead.ck") => int synthID;
/* Now drop the beat */
Machine.add(me.dir() + "/score.ck") => int scoreID;
