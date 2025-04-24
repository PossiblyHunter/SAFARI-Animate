# SAFARI-Animate
This software is a visual aid meant to be combined with Sea-Safari which can be found here: https://github.com/SINS-Lab/SEA-SAFARI?tab=readme-ov-file
By using the .traj and .xyz files that are output from Sea-Safari, Safari-Animate creates a 3D environment in which the user can move around, see the collisions occur in seconds (done in femtoseconds in Sea-Safari), and be seen in a viewable size. The user can change the size of the ion and surface materials, as well as see the path the ion took, and see what surface atoms are effected by the ion.

# Setup and Testing:
- Clone this repository to a directory
- Either run it once, or create a directory in "documents" named SAFARI2
- Place a .traj file and .xyz file named "Ion.traj" and "Surface.xyz" respectively
- Make sure the .xyz file is spaced out using tabs, and that on the first line the number is followed by the ion material then the surface material (i.e. 251  Na  Au)
- Run the program
