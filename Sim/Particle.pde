class Particle {
	//*****************CONSTANTS**************************
	final static float GRAVITATIONAL_CONSTANT = 6674.3;
	final static float ELECTROSTATIC_CONSTANT = 8.98755;
	final static int OFF = 0;
	final static int ON = 1;
	final static float FACTOR = 0.3;
	final static float step = 0.001;
	//****************************************************

	//vars
	PVector pos; //position
	PVector vel; //velocity
	PVector acc; //acceleration
	int mass = 50;
	float elasticity = 1.0;
	color c;

	Particle() {
		this.c = colors[(int) random(0, 6)];
	}

	Particle(float newXpos, float newYpos, float newXvel, float newYvel, int newMass) {
		this();
		this.pos = new PVector(0.0, 0.0);
		this.vel = new PVector(0.0, 0.0);
		this.acc = new PVector(0.0, 0.0);
		pos.set(newXpos, newYpos);
		vel.set(newXvel, newYvel);
		this.mass = newMass;

		/* vel.set(random(1, 10), random(1, 10)); */
	}

	Particle(float newXpos, float newYpos, float newZpos, float newXvel, float newYvel, float newZvel, int newMass) {
		this();
		this.pos = new PVector(0.0, 0.0, 0.0);
		this.vel = new PVector(0.0, 0.0, 0.0);
		this.acc = new PVector(0.0, 0.0, 0.0);
		pos.set(newXpos, newYpos, newZpos);
		vel.set(newXvel, newYvel, newZvel);
		this.mass = newMass;

		/* vel.set(random(1, 10), random(1, 10), random(1, 10)); */
	}

	float distSquared(Particle otherParticle) {
		return pow(otherParticle.pos.x - this.pos.x, 2) + pow(otherParticle.pos.y - this.pos.y, 2);
	}

	float distSquared3(Particle otherParticle) {
		return pow(otherParticle.pos.x - this.pos.x, 2) + pow(otherParticle.pos.y - this.pos.y, 2) + pow(otherParticle.pos.z - this.pos.z, 2);
	}

	PVector calculateAcc(Particle otherParticle) {
		float d = sqrt(distSquared(otherParticle));
		if (d <= 1) {
			System.out.println("Particles occupied same location! Quitting program.");
			System.exit(1);
		}

		//apply gravitational law
		PVector ret = new PVector(0.0, 0.0);
		/* PVector ret = new PVector(0.0, 0.0, 0.0); */
		float xdiff = otherParticle.pos.x - this.pos.x;
		float ydiff = otherParticle.pos.y - this.pos.y;
		/* float zdiff = otherParticle.pos.z - this.pos.z; */
		ret.set(GRAVITATIONAL_CONSTANT * otherParticle.mass / pow(d, 3) * xdiff, GRAVITATIONAL_CONSTANT * otherParticle.mass / pow(d, 3) * ydiff);
		/* ret.set(GRAVITATIONAL_CONSTANT * otherParticle.mass / pow(d, 3) * xdiff, GRAVITATIONAL_CONSTANT * otherParticle.mass / pow(d, 3) * ydiff, GRAVITATIONAL_CONSTANT * otherParticle.mass / pow(d, 3) * zdiff); */

		return ret;
	}

	void calculateVel(Particle otherParticle) {
		PVector tmp = calculateAcc(otherParticle);
		vel.set(vel.x + step * tmp.x, vel.y + step * tmp.y);
		/* vel.set(vel.x + step * tmp.x, vel.y + step * tmp.y, vel.z + step * tmp.z); */
	}

	void calculatePos(Particle otherParticle) {
		calculateVel(otherParticle);
		pos.set(pos.x + step * vel.x, pos.y + step * vel.y);
		/* pos.set(pos.x + step * vel.x, pos.y + step * vel.y, pos.z + step * vel.z); */
	}

	void move(Particle[] particles, int particle) {
		/* collide(particles, particle); */

		//when encountering canvas edge
		if (this.pos.x > 650 - this.mass || this.pos.x < this.mass) this.vel.x = -this.vel.x;
		if (50 - this.pos.y > -this.mass || 600 - this.pos.y < this.mass) this.vel.y = -this.vel.y;

		for (int i = 0; i < particles.length; i++) {
			if (i != particle) calculatePos(particles[i]);
		}

		this.pos.set(this.pos.x + this.vel.x, this.pos.y + this.vel.y);
		/* this.pos.set(this.pos.x + this.vel.x, this.pos.y + this.vel.y, thispos.z + this.vel.z); */

		fill(this.c);
		ellipse(this.pos.x, 600 - this.pos.y, (float) this.mass, (float) this.mass);
	}

	void collide(Particle[] particles, int particle) {
		for (int i = 0; i < particles.length; i++) {
			if (i != particle) {
				//detect collision
				float d = distSquared(particles[i]);
				if (d <= FACTOR * pow(this.mass + particles[i].mass, 2)) {
					this.vel.set(-this.vel.x, -this.vel.y);
				}
			}
		}
	}

	void getProp() {
		System.out.println("pos: (" + pos.x + ", " + pos.y + ")");
		System.out.println("xvel: " + vel.x);
		System.out.println("yvel: " + vel.y);
		System.out.println("xacc: " + acc.x);
		System.out.println("yacc: " + acc.y);
		System.out.println("mass: " + mass);
		System.out.println("elasticity: " + elasticity);
	}
}
