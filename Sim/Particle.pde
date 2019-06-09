class Particle {
	//*****************CONSTANTS**************************
	float GRAVITATIONAL_CONSTANT = 66.743;
	final static float ELECTROSTATIC_CONSTANT = 8.98755;
	final static float FACTOR = 1;
	final static float STEP = 0.001;
	//****************************************************

	//vars
	PVector pos = new PVector(0, 0); //position
	PVector vel = new PVector(0, 0); //velocity
	PVector acc = new PVector(0, 0); //acceleration
	int mass = 16;
	float elasticity = 1.0;
	float pe = 0;
	float ke = 0;
	color c;

	Particle() {
		this.c = colors[(int) random(0, 6)];
	}

	Particle(float xpos, float ypos, float xvel, float yvel, int newMass, int colorIndex) {
		this();
		pos.set(xpos, ypos);
		vel.set(xvel, yvel);
		this.mass = newMass;
		this.c = colors[colorIndex];

		pos.set(250, 400);
		/* vel.set(1, 0); */
		/* vel.set(random(1, 10), random(1, 10)); */
	}

	PVector calculateForces() {
		PVector netForce = new PVector(0.0, 0.0);
		PVector force = new PVector(0.0, 0.0);
		float d = 0;
		/* for (int particle = 0; particle < existingParticles; particle++) { */
		/*     if (particles[particle] != this) { */
		/*         force = PVector.sub(particles[particle].pos, this.pos); */
		/*         d = force.mag(); */
		/*         if (d <= 5) { */
		/*             System.out.println("Particles occupied same location! Quitting program."); */
		/*             [> System.exit(1); <] */
		/*         } */
		/*         d = constrain(d, 1.0, 25.0); */
		/*         force.normalize(); */
		/*         float strength = (GRAVITATIONAL_CONSTANT * this.mass * particles[particle].mass) / (d * d); */
		/*         force.mult(strength); */
		/*         netForce.add(force); */
		/*     } */
		/* } */
		for (Attractor attractor : attractors) {
			force = PVector.sub(attractor.pos, this.pos);
			d = force.mag();
			if (d <= 5) {
				System.out.println("Particles occupied same location! Quitting program.");
				/* System.exit(1); */
			}
			force.normalize();
			float strength = (GRAVITATIONAL_CONSTANT * this.mass * attractor.mass) / (d * d);
			force.mult(strength);
			netForce.add(force);
		}
		return netForce;
	}

	void calculateAcc() {
		PVector f = PVector.div(calculateForces(), this.mass);
		acc.add(f);
	}

	void update() {
		calculateAcc();
		vel.add(acc);
		pos.add(vel);
		acc.mult(0);
		ke = 0.5 * this.mass * this.vel.magSq();
		for (Attractor attractor : attractors) pe = -0.5 * GRAVITATIONAL_CONSTANT * this.mass * attractor.mass / PVector.sub(attractor.pos, this.pos).mag();
		//when encountering canvas edge
		if (this.pos.x > 600 - this.mass / 2 || this.pos.x < this.mass / 2) this.vel.x = -this.vel.x;
		if (this.pos.y < this.mass / 2 || 600 - this.pos.y < this.mass / 2) this.vel.y = -this.vel.y;
		for (Particle particle : particles) {
			if (this != particle) {
				//detect collision
				PVector d = PVector.sub(particle.pos, this.pos);
				if (d.magSq() <= FACTOR * pow(this.mass + particle.mass, 2)) {
					this.vel.set(-this.vel.x, -this.vel.y);
				}
			}
		}
		for (Attractor attractor: attractors) {
			PVector d = PVector.sub(attractor.pos, this.pos);
			if (d.magSq() <= FACTOR * pow(this.mass + attractor.mass, 2)) {
				this.vel.set(-this.vel.x, -this.vel.y);
			}
		}
	}

	void display() {
		strokeWeight(1);
		stroke(this.c);
		fill(this.c);
		ellipse(pos.x, pos.y, mass, mass);
	}

	/* void move(Particle[] particles, int particle) { */
	/*     [> collide(particles, particle); <] */

	/*     //when encountering canvas edge */
	/*     if (this.pos.x > 650 - this.mass || this.pos.x < this.mass) this.vel.x = -this.vel.x; */
	/*     if (50 - this.pos.y > -this.mass || 600 - this.pos.y < this.mass) this.vel.y = -this.vel.y; */

	/*     for (int i = 0; i < particles.length; i++) { */
	/*         if (i != particle) calculatePos(particles[i]); */
	/*     } */

	/*     this.pos.set(this.pos.x + this.vel.x, this.pos.y + this.vel.y); */
	/*     [> this.pos.set(this.pos.x + this.vel.x, this.pos.y + this.vel.y, thispos.z + this.vel.z); <] */

	/*     fill(this.c); */
	/*     ellipse(this.pos.x, 600 - this.pos.y, (float) this.mass, (float) this.mass); */
	/* } */

	/* void collide(Particle[] particles, int particle) { */
	/*     for (int i = 0; i < particles.length; i++) { */
	/*         if (i != particle) { */
	/*             //detect collision */
	/*             float d = distSquared(particles[i]); */
	/*             if (d <= FACTOR * pow(this.mass + particles[i].mass, 2)) { */
	/*                 this.vel.set(-this.vel.x, -this.vel.y); */
	/*             } */
	/*         } */
	/*     } */
	/* } */

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
