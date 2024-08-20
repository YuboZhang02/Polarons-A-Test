%%% Input: Dispersion Type and parameter
%%% Rectangle lattice: Rectangle,kx,ky,a,b,t1,t2,E0
%%% Linear: Linear,kx,ky,vf
%%% Parabolic: Parabolic,kx,ky,m_e
%%% Paremeter from a file, to be added
%%% Output: E(\vec{k}) as a matrix

function E_k=band_structure(ss)
    switch ss.BS_type
        case 'Rectangle'
            
            E_k = -2*(ss.t1*cos(ss.a*ss.kx) + ss.t2*cos(ss.a*ss.ky));
            
        case 'Linear'
            vf   = hbar*ss.kF/ss.mass;
            E_k  = hbar*sqrt(ss.kx.^2+ss.ky.^2)*vf; 

        case 'Parabolic'
            E_k  = hbar^2*(ss.kx.^2+ss.ky.^2)/2/ss.mass; 
            
        otherwise
            error('Unknown type, please choose in the following: Rectangle,Linear,Parabolic');
    end
end
