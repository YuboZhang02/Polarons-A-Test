function output = dispersion_relation(dspr_type,qx,qy,vs,a)
%OMEGA dispersion relation, q as input, output ω(q)

% q should be a matrix with each element represents the norm of q

% default set as linear
q = sqrt(qx.^2+qy.^2);
switch dspr_type
    case 'Linear'
        output = vs*q;
    case 'Acoustic'
        output = 2*vs/a*sqrt(sin(a*qx/2).^2+sin(a*qy/2).^2);
    case 'Optic'
        output = 2*vs/a*sqrt(2+cos(a*qx/2).^2+cos(a*qy/2).^2);
    otherwise
        error('Unknown wavepacket type')
end