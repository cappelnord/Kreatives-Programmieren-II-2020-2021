var notes = {};

var currentID = 0;

var firstNote = 21;
var lastNote = 109;
var numNotes = lastNote - firstNote;

var avatarSize = 30;

// will be set by drawPiano
var width;
var height;

// will be set by start
var cnvs;

// will be set by initializeAudio
var audioCtx;
var sink;

function initializeAudio() {
	const AudioContext = window.AudioContext || window.webkitAudioContext;
    audioCtx = new AudioContext();

    sink = audioCtx.createGain();
    var delay = audioCtx.createDelay(1.0);
    delay.delayTime.value = 0.333 / 2;

    var delayGain = audioCtx.createGain();
    delayGain.gain.setValueAtTime(0.5, audioCtx.currentTime);

    sink.connect(delay);
    delay.connect(delayGain);
    delayGain.connect(sink);

    var compressor = audioCtx.createDynamicsCompressor();
	compressor.threshold.setValueAtTime(-10, audioCtx.currentTime);
	compressor.knee.setValueAtTime(40, audioCtx.currentTime);
	compressor.ratio.setValueAtTime(12, audioCtx.currentTime);
	compressor.attack.setValueAtTime(0, audioCtx.currentTime);
	compressor.release.setValueAtTime(0.25, audioCtx.currentTime);

	sink.connect(compressor);
    compressor.connect(audioCtx.destination);

}

function startSound(freq, ffreq, amp, pan) {
	var now = audioCtx.currentTime;

	var osc = audioCtx.createOscillator();
	osc.type = 'sawtooth';
	osc.frequency.setValueAtTime(freq, now);

	var filter = audioCtx.createBiquadFilter();
	filter.type = "lowpass";
	filter.frequency.setValueAtTime(ffreq, now);
	filter.Q.setValueAtTime(3, now);

	var gain = audioCtx.createGain();
	gain.gain.setValueAtTime(amp, now);

	var panNode = audioCtx.createStereoPanner();
	panNode.pan.setValueAtTime(pan, now);

	osc.connect(filter);
	filter.connect(gain);
	gain.connect(panNode);
	panNode.connect(sink);

	osc.start();

	return {osc: osc, gain: gain, filter: filter, pan: panNode};
}

function updateSound(obj, freq, ffreq, amp, pan) {
	var now = audioCtx.currentTime;
	obj.osc.frequency.exponentialRampToValueAtTime(freq, now + 0.1);
	obj.filter.frequency.exponentialRampToValueAtTime(ffreq, now + 0.1);
	obj.gain.gain.exponentialRampToValueAtTime(amp, now + 0.05);
	obj.pan.pan.setValueAtTime(pan, now);
}

function endSound(obj) {
	var now = audioCtx.currentTime;
	obj.gain.gain.cancelScheduledValues(now);
	obj.gain.gain.exponentialRampToValueAtTime(0.001, now + 1);

	window.setTimeout(function() {
		obj.osc.stop();
		obj.pan.disconnect();
	}, 1200);
}



function drawPiano() {
	var pattern = [1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1];

	// access DOM element directly here
	var cnvsDOM = cnvs[0];

	cnvsDOM.width = window.innerWidth;
	cnvsDOM.height = window.innerHeight;

	var ctx = cnvsDOM.getContext('2d');
	width = cnvsDOM.width;
	height = cnvsDOM.height;

	var keyWidth =  width / numNotes;

	ctx.strokeStyle = "#888888";

	for(var note = firstNote; note < lastNote; note++) {
		var x = (note - firstNote) * keyWidth;
		
		if(pattern[note % 12] == 0) {
			ctx.fillStyle = "black";
		} else {
			ctx.fillStyle = "white";
		}
		ctx.fillRect(x, 0, keyWidth, height);

		ctx.beginPath();
		ctx.rect(x, 0, keyWidth, height);
		ctx.stroke();
	}
}

function noteFromX(x) {
	// this seems overly complicated ...

	var keyWidth = 1.0 / numNotes;
	var n = x - (keyWidth / 2);
	return (n * numNotes) + firstNote;
}

function freqFromNote(note) {
	return Math.pow(2, (note - 69) / 12) * 440;
}


function ampFromY(y) {
	return Math.pow(100, 1.0 - y) * 0.01 * 0.3 + 0.1;
}

function filterFromY(y) {
	return Math.pow(100, 1.0 - y) * 0.01 * 8000 + 1000;
}

function panFromX(x) {
	return x - 0.5;
}

