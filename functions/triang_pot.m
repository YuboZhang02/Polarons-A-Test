% Triangular potential

function V=triang_pot(xi,yi,x_spacing,y_spacing,Fermi)

nx=length(xi);
ny=length(yi);

xmax=xi(end)+x_spacing/2;
ymax=yi(end)+y_spacing/2;

xpot=(xi(1):x_spacing:xmax);
xsize=length(xpot);
ypot=(yi(1):y_spacing:ymax);
ysize=length(ypot);

cPgrid = zeros(2, xsize*ysize);

midpoint = (xpot(floor(xsize/2)) + xpot(floor(xsize/2)+1))/2

V=zeros(nx,ny);

% pos_sigma = 0*spacing/2; % disorder with sigma proportional to spacing

spr = 1e-1; % bumps: 8e-2, wells: 1e-1 
% spr_sigma = 0*8e-2;

% hgt = 1;
% hgt_sigma = 0.06*1;

oddity = 0;

alpha=5e-2;

cnt=0;

for i=1:xsize
    for j=1:ysize
        % deviation in spread of bump
        % sprx_dev = spr_sigma * randn;
        % spry_dev = spr_sigma * randn;

        % deviation in position of bump
        % posx_dev = pos_sigma * randn;
        % posy_dev = pos_sigma * randn;

        % deviation in amplitude of bump
        % hgt_dev = hgt_sigma * randn;

        cnt = cnt+1;
        cPgrid(1, cnt) = xpot(i);
        cPgrid(2, cnt) = ypot(j)+ oddity * y_spacing / 2;
    end
    oddity = 1-oddity;
end

if Fermi == 1
    for k=1:cnt
        % Fermi
        for j=1:nx
            for i=1:ny
                V(i,j)=V(i,j)+1./(1+exp((sqrt((xi(j)-cPgrid(1,k))^2 ...
                    +(yi(i)-cPgrid(2,k))^2)-spr)/alpha));
                % r is almost the radius of bump
                % alpha is the sigma inside the exponential
            end
        end
    end
elseif Fermi == 0
    [xt,yt] = meshgrid(xi,yi);
    for k=1:cnt
        % Gaussian
        V=V+exp((-(xt-cPgrid(1,k)).^2-(yt-cPgrid(2,k)).^2)/spr*4);
        % sine x square (2+sin(pi*(2*x/xmax-1)^2))/3
    end
end
        

% Normalization of the potential
top=max(max(V));
bottom=min(min(V));
V=(V-bottom)/(top-bottom);
