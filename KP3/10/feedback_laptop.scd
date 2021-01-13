// move Mouse to left/right to find a good level of feedback.
// then explore the laptop with your hands!

// - cover speakers/microphones
// - excite the laptop by hitting it
// - try to change frequencies by hovering your hands over microphones/speakers


// start with Mouse all the way to the left
// move to the right to dial in a good amplification

{Out.ar(0, (SoundIn.ar(0).dup * MouseX.kr(0, 1.2)).tanh)}.play;