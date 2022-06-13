clear all; close all; startup;

%DJF, aave 45-110E, 40-60N, air temp at 2m
ceu=load('ceu_t2m_djf_era5.txt','-ascii');
ceuanom=ceu(:,3)-mean(ceu(:,3));
Pobs=polyfit(ceu(:,1),ceuanom,1);
ceuanom=ceuanom-Pobs(1,1).*ceu(:,1)-Pobs(1,2); %detrend

pobsstore=[];

for iy=1950:2020-14
    
Pobs=polyfit(ceu(iy-1949:iy+14-1949,1),ceuanom(iy-1949:iy+14-1949),1); %Pobs is observed trend in this period

pobsstore=[pobsstore Pobs(1,1)];

end

figure(1),clf
plot(1950:2020-14,pobsstore);