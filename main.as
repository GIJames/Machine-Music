stage.align = StageAlign.TOP_LEFT;
var my_menu:ContextMenu = new ContextMenu();
my_menu.hideBuiltInItems();

var version = new ContextMenuItem("Machine Music rev.2");
version.enabled = false;

var credit = new ContextMenuItem("Rubber NAND 2015");
credit.enabled = false;

var insp = new ContextMenuItem("inspired by TheGlasshouseWithButterfly.swf by [R-H]!mfGZNk0vaI");
insp.separatorBefore = true;
insp.enabled = false;

var songsource = new ContextMenuItem("Original music: Machinarium Soundtrack 11 - The Glasshouse With Butterfly (Tomas Dvorak)");
function openSSLink(e:ContextMenuEvent):void {
	navigateToURL(new URLRequest("https://soundcloud.com/minorityrecords/sets/machinarium-ost"));
}
songsource.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, openSSLink);
songsource.separatorBefore = true;

var thissong = new ContextMenuItem("This remix will go up here when it's finished");
function openremixlink(e:ContextMenuEvent):void {
	navigateToURL(new URLRequest("https://soundcloud.com/9c5"));
}
thissong.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, openremixlink);

my_menu.customItems.push(version, credit, insp, songsource, thissong);
contextMenu = my_menu;

var soundChannel:SoundChannel = new SoundChannel();
var intro:Intro = new Intro();
var loop:Loop = new Loop();
var looping = false;

function introEndHandler(e:Event):void {
	soundChannel.removeEventListener(Event.SOUND_COMPLETE, introEndHandler);
	soundChannel = loop.play(0, int.MAX_VALUE);
	looping = true;
}
soundChannel = intro.play();
soundChannel.addEventListener(Event.SOUND_COMPLETE, introEndHandler);

function hexFromChannels(r:Number, g:Number, b:Number):Number {
	var total = r << 16;
	total += g << 8;
	total += b;
	return total;
}

function colorFromHue(h:Number):Number {
	var r,g,b;
	var s = Math.floor(h/120);//0: RG  1: GB 2: BR
	var l = h%120;//fade between
	var c1, c2;
	if (l < 60) {
		c1 = 255;
		c2 = Math.round(l * (255/60));
	} else {
		c2 = 255;
		c1 = Math.round((l-60) * (255/60));
	}
	switch (s) {
		case 0 ://c1 = R c2 = G
			r = c1;
			g = c2;
			b = 0;
			break;
		case 1 ://c1 = G c2 = B
			r = 0;
			g = c1;
			b = c2;
			break;
		case 2 ://c1 = B c2 = R
			r = c2;
			g = 0;
			b = c1;
			break;
	}
	return hexFromChannels(r,g,b);
}

var testguide:Sprite = new Sprite();
bguide.addChild(testguide);
testguide.x = 246;
testguide.y = 199;

var specguide:Sprite = new Sprite();
bguide.addChild(specguide);
specguide.x = 0;
specguide.y = 0;
specguide.rotation = 0;

function maxHeight(x:Number):Number {
	if (x < 176) {
		return 143;
	} else if (x < 251) {
		return 187;
	} else if (x < 1010) {
		return 426;
	} else if (x < 1140) {
		return 204;
	} else if (x < 1246) {
		return 137;
	} else {
		return 204;
	}
}

var spectrumArray:Array = new Array();
var i;
for (i = 0; i < 256; i++) {
	spectrumArray.push(new Sprite());
	specguide.addChild(spectrumArray[i]);
	spectrumArray[i].x = Math.floor(i * 5);
}

var huerot = 0;
function drawBox(b:Number, amplitude:Number) {
	spectrumArray[b].graphics.clear();
	spectrumArray[b].graphics.beginFill(colorFromHue(Math.floor((((b + huerot)%256)/256) * 360)));
	spectrumArray[b].graphics.drawRect(0,0,5, Math.round(amplitude * maxHeight(spectrumArray[b].x)));
	spectrumArray[b].graphics.endFill();
}

for (i = 0; i < 256; i++) {
	drawBox(i, Math.random());
}

