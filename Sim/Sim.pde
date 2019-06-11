import java.util.ArrayList;

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

//properties of system
PVector com = new PVector(500, 400);
int comm = 0;
float ke = 0;

final static int MAX_NUMBER = 25; //max number of particles in canvas
int existingParticles = 0; //number of particles in canvas
ArrayList<Particle> particles;
/* ArrayList<Attractor> attractors; */

boolean creationMode = false; //create particles?
PVector click = new PVector(0.0, 0.0); //coordinates of initial click
float clickLen = 0; //length of velocity arrow during creation mode

void setup() {
	size(1200, 800);

	particles = new ArrayList<Particle>(MAX_NUMBER); //create array with 0 meaningful elements

	/*
	for (int i = 0; i < MAX_NUMBER; i++) {
		particles.add(new Particle((int) random(16, 984), 800 - (int) random(16, 784), 0, 0, 9, existingParticles));
		existingParticles++;
	}

	attractors = new ArrayList<Attractor>(2);
	attractors.add(new Attractor(500, 400));
	attractors.add(new Attractor(100, 400));
	*/
}

void draw() {
	background(35);

	if (creationMode) {
		strokeWeight(2);
		stroke(255, 165, 0);
		fill(255, 165, 0);
		circle(click.x, click.y, 10); //initial position
		PVector v = new PVector(mouseX - click.x, mouseY - click.y);
		float vMag = v.mag();
		vMag = constrain(vMag, 0.0, 100.0);
		(v.normalize()).mult(vMag); //constrain size of arrow
		line(click.x, click.y, click.x + v.x, click.y + v.y);
		drawArrow(click.x + v.x, click.y + v.y, 20, 180 / PI * atan2(mouseY - click.y, mouseX - click.x));
	}

	if (existingParticles > 0) {
		for (Particle particle : particles) particle.update();
		for (Particle particle : particles) particle.display();
		for (Particle particle : particles) {
			if (particle.collisionState == -1) {
				particle.pos.add(particle.futureVel);
				particle.vel.set(particle.futureVel.x, particle.futureVel.y);
				particle.collisionState = -2;
			}
		}

		//center of mass and energy
		com.mult(0);
		comm = 0;
		ke = 0;
		for (Particle particle : particles) {
			com.x += particle.mass * particle.pos.x;
			com.y += particle.mass * particle.pos.y;
			comm += particle.mass;
			ke += particle.ke;
		}
		com.x /= comm;
		com.y /= comm;
		strokeWeight(1);
		stroke(255);
		fill(255);
		ellipse(com.x, com.y, 10, 10);

		/*
		for (Attractor attractor : attractors) {
			attractor.drag();
			attractor.hover(mouseX, mouseY);
			attractor.display();
		}
		*/

		//panel
		strokeWeight(1);
		stroke(200);
		fill(200);
		rect(1000, 0, 200, 800);
		fill(0);
		textSize(32);
		textAlign(CENTER);
		text("KE:", 1100, 50);
		text("mass:", 1100, 500);
		text("elasticity:", 1100, 600);
		text("G:", 1100, 700);
		textSize(16);
		text(ke, 1100, 75);
		text(particles.get(0).mass, 1100, 525);
		text(particles.get(0).elasticity, 1100, 625);
		text(particles.get(0).GRAVITATIONAL_CONSTANT / 6.6743, 1100, 725);
	}
}

/*
void mousePressed() {
	for (Attractor attractor : attractors) attractor.clicked(mouseX, mouseY);
}

void mouseReleased() {
	for (Attractor attractor : attractors) attractor.stopDragging();
}
*/

void mouseClicked() {
	if (!creationMode) {
		if (mouseX < 1000) click.set(mouseX, mouseY); //not creation mode, enter and save initial coordinates
		else creationMode = !creationMode;
	}
	else {
		PVector v = new PVector(mouseX - click.x, mouseY - click.y);
		float vMag = v.mag();
		vMag = constrain(vMag, 0.0, 100.0);
		(v.normalize()).mult(vMag); //constrain size of arrow
		particles.add(new Particle(click.x, click.y, v.x / 50, v.y / 50, 9, existingParticles)); //constrain velocity
		existingParticles++;
	}
	creationMode = !creationMode; //toggle
}

void keyPressed() {
	if (key == CODED) {
		if (keyCode == UP) {
			for (Particle particle : particles) {
				particle.elasticity += 0.1;
				particle.elasticity = constrain(particle.elasticity, 0.0, 1.0);
			}
		} else if (keyCode == DOWN) {
			for (Particle particle : particles) {
				particle.elasticity -= 0.1;
				particle.elasticity = constrain(particle.elasticity, 0.0, 1.0);
			}
		}
	} else {
		if (key == 'a') {
			for (Particle particle : particles) {
				particle.mass += 1;
				particle.mass = constrain(particle.mass, 1, 14);
			}
		} else if (key == 'd') {
			for (Particle particle : particles) {
				particle.mass -= 1;
				particle.mass = constrain(particle.mass, 1, 14);
			}
		} else if (key == 'w') {
			for (Particle particle : particles) {
				particle.GRAVITATIONAL_CONSTANT += 6.6743;
				particle.GRAVITATIONAL_CONSTANT = constrain(particle.GRAVITATIONAL_CONSTANT, 0.0, 66.743);
			}
		} else if (key == 's') {
			for (Particle particle : particles) {
				particle.GRAVITATIONAL_CONSTANT -= 6.6743;
				particle.GRAVITATIONAL_CONSTANT = constrain(particle.GRAVITATIONAL_CONSTANT, 0.0, 66.743);
			}
		}
	}
}

void drawArrow(float cx, float cy, int len, float angle) {
	pushMatrix();
	translate(cx, cy);
	rotate(radians(angle));
	line(0, 0, len, 0);
	line(len, 0, len - 8, -8);
	line(len, 0, len - 8, 8);
	popMatrix();
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
