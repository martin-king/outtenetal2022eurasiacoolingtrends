clear all; close all; startup;
tic

%DJF, aave 45-110E, 40-60N, air temp at 925hPa
ceu=load('ceu_t2m_djf_era5.txt','-ascii');
ceuanom=ceu(:,3)-mean(ceu(:,3));
Pobs=polyfit(ceu(:,1),ceuanom,1);
ceuanom=ceuanom-Pobs(1,1).*ceu(:,1)-Pobs(1,2); %detrend

scrsz = get(0,'ScreenSize');
%[left, bottom, width, height]
figure('Position',[1 scrsz(4)/2 scrsz(3)/1.2 scrsz(4)/1.7]);
figure(1),clf
%autocorr(ceuanom); %requires econometrics toolbox
parcorr(ceuanom);

iy=find(ceu(:,1)>=1998 & ceu(:,1)<=2012); % years with strongest negative trend
Pobs=polyfit(ceu(iy,1),ceuanom(iy),1); %Pobs is observed trend in this period


scrsz = get(0,'ScreenSize');
%[left, bottom, width, height]
figure('Position',[1 scrsz(4)/2 scrsz(3)/1.2 scrsz(4)/1.7]);
figure(2),clf
plot(ceu(:,1),ceuanom,'k-o') % plot the whole observed time series
axis([1949 2020 -8 5])
title('Eurasia DJF temperature')

rho=0.2;
stdceu=std(ceuanom(1998-1950+1:2012-1950+1));
coeffa=sqrt(1.0-rho^2.0);

rng('shuffle')
trendsboot=[];
stdsaved=[];
acfsaved=[];

% simulate the AR1 model
for imcsim=1:20000
%    xt(1)=ceuanom(randi(73,1,1)); % pick a start
  xt=0.0; %ceuanom(2000-ceu(1,1)+1);
    for i=1:14
     xt(i+1)=rho*xt(i)+coeffa*stdceu*randn(1,1); %the AR1 
    end
    P=polyfit(ceu(iy,1)',xt,1);
%   P=polyfit([1:15],xt,1);
% [acf,lags,bounds] =autocorr(xt,1); % for checking autocorrelation and std
% acfsaved=[acfsaved acf(1,2)];
 stdsaved=[stdsaved mean(xt)];
    trendsboot=[trendsboot P(1,1)*10.0]; % K per decade in simulated AR1
end

% plot probability histogram for trends
scrsz = get(0,'ScreenSize');
%[left, bottom, width, height]
figure('Position',[1 scrsz(4)/2 scrsz(3)/1.2 scrsz(4)/1.7]);
figure(3),clf
hm=histogram(trendsboot,'BinWidth',0.1,'Normalization','probability'); % plot prob. hist. of artificial trends
axis([-4 4 0 0.07])
set(gca,'Xtick',[-3.5 -3. -2.5,-2,-1.5,-1,-0.5,0.,0.5,1.,1.5,2.,2.5 3. 3.5]);
ax = gca;
ax.TickLength = [0.02, 0.02]; % Make tick marks longer.
ax.LineWidth = 3;
title('Prob. Dist. of trends from AR1')

hold on;
plot(Pobs(1,1)*10.0,0,'r.','MarkerSize',80) %plot obs trend K per dec

hold off;
%i=find(cumsum(h.Values)<=0.05); 
%fifthpctl=h.BinEdges(max(i)); %find 5th pctl artificial trend
%plot(fifthpctl,0,'b.','MarkerSize',80,'LineWidth',5) %plot it

%i=find(cumsum(h.Values)>=0.95); 
%fifthpctl=h.BinEdges(min(i)); %find 95th pctl artificial trend
%plot(fifthpctl,0,'b.','MarkerSize',80,'LineWidth',5) %plot it
%

toc
 