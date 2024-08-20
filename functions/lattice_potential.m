function output=lattice_potential(x,y,e,Lx,Ly,lattice_number,lattice_strength)
% set the lattice potential here

output=lattice_strength*0.01*e*square_pot(x',y,Lx/lattice_number,Ly/lattice_number,1);

end