function startNote(id, x, y) {
	x = Math.min(Math.max(x, 0), 1);
	y = Math.min(Math.max(y, 0), 1);

	var avatar = $("<div class='avatar'>😮</div>");

	avatar.css({
		left: x * width - (avatarSize/2),
		top: y * height - (avatarSize/2)
	});

	$("body").append(avatar);

	var sound = startSound(freqFromNote(noteFromX(x)), filterFromY(y), ampFromY(y), panFromX(x));

	var obj =  {
		"avatar": avatar,
		"sound": sound
	};

	notes[id] = obj;
}

function updateNote(id, x, y) {
	x = Math.min(Math.max(x, 0), 1);
	y = Math.min(Math.max(y, 0), 1);

	// if a note does not exist yet we create it!
	if(notes[id] === undefined) {
		startNote(id, x, y);
		return;
	}

	notes[id].avatar.css({
		left: x * width - (avatarSize/2),
		top: y * height - (avatarSize/2)
	});

	updateSound(notes[id].sound, freqFromNote(noteFromX(x)), filterFromY(y), ampFromY(y), panFromX(x));
}

function releaseNote(id) {
	if(notes[id] === undefined) return;

	notes[id].avatar.remove();
	endSound(notes[id].sound);

	delete notes[id];
}

function soundOn(msg) {
	startNote(msg.id, msg.x, msg.y);
}

function soundMove(msg) {
	updateNote(msg.id, msg.x, msg.y);
}

function soundOff(msg) {
	releaseNote(msg.id);
}

function nextLocalID() {
	currentID = (currentID + 1) % 1000;
	return currentID;
}

var hasStarted = false;

function start() {

	if(hasStarted) return;
	hasStarted = true;

	cnvs.css("cursor", "crosshair");

	initializeAudio();

	var socket = io();


	// MOUSE CTRL

	var currentMouseID;
	var mouseNoteRunning = false;
	cnvs.on('mousedown', function(e) {
		if(e.button == 0) {
			currentMouseID = nextLocalID();
			var msg = {id: currentMouseID, x: e.clientX / width, y: e.clientY / height};
			socket.emit("soundOn", msg);
			soundOn(msg);
			mouseNoteRunning = true;
		}
	});
	
	cnvs.on('mousemove', function(e) {
		if(mouseNoteRunning) {
			var msg = {id: currentMouseID, x: e.clientX / width, y: e.clientY / height};
			socket.emit("soundMove", msg);
			soundMove(msg);
		}
	});

	var mouseReleaseFunction = function(e) {
		if(mouseNoteRunning) {
			var msg = {id: currentMouseID};
			socket.emit("soundOff", msg);
			soundOff(msg);
			mouseNoteRunning = false;
			currentMouseID = undefined;
		}
	}

	cnvs.on('mouseup', function(e) {
		if(e.button == 0) {
			mouseReleaseFunction(e);
		}
	});

	cnvs.on('mouseleave', mouseReleaseFunction);


	// TOUCH CTRL
	var touchIDs = {};

	cnvs.on('touchstart', function(e) {
		for(touch of e.changedTouches) {
			var id = nextLocalID();
			touchIDs[touch.identifier] = id;
			var msg = {id: id, x: touch.clientX / width, y: touch.clientY / height};
			socket.emit("soundOn", msg);
			soundOn(msg);
		}
		e.preventDefault();
	});

	cnvs.on('touchmove', function(e) {
		for(touch of e.changedTouches) {
			var id = touchIDs[touch.identifier];
			if(id !== undefined) {
				var msg = {id: id, x: touch.clientX / width, y: touch.clientY / height};
				socket.emit("soundMove", msg);
				soundMove(msg);
			}
		}
		e.preventDefault();
	});

	cnvs.on('touchcancel, touchend', function(e) {
		for(touch of e.changedTouches) {
			var id = touchIDs[touch.identifier];
			if(id !== undefined) {
				delete touchIDs[touch.identifier];
				var msg = {id: id};
				socket.emit("soundOff", msg);
				soundOff(msg);
			}
		}
		e.preventDefault();
	});



	socket.on("soundOn", soundOn);
	socket.on("soundMove", soundMove);
	socket.on("soundOff", soundOff);

	socket.on("numOnline", function(msg) {
		if(msg["num"] > 1) {
			$("#statusText").html("" + msg["num"] + " users online");
		} else {
			$("#statusText").html("1 user online");
		}
	});

	socket.on("disconnect", function(msg) {
		for(var id of Object.keys(notes)) {
			if(notes[id] !== undefined) {
				releaseNote(id);
			}
		}
		$("#statusText").html("disconnected");
	});
}

$(document).ready(function() {
		cnvs = $("#canvas");
		drawPiano();
		$(window).resize(drawPiano);

		$("#play").click(function() {
			$("#play").remove();
			start();
		});
});