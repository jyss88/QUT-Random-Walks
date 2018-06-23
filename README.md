# QUT Random Walks
A Matlab simulation of a population walking around a university campus, using random walks

The behaviour of a population walking around a university campus is simulated using random walks. The intent of the project was to identify which areas and buildings would be most visited, assuming a random walking behaviour for the population. 

## Basic overview
Particles, representing persons on campus, are given a fixed step size, and are randomly stepped left, right, up, or down for a number of iterations. 

The probability of stepping in each direction depends on where a particle is on the map. Particles on paths are more likely to follow the direction of said paths, whilst particles at junctions, or inside buildings have equal probability of stepping in either direction.

Upon hitting a barrier (stepping outside a path, or building), particles will be 'stepped back' to ensure they are always inside a path or buidling.

An animation of the simulation can be displayed.

At the end of the simulation, a histogram is generated, detailing the visitor statistics of each building. 

# Acknowledgements
This project was submitted as an assessment piece in 2015 at Queensland University of Technology, for the subject 'Computational Explorations' (course code MXB161). 

This project was completed in collaboration with fellow QUT students James Buckland, Alison Driver, [Kent Lowrey](mailto:kentos123@live.com), and Caity Strachan.
