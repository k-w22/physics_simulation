int posx, cr = 20, dir = 1;
boolean wrap;

void setup() {
	size(200,200);
}

void draw(){
	background(200,200,0);
	stroke(0,200,0);
	fill(200,0,200);
	circle(posx,height/2,2*cr);
	if ( wrap ) circle(posx-width,height/2,2*cr);
	move();
}

void move() {
	posx += dir;
	if ( posx > width-cr )                 wrap = true;
	if ( posx > width+cr )    { posx = cr; wrap = false; }
}
