var notes = {};

var currentID = 0;
var currentMouseID;

var pattern = [1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1];

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
    delayGain.gain.setValueAtTime(0.5, 0);

    sink.connect(delay);
    delay.connect(delayGain);
    delayGain.connect(sink);

    sink.connect(audioCtx.destination);

}

function startSound(freq, ffreq, amp) {
	var now = audioCtx.currentTime;

	var osc = audioCtx.createOscillator();
	osc.type = 'sawtooth';
	osc.frequency.setValueAtTime(freq, now);

	var filter = audioCtx.createBiquadFilter();
	filter.type = "lowpass";
	filter.frequency.setValueAtTime(ffreq, now);
	filter.Q.setValueAtTime(3, now);

	var gain = audioCtx.createGain();
	gain.gain.setValueAtTime(amp, now)

	osc.connect(filter);
	filter.connect(gain);
	gain.connect(sink);

	osc.start();

	return {osc: osc, gain: gain, filter: filter};
}

function updateSound(obj, freq, ffreq, amp) {
	var now = audioCtx.currentTime;
	obj.osc.frequency.exponentialRampToValueAtTime(freq, now + 0.1);
	obj.filter.frequency.exponentialRampToValueAtTime(ffreq, now + 0.1);
	obj.gain.gain.exponentialRampToValueAtTime(amp, now + 0.05);
}

function endSound(obj) {
	var now = audioCtx.currentTime;
	obj.gain.gain.exponentialRampToValueAtTime(0.001, now + 1);

	window.setTimeout(function() {
		obj.gain.disconnect();
	}, 1200);
}



function drawPiano() {
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
	return Math.pow(100, 1.0 - y) * 0.01 * 0.4 + 0.1;
}

function filterFromY(y) {
	return Math.pow(100, 1.0 - y) * 0.01 * 8000 + 1000;
}

function startNote(id, x, y) {
	var avatar = $("<div class='avatar'>😮</div>");

	avatar.css({
		left: x * width - (avatarSize/2),
		top: y * height - (avatarSize/2)
	});

	$("body").append(avatar);

	var sound = startSound(freqFromNote(noteFromX(x)), filterFromY(y), ampFromY(y));

	var obj =  {
		"avatar": avatar,
		"sound": sound
	};

	notes[id] = obj;
}

function updateNote(id, x, y) {

	// if a note does not exist yet we create it!
	if(notes[id] === undefined) {
		startNote(id, x, y);
		return;
	}

	notes[id].avatar.css({
		left: x * width - (avatarSize/2),
		top: y * height - (avatarSize/2)
	});

	updateSound(notes[id].sound, freqFromNote(noteFromX(x)), filterFromY(y), ampFromY(y));
}

function releaseNote(id, x, y) {
	if(notes[id] === undefined) return;

	notes[id].avatar.remove();
	endSound(notes[id].sound);

	delete notes[id];
}

var hasStarted = false;

function start() {

	if(hasStarted) return;
	hasStarted = true;

	initializeAudio();

	var noteRunning = false;

	var socket = io();

	/*
	cnvs.addEventListener('mousedown', function(e) {
		currentID++;
		startNote(currentID, e.offsetX, e.offsetY);
		noteRunning = true;
	});
	
	cnvs.addEventListener('mousemove', function(e) {
		if(noteRunning) {
			updateNote(currentID, e.offsetX, e.offsetY);
		}
	});

	var mouseReleaseFunction = function(e) {
		releaseNote(currentID);
		noteRunning = false;
	}
	*/

	cnvs.on('mousedown', function(e) {
		currentID++;
		currentMouseID = currentID;
		socket.emit("soundOn", {id: currentMouseID, x: e.offsetX / width, y: e.offsetY / height});
		noteRunning = true;
	});
	
	cnvs.on('mousemove', function(e) {
		if(noteRunning) {
			socket.emit("soundMove", {id: currentMouseID, x: e.offsetX / width, y: e.offsetY / height});
		}
	});

	var mouseReleaseFunction = function(e) {
		if(noteRunning) {
			socket.emit("soundOff", {id: currentMouseID});
			noteRunning = false;
			currentMouseID = undefined;
		}
	}

	cnvs.on('mouseup', mouseReleaseFunction);
	cnvs.on('mouseleave', mouseReleaseFunction);




	socket.on("soundOn", function(msg) {
		startNote(msg.id, msg.x, msg.y);
	});

	socket.on("soundMove", function(msg) {
		updateNote(msg.id, msg.x, msg.y);
	});

	socket.on("soundOff", function(msg) {
		releaseNote(msg.id);
	});

	socket.on("disconnect", function(msg) {
		for(var id of Object.keys(notes)) {
			if(notes[id] !== undefined) {
				releaseNote(id);
			}
		}
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