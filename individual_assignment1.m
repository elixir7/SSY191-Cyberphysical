syms phi theta psi


%R[axis]_[to][from]

% Body to Intertial (world) - (Yaw, Roll, Pitch)
Rx_ib = [1 0 0; 0 cos(phi) -sin(phi); 0 sin(phi) cos(phi)];
Ry_ib = [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
Rz_ib = [cos(psi) -sin(psi) 0; sin(psi) cos(psi) 0; 0 0 1];

Rx_bi = Rx_ib';
Ry_bi = Ry_ib';
Rz_bi = Rz_ib';

Ryxz_ib = Ry_ib * Rx_ib * Rz_ib;
Ryxz_bi = Ry_bi * Rx_bi * Rz_bi;

fxyz_b = Ryxz_bi*[0 0 1]'

symmer(fxyz_b)


%%
symmer(Ryxz_bi)


%% Tests
Rzyx_ib = Rz_ib * Ry_ib * Rx_ib;
Rzyx_bi = Rz_bi * Ry_bi * Rx_bi;
symmer(Rzyx_bi)

%%
Rzyx_ib = Rz_ib * Ry_ib * Rx_ib
symmer(Rzyx_ib* [0 0 1]')
