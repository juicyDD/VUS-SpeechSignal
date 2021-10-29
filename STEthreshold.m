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
    sams=round(Fsi *0.025);
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
    ste1=zeros(1,framesi);
    for i=1:framesi
        frame=xi(((i-1)*sams+1):(i*sams));
        steButDividedBySams=sum(abs(frame.*frame))/sams;
        ste1(i)=steButDividedBySams;
    end;
    stetemp=max(ste1);ste1=ste1./stetemp;
%phone_M1----------------------------
[xi,Fsi]=audioread(char(strcat(filePath, files(2), '.wav')));
    sams=round(Fsi *0.025);
    seci=length(xi)/Fsi;
    framesi=floor(length(xi)/sams);
    VUS2=zeros(1,framesi);
    for i=1:(length(phone_M1)-1)
        l=floor(phone_M1(i,1)/0.025)+1;
        h=ceil(phone_M1((i+1),1)/0.025);
        for j=l:h
            VUS2(j)=phone_M1(i,2);
        end;
    end;
    ste2=zeros(1,framesi);
    for i=1:framesi
        frame=xi(((i-1)*sams+1):(i*sams));
        steButDividedBySams=sum(abs(frame.*frame))/sams;
        ste2(i)=steButDividedBySams;
    end;
    stetemp=max(ste2);ste2=ste2./stetemp;
%studio_F1-----------------------------------

[xi,Fsi]=audioread(char(strcat(filePath, files(3), '.wav')));
    sams=round(Fsi *0.025);
    seci=length(xi)/Fsi;
    framesi=floor(length(xi)/sams);
    VUS3=zeros(1,framesi);
    for i=1:(length(studio_F1)-1)
        l=floor(studio_F1(i,1)/0.025)+1;
        h=ceil(studio_F1((i+1),1)/0.025);
        for j=l:h
            VUS3(j)=studio_F1(i,2);
        end;
    end;
    ste3=zeros(1,framesi);
    for i=1:framesi
        frame=xi(((i-1)*sams+1):(i*sams));
        steButDividedBySams=sum(abs(frame.*frame))/sams;
        ste3(i)=steButDividedBySams;
    end;
    stetemp=max(ste3);ste3=ste3./stetemp;
%studio_M1-----------------------------
[xi,Fsi]=audioread(char(strcat(filePath, files(4), '.wav')));
    sams=round(Fsi *0.025);
    seci=length(xi)/Fsi;
    framesi=floor(length(xi)/sams);
    VUS4=zeros(1,framesi);
    for i=1:(length(studio_M1)-1)
        l=floor(studio_M1(i,1)/0.025)+1;
        h=ceil(studio_M1((i+1),1)/0.025);
        for j=l:h
            VUS4(j)=studio_M1(i,2);
        end;
    end;
    ste4=zeros(1,framesi);
    for i=1:framesi
        frame=xi(((i-1)*sams+1):(i*sams));
        steButDividedBySams=sum(abs(frame.*frame))/sams;
        ste4(i)=steButDividedBySams;
    end;
    stetemp=max(ste4);ste4=ste4./stetemp;
 %-------------------------------------
 VUSarr=cat(2,VUS1,VUS2); 
 VUSarr=cat(2,VUSarr,VUS3);
 VUSarr=cat(2,VUSarr,VUS4);
 ste=cat(2,ste1,ste2);
 ste=cat(2,ste,ste3);
 ste=cat(2,ste,ste4);
 VUS1=[]; VUS2=[]; VUS3=[]; VUS4=[];%delete
 ste1=[];ste2=[];ste3=[];ste4=[];%delete
 len=length(VUSarr);
 voiced=0;unvoiced =0;silence=0;
 for i =1:len
     if (VUSarr(i)==1) voiced= voiced +1;
     elseif(VUSarr(i)==2) unvoiced = unvoiced +1;
     else silence=silence+1;
     end;
 end;
 sumstev=0;
 sumsteuv=0;
 %%average ste(divided by number of samples) voiced--------------------
 for i=1:len
     if(VUSarr(i)==1) sumstev=sumstev+ste(i);
     end;
 end;
 avgstev=0;
 avgstev=sumstev/voiced;
 %%----avarage ste unvoiced----------------------------
 sumsteuv=0;
 avgsteuv=0;
  for i=1:len
     if(VUSarr(i)==2) sumsteuv=sumsteuv+ste(i);
     end;
 end;
 avgsteuv=0;
 avgsteuv=sumsteuv/voiced;
 %%standard deviation(voiced)----------------
 s=0;
 for i=1:len
     if(VUSarr(i)==1)
         s=s+((ste(i)-avgstev).^2);
     end;
 end;
s=sqrt(s.*(1/(voiced-1)));
epsilon=1.96*s/sqrt(voiced);%sai so,do tin cay 95% a tr
steRangeVoiced=[avgstev-epsilon,avgstev+epsilon]; %khoang tin cay ste Voiced
%%standard deviation(unvoice)
s=0;
 for i=1:len
     if(VUSarr(i)==2)
         s=s+((ste(i)-avgsteuv).^2);
     end;
 end;
s=sqrt(s.*(1/(unvoiced-1)));
epsilon=1.96*s/sqrt(voiced);%sai so,do tin cay 95% a tr
steRangeUnvoiced=[avgsteuv-epsilon,avgsteuv+epsilon]; %khoang tin cay ste Unvoiced