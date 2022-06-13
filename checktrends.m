clear all; close all; startup;

%JFM, aave 60-120E, 40-60N, air temp at 925hPa
ceu=load('ceu_air925_djf.txt','-ascii');
ceuanom=ceu(:,3)-mean(ceu(:,3));
Pobs=polyfit(ceu(:,1),ceuanom,1);
ceuanom=ceuanom-Pobs(1,1).*ceu(:,1)-Pobs(1,2); %detrend

pobsstore=[];

for iy=1949:2020-14
    
Pobs=polyfit(ceu(iy-1948:iy+14-1948,1),ceuanom(iy-1948:iy+14-1948),1); %Pobs is observed trend in this period

pobsstore=[pobsstore Pobs(1,1)];

end

figure(1),clf
plot(1949:2020-14,pobsstore);