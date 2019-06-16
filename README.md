# BadPhysics

**Kevin Wang**

**AP Physics C Final Project**

**Pd 8/9**

## Project Description

The program simulates the motion of particles acting under gravity. Conservation of linear momentum is demonstrated as well through particle collisions. The program has a canvas where the particles are simulated and there is a panel that displays some properties of the system. The user is able to create new particles and adjust the values of the gravitational constant, masses of the particles, and elasticity of the particles.

## Game Controls

**Up** increase the elasticity of the particles*

**Down** decrease the elasticity of the particles*

**A** increase the mass of the particles

**D** decrease the mass of the particles

**W** increase the gravitational constant strength

**S** decrease the gravitational constant strength

**C** toggle the boundaries

**R** remove all particles from the canvas

To create particles, click in the canvas and direct the mouse in the direction of the velocity. The length of the arrow corresponds to the magnitude of the velocity.

*
 - e = 0 perfectly inelastic
 - 0 < e < 1 inelastic
 - e = 1 elastic
 - e > 1 superelastic

## Assumptions and Restrictions

- The particles are treated as being massive enough to gravitationally attract one another

- The maximum number of particles allowed is six particles.

- The masses of the particles is limited to a certain range.

- The gravitational constant strength if limited to a certain range.

- All particles have the same mass and elasticity.

- All particles are of the same size.

- The particles are treated as point masses in collisions (i.e, there is no spin).

## Bugs

- turning on container can result in some chaotic behavior near the boundaries

- particles behave unrealistically under gravity with low elasticity when they collide
