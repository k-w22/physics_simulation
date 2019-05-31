///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
//               SHOW LINEAR PATH OF COM
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
//*********************************
//            colors
color red = color(220, 20, 60);
color moss = color(173, 223, 173);
color wood = color(222, 184, 135);
color pink = color(255, 85, 163);
color blue = color(212, 240, 255);
color gold = color(212, 175, 55);
//*********************************
color[] colors = {red, moss, wood, pink, blue, gold};

PVector com = new PVector(0.0, 0.0);
/* PVector com3 = new PVector(0.0, 0.0, 0.0); */
float x = 0;
float y = 0;
final static int MAX_NUMBER = 5; //max number of particles in canvas
int existingParticles = 0; //number of particles in canvas
Particle[] particles;

void setup() {
	/*********************************************
	  different canvas size and renderer options
	  must be first thing in setup
	 *********************************************/
	size(800, 600); //faster than default renderer for most tasks, but sacrifices some visual quality for speed
	background(50);
	/* frameRate(60); */

	particles = new Particle[MAX_NUMBER]; //create array with 0 meaningful elements
	//instantiate particles
	for (int i = 0; i < MAX_NUMBER; i++) {
		particles[i] = new Particle((int) random(50, 650), 600 - (int) random(50, 550), 0, 0, 50);
		existingParticles++; //increment number of objects that are meaningful in the array
	}
	for (int i = 0; i < MAX_NUMBER; i++) {
		particles[i].getProp();
	}
}

void draw() {
	/* clear(); //creates illusion of animation */
	rect(700, 0, 100, 600);
	//whenImBored();
	//move balls
	for (int particle = 0; particle < existingParticles; particle++) particles[particle].move(particles, particle);

	for (int particle = 0; particle < existingParticles; particle++) {
		x += particles[particle].mass * particles[particle].pos.x;
		y += particles[particle].mass * particles[particle].pos.y;
	}
	x /= (existingParticles * 50);
	y /= (existingParticles * 50);
	circle(x, y, 10);
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