var cloudbitmap:Cloud = new Cloud(1280, 720);
var cloud:Sprite = new Sprite();
cloud.graphics.beginBitmapFill(cloudbitmap);
cloud.graphics.drawRect(0, 0, 1280, 1440);
cloud.graphics.endFill();
bguide.addChild(cloud);
cloud.alpha = .6;

var maxval = .5;
var lastval:Array = new Array(256);
for(i = 0; i < 256; i++){
	lastval[i] = 0;
}

var bytes:ByteArray = new ByteArray();

var pattern:Array = new Array(1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,9,10,9,10,9,10,9,11,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,9,10,9,10,14,15,15,15,12,13,12,13,12,13,12,13,12,13,12,13,12,13,12,13,16,17,18,19,16,17,18,19,16,17,18,19,16,17,18,19);

var bar:Array = new Array();
bar.push(new Array(0x80,0x8,0x0,0x10,0x20,0x10,0x0,0x8,0x80,0x10,0x8,0x20,0x0,0x8,0x80,0x10)); //ID 1
bar.push(new Array(0x80,0x8,0x0,0x10,0x20,0x10,0x0,0x8,0x80,0x10,0x8,0x20,0x0,0x8,0x80,0x10)); //ID 2
bar.push(new Array(0x80,0x8,0x0,0x10,0x20,0x10,0x0,0x8,0x80,0x10,0x8,0x20,0x0,0x8,0x80,0x10)); //ID 3
bar.push(new Array(0x80,0x8,0x0,0x10,0x20,0x10,0x0,0x8,0x4,0x10,0x88,0x4,0x20,0x8,0x80,0x10)); //ID 4
bar.push(new Array(0x80,0x8,0x0,0x10,0x20,0x10,0x0,0x8,0x80,0x10,0x8,0x20,0x0,0x8,0x80,0x10)); //ID 5
bar.push(new Array(0x80,0x8,0x0,0x10,0x20,0x10,0x0,0x8,0x80,0x10,0x8,0x20,0x80,0x9,0x80,0x10)); //ID 6
bar.push(new Array(0x80,0x8,0x0,0x10,0x20,0x10,0x0,0x8,0x80,0x10,0x8,0x20,0x0,0x8,0x80,0x10)); //ID 7
bar.push(new Array(0x80,0x8,0x0,0x10,0x20,0x10,0x0,0x8,0x4,0x10,0x88,0x4,0x20,0x8,0x80,0x10)); //ID 8
bar.push(new Array(0x11,0xA,0x5,0x12,0x9,0x12,0x1,0x6,0x11,0xA,0x5,0x12,0x1,0x6,0x11,0x6)); //ID 9
bar.push(new Array(0x11,0xA,0x5,0x12,0x9,0x12,0x1,0x6,0x11,0xA,0x5,0x12,0x1,0x6,0x11,0x2)); //ID 10
bar.push(new Array(0x11,0xA,0x5,0x12,0x89,0x12,0x41,0x6,0x11,0xA,0x45,0x12,0x81,0x6,0x51,0x6)); //ID 11
bar.push(new Array(0x81,0xA,0x5,0x12,0x41,0x12,0x5,0xA,0x81,0x6,0x9,0x42,0x11,0xA,0x85,0x12)); //ID 12
bar.push(new Array(0x81,0xA,0x5,0x12,0x41,0x92,0x5,0x6,0x91,0x12,0x85,0x2A,0x11,0x2A,0x85,0xA)); //ID 13
bar.push(new Array(0x9,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0)); //ID 14
bar.push(new Array(0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0)); //ID 15
bar.push(new Array(0x81,0xA,0x5,0x12,0x41,0x12,0x85,0xA,0x1,0x4A,0x5,0x42,0x91,0x8A,0x5,0x52)); //ID 16
bar.push(new Array(0x91,0xA,0x5,0x12,0x41,0x92,0x5,0x11,0x91,0x52,0x85,0x2A,0x11,0x2A,0x85,0x12)); //ID 17
bar.push(new Array(0x81,0xA,0x5,0x12,0x41,0x12,0x85,0xA,0x1,0x4A,0x5,0x42,0x91,0x8A,0x5,0x52)); //ID 18
bar.push(new Array(0x91,0xA,0x5,0x12,0x41,0x92,0x5,0x11,0x91,0x52,0x85,0x2A,0x91,0x6A,0x5,0x52)); //ID 19

