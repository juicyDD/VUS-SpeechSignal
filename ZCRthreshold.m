clear;
clc;
filePath='D:\NhiEbook\XL tin hieu\BT nhom\TinHieuHuanLuyen\';
files = {'phone_F1', 'phone_M1', 'studio_F1', 'studio_M1'};

phone_F1=[0 0;0.53 1;1.14 2; 1.21 1;1.35 2;1.45 1;1.6 2;1.83 1;2.2 2; 2.28 1;2.35 2;2.4 1;2.52 2;2.66 1;2.73 0];
phone_M1=[0 0;0.46 1;1.39 2;1.5 1;1.69 2;1.79 1;2.78 2;2.86 1;2.93 2;3.1 1;3.29 2;3.45 1;3.52 0];
studio_F1=[0 0;0.68 2;0.7 1;1.1 2; 1.13 1;1.22 2;1.27 1;1.65 2;1.7 1;1.76 2;1.79 1;1.86 2;1.92 1;2.15 0];
studio_M1=[0 0;0.87 2;0.94 1;1.26 2;1.33 1;1.59 2;1.66 1;1.78 2;1.82 1;2.06 0];
%-----------------------------------threshold
%phone_F1------------------------------------
[xi,Fsi]=audioread(char(strcat(filePath, files(1), '.wav')));
sams=round(Fsi *0.025); %sample per frame

    seci=length(xi)/Fsi;
    framesi=floor(length(xi)/sams);
    VUS1=zeros(1,framesi);
    for i=1:(length(phone_F1)-1)%findin the start frame and an end one
        l=floor(phone_F1(i,1)/0.025)+1;
        h=ceil(phone_F1((i+1),1)/0.025);
        for j=l:h
            VUS1(j)=phone_F1(i,2);
        end;
    end;
    for j = 1 : framesi
        frame=xi(((j-1)*sams+1) : j*sams);
        zcr=0;%computing ZCR foreach frame
        for k=2:(sams)
            zcr=zcr+abs(sign(frame(k))-sign(frame(k-1)));
        end;
        zcr=zcr/sams;
        if(VUS1(j)~=0) ZCRarr1(j)=zcr;
        else ZCRarr1(j)=0;
        end;
    end;
    %ZCRtemp=max(ZCRarr1);ZCRarr1=ZCRarr1./ZCRtemp;
    %phone_M1------------------------------------
[xi,Fsi]=audioread(char(strcat(filePath, files(2), '.wav')));
sams=round(Fsi *0.025);

    seci=length(xi)/Fsi;
    framesi=floor(length(xi)/sams);
    VUS2=zeros(1,framesi);
    for i=1:(length(phone_M1)-1)%findin the start frame and an end one
        l=floor(phone_M1(i,1)/0.025)+1;
        h=ceil(phone_M1((i+1),1)/0.025);
        for j=l:h
            VUS2(j)=phone_M1(i,2);
        end;
    end;
    for j = 1 : framesi
        frame=xi(((j-1)*sams+1) : j*sams);
        zcr=0;%computing ZCR foreach frame
        for k=2:(sams)
            zcr=zcr+abs(sign(frame(k))-sign(frame(k-1)));
        end;
        zcr=zcr/sams;
        if(VUS2(j)~=0) ZCRarr2(j)=zcr;
        else ZCRarr2(j)=0;
        end;
    end;
    %ZCRtemp=max(ZCRarr2);ZCRarr2=ZCRarr2./ZCRtemp;
    %studio_F1------------------------------------
[xi,Fsi]=audioread(char(strcat(filePath, files(3), '.wav')));
sams=round(Fsi *0.025);

    seci=length(xi)/Fsi;
    framesi=floor(length(xi)/sams);
    VUS3=zeros(1,framesi);
    for i=1:(length(studio_F1)-1)%findin the start frame and an end one
        l=floor(studio_F1(i,1)/0.025)+1;
        h=ceil(studio_F1((i+1),1)/0.025);
        for j=l:h
            VUS3(j)=studio_F1(i,2);
        end;
    end;
    for j = 1 : framesi
        frame=xi(((j-1)*sams+1) : j*sams);
        zcr=0;%computing ZCR foreach frame
        for k=2:(sams)
            zcr=zcr+abs(sign(frame(k))-sign(frame(k-1)));
        end;
        zcr=zcr/sams;
        if(VUS3(j)~=0) ZCRarr3(j)=zcr;
        else ZCRarr3(j)=0;
        end;
    end;
    %ZCRtemp=max(ZCRarr3);ZCRarr3=ZCRarr3./ZCRtemp;
    %studio_M1------------------------------------
[xi,Fsi]=audioread(char(strcat(filePath, files(4), '.wav')));
sams=round(Fsi *0.025);
    seci=length(xi)/Fsi;
    framesi=floor(length(xi)/sams);
    VUS4=zeros(1,framesi);
    for i=1:(length(studio_M1)-1)%findin the start frame and an end one
        l=floor(studio_M1(i,1)/0.025)+1;
        h=ceil(studio_M1((i+1),1)/0.025);
        for j=l:h
            VUS4(j)=studio_M1(i,2);
        end;
    end;
    for j = 1 : framesi
        frame=xi(((j-1)*sams+1) : j*sams);
        zcr=0;%computing ZCR foreach frame
        for k=2:(sams)
            zcr=zcr+abs(sign(frame(k))-sign(frame(k-1)));
        end;
        zcr=zcr/sams;
        if(VUS4(j)~=0) ZCRarr4(j)=zcr;
        else ZCRarr4(j)=0;
        end;
    end;
    %ZCRtemp=max(ZCRarr4);ZCRarr4=ZCRarr4./ZCRtemp;
    %-----------------------------------------------
    ZCRarr=cat(2,ZCRarr1,ZCRarr2); 
    ZCRarr=cat(2,ZCRarr,ZCRarr3);
    ZCRarr=cat(2,ZCRarr,ZCRarr4);
   ZCRtemp=max(ZCRarr);ZCRarr=ZCRarr./ZCRtemp;
 VUSarr=cat(2,VUS1,VUS2); 
 VUSarr=cat(2,VUSarr,VUS3);
 VUSarr=cat(2,VUSarr,VUS4);
 VUS1=[]; VUS2=[]; VUS3=[]; VUS4=[];%delete
 ZCRarr1=[];ZCRarr2=[];ZCRarr3=[];ZCRarr4=[];%delete
 len = length(VUSarr);
 voiced = 0;unvoiced = 0;silence = 0;
 maxVoicedZCR = 0;
  for i =1:len %max zcr of voiced frame
     if (VUSarr(i)==1)
         voiced=voiced +1;
         if(ZCRarr(i)>maxVoicedZCR)
            maxVoicedZCR = ZCRarr(i);
         end;
     end;
 end;
 
     
zcrVoiced = zeros(1,250);
j=0;
for i=1:len
    if VUSarr(i)==1
        j=j+1;
        zcrVoiced(j)=ZCRarr(i);
    end;
end;
check = 0;
threshold=0;
for z=maxVoicedZCR:-0.00001:0
    count = 0;
    for i=1:voiced
        if(zcrVoiced(i)>z)
            count = count + 1;
        end;
    end
    if (count>=voiced*0.01) 
        threshold = z;
        break;
    end
end;
 

 
 