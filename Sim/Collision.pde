/*
Ball[] balls =  {
	new Ball(200, 200, 20, -1, 0),
	new Ball(400, 200, 20, -2 ,0),
	new Ball(500, 200, 20, -2.5, 0)
};

void setup() {
	size(600, 400);
}

void draw() {
	background(51);
	balls[0].checkCollision(balls[1]);

	for (Ball b : balls) {
		b.update();
		b.display();
		b.checkBoundaryCollision();
	}

	balls[0].checkCollision(balls[1]);
	balls[0].checkCollision(balls[2]);
	balls[1].checkCollision(balls[2]);
}







class Ball {
	PVector position;
	PVector velocity;
	float COR = 1.0;

	float radius, m;

	Ball(float x, float y, float r_, float vx, float vy) {
		position = new PVector(x, y);
		//velocity = PVector.random2D();
		//velocity.mult(3);
		radius = r_;
		m = radius*.1;
		velocity = new PVector();
		velocity.set(vx, vy);
	}

	void update() {
		position.add(velocity);
	}

	void checkBoundaryCollision() {
		if (position.x > width-radius) {
			position.x = width-radius;
			velocity.x *= -1;
		} else if (position.x < radius) {
			position.x = radius;
			velocity.x *= -1;
		} else if (position.y > height-radius) {
			position.y = height-radius;
			velocity.y *= -1;
		} else if (position.y < radius) {
			position.y = radius;
			velocity.y *= -1;
		}
	}

	void checkCollision(Ball other) {

		// Get distances between the balls components
		PVector distanceVect = PVector.sub(other.position, position);

		// Calculate magnitude of the vector separating the balls
		float distanceVectMag = distanceVect.mag();

		// Minimum distance before they are touching
		float minDistance = radius + other.radius;

		if (distanceVectMag < minDistance) {
			float distanceCorrection = (minDistance-distanceVectMag)/2.0;
			PVector d = distanceVect.copy();
			PVector correctionVector = d.normalize().mult(distanceCorrection);
			other.position.add(correctionVector);
			position.sub(correctionVector);


			PVector collisionPoint = new PVector((position.x + other.position.x) / 2, (position.y + other.position.y) / 2);
			PVector normal = PVector.sub(position, collisionPoint);
			PVector tangent = normal.copy();
			tangent.rotate(-HALF_PI);
			PVector vn = sdot(vdot(velocity, normal) / normal.magSq(), normal);
			PVector ovn = sdot(vdot(other.velocity, normal) / normal.magSq(), normal);
			PVector vt = sdot(vdot(velocity, tangent) / tangent.magSq(), tangent);
			PVector ovt = sdot(vdot(other.velocity, tangent) / tangent.magSq(), tangent);

			float a = (COR * other.m * (sign(ovn, normal) * ovn.mag() - sign(vn, normal) * vn.mag()) + m * sign(vn, normal) * vn.mag() + other.m * sign(ovn, normal) * ovn.mag()) / (m + other.m);
			PVector fvn = normal.copy();
			(fvn.normalize()).mult(a);

			float b = (COR * m * (sign(vn, normal) * vn.mag() - sign(ovn, normal) * ovn.mag()) + m * sign(vn, normal) * vn.mag() + other.m * sign(ovn, normal) * ovn.mag()) / (m + other.m);
			PVector fovn = normal.copy();
			(fovn.normalize()).mult(b);


			// update velocities
			velocity.set(vt.x + fvn.x, vt.y + fvn.y);
			other.velocity.set(ovt.x + fovn.x, ovt.y + fovn.y);

			position.add(velocity);
			other.position.add(other.velocity);
		}
	}

	void display() {
		noStroke();
		fill(204);
		ellipse(position.x, position.y, radius*2, radius*2);
	}
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
*/