function getStep():Number {
	var ms = soundChannel.position % loop.length;
	var b = pattern[((Math.floor(ms/2400)<80)?(Math.floor(ms/2400)):0)];
	var sixteenth = Math.floor((ms%2400)/150);
	return bar[b-1][sixteenth];
}

var kick:Sprite = new Sprite();
kick.graphics.beginFill(0xFFFFFF);
kick.graphics.drawRect(0,0,106,226);
kick.graphics.endFill();
testguide.addChild(kick);
kick.x = 0;
kick.alpha = 0;

var snare1:Sprite = new Sprite();
snare1.graphics.beginFill(0xFFFFFF);
snare1.graphics.drawRect(0,0,132,226);
snare1.graphics.endFill();
testguide.addChild(snare1);
snare1.x = 106;
snare1.alpha = 0;

var snare2:Sprite = new Sprite();
snare2.graphics.beginFill(0xFFFFFF);
snare2.graphics.drawRect(0,0,132,226);
snare2.graphics.endFill();
testguide.addChild(snare2);
snare2.x = 238;
snare2.alpha = 0;

var hat1:Sprite = new Sprite();
hat1.graphics.beginFill(0xFFFFFF);
hat1.graphics.drawRect(0,0,114,226);
hat1.graphics.endFill();
testguide.addChild(hat1);
hat1.x = 370;
hat1.alpha = 0;

var hat2:Sprite = new Sprite();
hat2.graphics.beginFill(0xFFFFFF);
hat2.graphics.drawRect(0,0,105,226);
hat2.graphics.endFill();
testguide.addChild(hat2);
hat2.x = 484;
hat2.alpha = 0;

var hat3:Sprite = new Sprite();
hat3.graphics.beginFill(0xFFFFFF);
hat3.graphics.drawRect(0,0,85,226);
hat3.graphics.endFill();
testguide.addChild(hat3);
hat3.x = 589;
hat3.alpha = 0;

var shaker1:Sprite = new Sprite();
shaker1.graphics.beginFill(0xFFFFFF);
shaker1.graphics.drawRect(0,0,94,133);
shaker1.graphics.endFill();
testguide.addChild(shaker1);
shaker1.x = 674;
shaker1.alpha = 0;

var shaker2:Sprite = new Sprite();
shaker2.graphics.beginFill(0xFFFFFF);
shaker2.graphics.drawRect(0,0,94,93);
shaker2.graphics.endFill();
testguide.addChild(shaker2);
shaker2.x = 674;
shaker2.y = 133;
shaker2.alpha = 0;

function isActive(instrument:Number, stepvalue:Number, currentAlpha:Number):Number {
	//kick 8 snare1 6 snare2 5 hat1 4 hat2 3 hat3 2 shaker2 1 shaker1 0
	if(((1 << instrument) & stepvalue) > 0){
		return .9;
		
	}
	else return currentAlpha * .9;
}

function updatedrums(){
	var step = getStep();
	//var portion = (soundChannel.position%5120)/150;
	shaker2.alpha = isActive(0, step, shaker2.alpha);
	shaker1.alpha = isActive(1, step, shaker1.alpha);
	hat3.alpha = isActive(2, step, hat3.alpha);
	hat2.alpha = isActive(3, step, hat2.alpha);
	hat1.alpha = isActive(4, step, hat1.alpha);
	snare2.alpha = isActive(5, step, snare2.alpha);
	snare1.alpha = isActive(6, step, snare1.alpha);
	kick.alpha = isActive(7, step, kick.alpha);
}

function update() {
	SoundMixer.computeSpectrum(bytes, false, 0);
	for (var q = 0; q < 256; q++) {
		var temp = bytes.readFloat();
		lastval[q] = ((temp > lastval[q])? temp : lastval[q] * .95);
		if(temp > maxval) maxval = temp;
		drawBox(q, lastval[q] / maxval);
		
	}
	maxval = maxval * .99;
	cloud.y = cloud.y - 1;
	if (cloud.y <= -720) {
		cloud.y = 0;
	}
	huerot++;
	if(huerot > 255) huerot = 0;
	if(looping){
		updatedrums();
	}
}
