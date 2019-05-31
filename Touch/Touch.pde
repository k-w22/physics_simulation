boolean creationMode = false; //create particles?
PVector click = new PVector(0.0, 0.0); //coordinates of initial click
float velLen = 0;

void setup() {
	size(600, 600);
}

void draw() {
	clear();
	if (creationMode) {
		stroke(255, 165, 0); //set edge color
		fill(255, 165, 0);
		circle(click.x, click.y, 10); //initial position
		line(click.x, click.y, mouseX, mouseY);
		drawArrow(mouseX, mouseY, 20, 180 / PI * atan2(mouseY - click.y, mouseX - click.x));
	}
}

void mouseClicked() {
	if (!creationMode) click.set(mouseX, mouseY); //not creation mode, enter and save initial coordinates
	else {
		velLen = pow(mouseX - click.x, 2) + pow(mouseY - click.y, 2);
		System.out.println(velLen);
	}
	creationMode = !creationMode; //toggle
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
