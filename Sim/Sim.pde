//*********************************
//            colors
color gold = color(212, 175, 55);
color red = color(220, 20, 60);
color blue = color(212, 240, 255);
color wood = color(222, 184, 135);
color pink = color(255, 85, 163);
color moss = color(173, 223, 173);
//*********************************
color[] colors = {gold, red, blue, wood, pink, moss};

PVector com = new PVector(300, 300);
int comm = 0;

final static int MAX_NUMBER = 6; //max number of particles in canvas
int existingParticles = 0; //number of particles in canvas
Particle[] particles;

//////////////////////////////////////////
//////////////////////////////////////////
//////////////////////////////////////////
//////////////////////////////////////////
//////////////////////////////////////////
//////////////////////////////////////////
//////////////////////////////////////////
Attractor[] attractors;
//////////////////////////////////////////

void setup() {
	size(800, 600);
	background(75);
	/* frameRate(60); */

	//////////////////////////////////////////
	//////////////////////////////////////////
	//////////////////////////////////////////
	//////////////////////////////////////////
	//////////////////////////////////////////
	//////////////////////////////////////////
	//////////////////////////////////////////
	particles = new Particle[MAX_NUMBER]; //create array with 0 meaningful elements
	for (int i = 0; i < MAX_NUMBER; i++) {
		particles[i] = new Particle((int) random(8, 592), 600 - (int) random(8, 592), 0, 0, 16, existingParticles);
		existingParticles++;
	}

	for (int i = 0; i < MAX_NUMBER; i++) particles[i].getProp();

	attractors = new Attractor[2];
	attractors[0] = new Attractor();
	attractors[1] = new Attractor(200, 200);
	//////////////////////////////////////////
}

void draw() {
	clear(); //creates illusion of animation
	background(75);
	strokeWeight(1);
	stroke(200);
	fill(200);
	rect(600, 0, 200, 600);

	for (Particle particle : particles) particle.update();
	for (Particle particle : particles) particle.display();

	//center of mass
	com.mult(0);
	comm = 0;
	for (Particle particle : particles) {
		com.x += particle.mass * particle.pos.x;
		com.y += particle.mass * particle.pos.y;
		comm += particle.mass;
	}
	com.x /= comm;
	com.y /= comm;
	strokeWeight(1);
	stroke(255);
	fill(255);
	ellipse(com.x, com.y, 10, 10);

	//////////////////////////////////////////
	//////////////////////////////////////////
	//////////////////////////////////////////
	//////////////////////////////////////////
	//////////////////////////////////////////
	//////////////////////////////////////////
	//////////////////////////////////////////
	for (Attractor attractor : attractors) {
		attractor.drag();
		attractor.hover(mouseX, mouseY);
		attractor.display();
	}
	//////////////////////////////////////////
}

void mousePressed() {
	for (Attractor attractor : attractors) attractor.clicked(mouseX, mouseY);
}

void mouseReleased() {
	for (Attractor attractor : attractors) attractor.stopDragging();
}

class Attractor {
	int mass;
	PVector pos;
	boolean dragging = false;
	boolean rollover = false;
	PVector dragOffset;

	Attractor() {
		pos = new PVector(width / 2, height / 2);
		mass = 50;
		dragOffset = new PVector(0, 0);
	}

	Attractor(float xpos, float ypos) {
		this();
		pos.set(xpos, ypos);
	}

	void display() {
		strokeWeight(1);
		stroke(0);
		if (dragging) fill(50);
		else if (rollover) fill(100);
		else fill(0);
		ellipse(pos.x, pos.y, mass, mass);
	}

	//determine whether mouse is close enough
	void clicked(int mx, int my) {
		float d = dist(mx, my, pos.x, pos.y);
		if (d < mass) {
			dragging = true;
			dragOffset.x = pos.x - mx;
			dragOffset.y = pos.y - my;
		} else {
			dragging = false;
		}
	}

	//determine if mouse if over it
	void hover(int mx, int my) {
		float d = dist(mx, my, pos.x, pos.y);
		if (d < mass) rollover = true;
		else rollover = false;
	}

	void stopDragging() {
		dragging = false;
	}

	void drag() {
		if (dragging) {
			pos.x = mouseX + dragOffset.x;
			pos.y = mouseY + dragOffset.y;
		}
	}
}

//requires P3D as renderer
void whenImBored() {
	camera(0.0, 0.0, 200.0, 100.0, 50.0, 0.0, 0.0, 1.0, 0.0);
	rotateX(-PI / 6);
	rotateY(PI / 3);
	for (int i = 0; i < 256; i += 8) {
		for (int j = 0; j < 256; j += 8) {
			for (int k = 0; k < 256; k += 8) {
				stroke(i, j, k);
				point(i, j, k);
			}
		}
	}
}
