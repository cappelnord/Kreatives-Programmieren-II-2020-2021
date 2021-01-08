var notes = {};
var currentID = 0;

var pattern = [1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1];

var firstNote = 21;
var lastNote = 109;

// will be set by drawPiano
var width;
var height;
var keyWidth;

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
	var ctx = cnvs.getContext('2d');

	width = cnvs.width;
	height = cnvs.height;
	keyWidth =  width / (lastNote - firstNote);

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
	var n = (x - (keyWidth / 2)) / width;
	return (n * (lastNote - firstNote)) + firstNote;
}

function freqFromNote(note) {
	return Math.pow(2, (note - 69) / 12) * 440;
}


function ampFromY(y) {
	return Math.pow(100, (height - y) / height) * 0.01 * 0.4 + 0.1;
}

function filterFromY(y) {
	return Math.pow(100, (height - y) / height) * 0.01 * 8000 + 1000;
}

function startNote(id, x, y) {
	var avatar = $("<div class='avatar'>😮</div>");
	avatar.css({
		top: y,
		left: x
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
	if(notes[id] === undefined) return;

	notes[id].avatar.css({
		top: y,
		left: x
	});

	updateSound(notes[id].sound, freqFromNote(noteFromX(x)), filterFromY(y), ampFromY(y));
}

function releaseNote(id, x, y) {
	if(notes[id] === undefined) return;

	notes[id].avatar.remove();
	endSound(notes[id].sound);

	notes[id] = undefined;
}


function start() {
	cnvs = document.getElementById("canvas");

	initializeAudio();
	drawPiano();

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


	cnvs.addEventListener('mousedown', function(e) {
		socket.emit("soundOn", {x: e.offsetX, y: e.offsetY});
		noteRunning = true;
	});
	
	cnvs.addEventListener('mousemove', function(e) {
		if(noteRunning) {
			socket.emit("soundMove", {x: e.offsetX, y: e.offsetY});
			updateNote(currentID, e.offsetX, e.offsetY);
		}
	});

	var mouseReleaseFunction = function(e) {
		if(noteRunning) {
			socket.emit("soundOff");
			noteRunning = false;
		}
	}

	socket.on("soundOn", function(msg) {
		startNote(msg.id, msg.x, msg.y);
	});

	socket.on("soundMove", function(msg) {
		updateNote(msg.id, msg.x, msg.y);
	});

	socket.on("soundOff", function(msg) {
		releaseNote(msg.id);
	});

	cnvs.addEventListener('mouseup', mouseReleaseFunction);
	cnvs.addEventListener('mouseleave', mouseReleaseFunction);


}

var button = $("<button>Start!</button>");
$("body").append(button);
button.click(function() {
	start();
	button.remove();
});
