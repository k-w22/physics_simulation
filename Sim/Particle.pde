class Particle {
	//*****************CONSTANTS**************************
	float GRAVITATIONAL_CONSTANT = 66.743;
	final static float ELECTROSTATIC_CONSTANT = 8.98755;
	final static float FACTOR = 1;
	final static float STEP = 0.001;
	final static int ON = 1;
	final static int OFF = 0;
	//****************************************************

	//vars
	PVector pos = new PVector(0, 0); //position
	PVector vel = new PVector(0, 0); //velocity
	PVector acc = new PVector(0, 0); //acceleration
	int mass = 4;
	float elasticity = 0.0;
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
		this.c = colors[colorIndex % 6];

		/* pos.set(300, 200); */
		/* vel.set(1, 0); */
		/* vel.set(random(0, 2), random(0, 2)); */
	}

	PVector calculateForces() {
		PVector netForce = new PVector(0.0, 0.0);
		PVector force = new PVector(0.0, 0.0);
		float d = 0;
		for (Particle particle : particles) {
			if (particle != this) {
				force = PVector.sub(particle.pos, this.pos);
				d = force.mag();
				if (d <= 20) {
					System.out.println("Particles occupied same location! Quitting program.");
					/* System.exit(1); */
				}
				d = constrain(d, 32.0, 1000.0);
				force.normalize();
				float strength = (GRAVITATIONAL_CONSTANT * this.mass * particle.mass) / (d * d);
				force.mult(strength);
				netForce.add(force);
			}
		}
		/* for (Attractor attractor : attractors) { */
		/*     force = PVector.sub(attractor.pos, this.pos); */
		/*     d = force.mag(); */
		/*     if (d <= 40) { */
		/*         System.out.println("Particles occupied same location! Quitting program."); */
		/*         System.exit(1); */
		/*     } */
		/*     force.normalize(); */
		/*     float strength = (GRAVITATIONAL_CONSTANT * this.mass * attractor.mass) / (d * d); */
		/*     force.mult(strength); */
		/*     netForce.add(force); */
		/* } */
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
		pe = 0;
		for (Particle particle : particles) {
			if (particle != this) pe += -0.5 * GRAVITATIONAL_CONSTANT * this.mass * particle.mass / PVector.sub(particle.pos, this.pos).mag();
		}

		/* for (Attractor attractor : attractors) pe = -0.5 * GRAVITATIONAL_CONSTANT * this.mass * attractor.mass / PVector.sub(attractor.pos, this.pos).mag(); */

		//when encountering canvas edge
		if (this.pos.x > 784 || this.pos.x < 16) this.vel.x = -this.vel.x;
		if (this.pos.y < 16 || this.pos.y > 784) this.vel.y = -this.vel.y;

		//collision with other particles
		for (Particle particle : particles) {
			if (this != particle) {
				PVector distVec = PVector.sub(particle.pos, this.pos);
				float distVecMag = distVec.mag();
				float minDist = 32;
				if (distVecMag < minDist) {
					float distCorrection = (minDist - distVecMag) / 2.0;
					PVector d = distVec.copy();
					PVector correctionVec = d.normalize().mult(distCorrection);
					particle.pos.add(correctionVec);
					this.pos.sub(correctionVec);

					PVector collisionPoint = new PVector((this.pos.x + particle.pos.x) / 2, (this.pos.y + particle.pos.y) / 2);
					PVector normal = PVector.sub(this.pos, collisionPoint);
					PVector tangent = normal.copy();
					tangent.rotate(-HALF_PI);
					PVector vn = sdot(vdot(this.vel, normal) / normal.magSq(), normal);
					PVector ovn = sdot(vdot(particle.vel, normal) / normal.magSq(), normal);
					PVector vt = sdot(vdot(this.vel, tangent) / tangent.magSq(), tangent);
					PVector ovt = sdot(vdot(particle.vel, tangent) / tangent.magSq(), tangent);

					float a = (elasticity * particle.mass * (sign(ovn, normal) * ovn.mag() - sign(vn, normal) * vn.mag()) + this.mass * sign(vn, normal) * vn.mag() + particle.mass * sign(ovn, normal) * ovn.mag()) / (this.mass + particle.mass);
					PVector fvn = normal.copy();
					(fvn.normalize()).mult(a);

					float b = (elasticity * this.mass * (sign(vn, normal) * vn.mag() - sign(ovn, normal) * ovn.mag()) + this.mass * sign(vn, normal) * vn.mag() + particle.mass + sign(ovn, normal) * ovn.mag()) / (this.mass + particle.mass);
					PVector fovn = normal.copy();
					(fovn.normalize()).mult(b);

					//update velocities
					this.vel.set(vt.x + fvn.x, vt.y + fvn.y);
					particle.vel.set(ovt.x + fovn.x, ovt.y + fovn.y);

					this.pos.add(vel);
					particle.pos.add(particle.vel);
				}
			}
		}

		/* for (Attractor attractor: attractors) { */
		/*     PVector d = PVector.sub(attractor.pos, this.pos); */
		/*     if (d.mag() <= FACTOR * this.mass / 2 + attractor.mass / 2) { */
		/*         this.vel.set(-this.vel.x, -this.vel.y); */
		/*     } */
		/* } */
	}

	void display() {
		strokeWeight(1);
		stroke(this.c);
		fill(this.c);
		ellipse(pos.x, pos.y, 32, 32);
	}

	void getProp() {
		System.out.println("pos: (" + pos.x + ", " + pos.y + ")");
		System.out.println("xvel: " + vel.x);
		System.out.println("yvel: " + vel.y);
		System.out.println("xacc: " + acc.x);
		System.out.println("yacc: " + acc.y);
		System.out.println("mass: " + mass);
		System.out.println("elasticity: " + elasticity);
		System.out.println("ke: " + ke);
		System.out.println("pe: " + pe);
	}

	float vdot(PVector a, PVector b) {
		return a.x * b.x + a.y * b.y;
	}

	PVector sdot(float c, PVector v) {
		PVector p = new PVector(c * v.x, c * v.y);
		return p;
	}

	float sign(PVector a, PVector b) {
		if (vdot(a, b) == 0) return 0;
		return vdot(a, b) / abs(vdot(a, b));
	}
}
