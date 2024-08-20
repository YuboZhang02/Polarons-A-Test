addallpath;

ss=setup(read_input('SrRuO_lat'));

[SrRuO_lat.psi, SrRuO_lat.psip, SrRuO_lat.E] = show_bound_state(ss);

%%
ss=setup(read_input('SrRuO'));

[SrRuO.psi, SrRuO.psip, SrRuO.E] = show_bound_state(ss);

%%

K = band_structure(ss);
N = ss.Nx*ss.Ny;
i=4;
Hpsi=ifft2(K.*psip(:,:,i))*sqrt(N)+ss.U_0.*psi(:,:,i);
%norm=sqrt(sum(sum(conj(Hpsi).*Hpsi)));
psi_new=Hpsi/E(i);
figure
imagesc(real(psi(:,:,i)));
figure
imagesc(real(psi_new));
residual=1-sum(sum(conj(psi(:,:,i)).*psi_new));
