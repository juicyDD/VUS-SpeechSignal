clear;
clc;
filePath='C:\Users\DELL\Desktop\ThiCK\TinHieuHuanLuyen\';
files = {'01MDA', '02FVA', '03MAB', '06FTB'};
%
s01MDA=[0 0;0.45 1;0.81 0;1.53 1;1.85 0;2.69 1;2.86 0;3.78 1;4.15 0;4.84 1;5.14 0];
s02FVA=[0 0; 0.83 1;1.37 0;2.09 1;2.6 0;3.57 1;4 0;4.76 1;5.33 0;6.18 1;6.68 0];
s03MAB=[0 0;1.03 1;1.42 0;2.46 1;2.8 0;4.21 1;4.52 0;6.81 1;7.14 0;8.22 1;8.5 0];
s06FTB=[0 0; 1.52 1;1.92 0;3.91 1;4.35 0;6.18 1;6.6 0;8.67 1;9.14 0;10.94 1;11.33 0];

%------------------s01MDA region
%------------------s01MDA region
[xi,Fsi]=audioread(char(strcat(filePath, files(1), '.wav')));
sams = round(Fsi*0.03); %samples per frame, frame length = 0.03 sec
seci=length(xi)/Fsi;
framesi=floor(length(xi)/(Fsi*0.01)-2); %foreach 0.01sec theres a brand new frame kicking off

VUS1=zeros(1,framesi);
for i=1:(length(s01MDA)-1)%findin the start frame and an end one of an arbitrary silence/voiced region
    l=floor(s01MDA(i,1)/0.01)+1+1;
    h=ceil(s01MDA((i+1),1)/0.01)+1;
    for j=l:h
        VUS1(j)=s01MDA(i,2);
    end;
end;
for j = 1 : framesi
        frame=xi(((j-1)*sams/3+1):((j-1)*sams/3+sams));
        zcr=0;%computing ZCR foreach frame
        for k=2:(sams)
            zcr=zcr+abs(sign(frame(k))-sign(frame(k-1)));
        end;
        zcr=zcr/sams;
        ZCRarr1(j)=zcr;
end;
%---------s02FVA region
%---------s02FVA region
xi=[];Fsi=[];frame=[];
[xi,Fsi]=audioread(char(strcat(filePath, files(2), '.wav')));
sams = round(Fsi*0.03); %samples per frame, frame length = 0.03 sec
seci=length(xi)/Fsi;
framesi=floor(length(xi)/(Fsi*0.01)-2); %foreach 0.01sec theres a brand new frame kicking off

VUS2=zeros(1,framesi);
for i=1:(length(s02FVA)-1)%findin the start frame and an end one of an arbitrary silence/voiced region
    l=floor(s02FVA(i,1)/0.01)+1+1;
    h=ceil(s02FVA((i+1),1)/0.01)+1;
    for j=l:h
        VUS2(j)=s02FVA(i,2);
    end;
end;
for j = 1 : framesi
        frame=xi(((j-1)*sams/3+1):((j-1)*sams/3+sams));
        zcr=0;%computing ZCR foreach frame
        for k=2:(sams)
            zcr=zcr+abs(sign(frame(k))-sign(frame(k-1)));
        end;
        zcr=zcr/sams;
        ZCRarr2(j)=zcr;
end;
%---------s03MAB region
%---------s03MAB region
xi=[];Fsi=[];frame=[];
[xi,Fsi]=audioread(char(strcat(filePath, files(3), '.wav')));
sams = round(Fsi*0.03); %samples per frame, frame length = 0.03 sec
seci=length(xi)/Fsi;
framesi=floor(length(xi)/(Fsi*0.01)-2); %foreach 0.01sec theres a brand new frame kicking off

VUS3=zeros(1,framesi);
for i=1:(length(s03MAB)-1)%findin the start frame and an end one of an arbitrary silence/voiced region
    l=floor(s03MAB(i,1)/0.01)+1+1;
    h=ceil(s03MAB((i+1),1)/0.01)+1;
    for j=l:h
        VUS3(j)=s03MAB(i,2);
    end;
end;
for j = 1 : framesi
        frame=xi(((j-1)*sams/3+1):((j-1)*sams/3+sams));
        zcr=0;%computing ZCR foreach frame
        for k=2:(sams)
            zcr=zcr+abs(sign(frame(k))-sign(frame(k-1)));
        end;
        zcr=zcr/sams;
        ZCRarr3(j)=zcr;
end;
%----------s06FTB region
%----------s06FTB region
xi=[];Fsi=[];frame=[];
[xi,Fsi]=audioread(char(strcat(filePath, files(4), '.wav')));
sams = round(Fsi*0.03); %samples per frame, frame length = 0.03 sec
seci=length(xi)/Fsi;
framesi=floor(length(xi)/(Fsi*0.01)-2); %foreach 0.01sec theres a brand new frame kicking off

VUS4=zeros(1,framesi);
for i=1:(length(s06FTB)-1)%findin the start frame and an end one of an arbitrary silence/voiced region
    l=floor(s06FTB(i,1)/0.01)+1+1;
    h=ceil(s06FTB((i+1),1)/0.01)+1;
    for j=l:h
        VUS4(j)=s06FTB(i,2);
    end;
end;
for j = 1 : framesi
        frame=xi(((j-1)*sams/3+1):((j-1)*sams/3+sams));
        zcr=0;%computing ZCR foreach frame
        for k=2:(sams)
            zcr=zcr+abs(sign(frame(k))-sign(frame(k-1)));
        end;
        zcr=zcr/sams;
        ZCRarr4(j)=zcr;
end;
%----------------------
ZCRarr=cat(2,ZCRarr1,ZCRarr2); 
ZCRarr=cat(2,ZCRarr,ZCRarr3);
ZCRarr=cat(2,ZCRarr,ZCRarr4);
ZCRtemp=max(ZCRarr);ZCRarr=ZCRarr./ZCRtemp;
VUSarr=cat(2,VUS1,VUS2); 
VUSarr=cat(2,VUSarr,VUS3);
VUSarr=cat(2,VUSarr,VUS4);
VUS1=[]; VUS2=[]; VUS3=[]; VUS4=[];%delete
ZCRarr1=[];ZCRarr2=[];ZCRarr3=[];ZCRarr4=[];%delete
j1=0;j2=0;
for i=1:length(ZCRarr)
    if(VUSarr(i)==0)
        j1=j1+1;
        ZCRSil(j1)=ZCRarr(i);
    elseif(VUSarr(i)==1)
        j2=j2+1;
        ZCRVoiced(j2)=ZCRarr(i);
    end;
    
end;
averageZCRV=mean(ZCRVoiced);
averageZCRSil=mean(ZCRSil);
%--plotting
subplot(2,1,1);
plot(1:length(ZCRVoiced),ZCRVoiced,'r-',1:length(ZCRVoiced),averageZCRV.* ones(length(ZCRVoiced),1),'b-');

legend('ZCR values of Voiced frames','Average value');
subplot(2,1,2);
plot(1:length(ZCRSil),ZCRSil,'k-',1:length(ZCRSil),averageZCRSil.*ones(length(ZCRSil),1),'b-');
legend('ZCR values of Silence frames','Average value');

