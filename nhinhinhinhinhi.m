
for imlooping =1:4
   % clear x frames;
   clearvars -except imlooping;
clc;
%filePath='D:\NhiEbook\XL tin hieu\BT nhom\TinHieuHuanLuyen\';
%files = {'phone_F1', 'phone_M1', 'studio_F1', 'studio_M1'};
filePath='D:\NhiEbook\XL tin hieu\TinHieuKiemThu\';
files = {'phone_F2', 'phone_M2', 'studio_F2', 'studio_M2'};
name = char(strcat(filePath, files(imlooping), '.wav'));
%0: Silence;1: Voiced; 2: Unvoiced;
phone_F1=[0 0;0.53 1;1.14 2; 1.21 1;1.35 2;1.45 1;1.6 2;1.83 1;2.2 2; 2.28 1;2.35 2;2.4 1;2.52 2;2.66 1;2.73 0];
phone_M1=[0 0;0.46 1;1.39 2;1.5 1;1.69 2;1.79 1;2.78 2;2.86 1;2.93 2;3.1 1;3.29 2;3.45 1;3.52 0];
studio_F1=[0 0;0.68 2;0.7 1;1.1 2; 1.13 1;1.22 2;1.27 1;1.65 2;1.7 1;1.76 2;1.79 1;1.86 2;1.92 1;2.15 0];
studio_M1=[0 0;0.87 2;0.94 1;1.26 2;1.33 1;1.59 2;1.66 1;1.78 2;1.82 1;2.06 0];
phone_F2 =[0 0;1.02 1;1.88 2;1.95 1; 2.16 2;2.25 1;2.6 2; 2.75 1;3.34 2;3.38 1;3.45 2;3.62 1;3.8 2;3.91 1;4 2;4.04 0];
phone_M2 = [0 0;0.53 1;1.05 2;1.12 1;1.24 2;1.31 1;1.46 2;1.68 1;1.97 2;2.06 1;2.12 2;2.17 1;2.3 2;2.43 1;2.5 2;2.52 0];
studio_F2 =[0 0;0.77 1;1.25 2;1.27 1;1.35 2;1.41 1;1.76 2;1.83 1;1.98 2;2.06 1;2.37 0];
studio_M2 =[0 0;0.45 2;0.48 1;0.77 2;0.79 1;0.88 2;0.92 1;1.32 2;1.37 1; 1.53 2;1.59 1;1.93 0];

%TH kiem thu


if (imlooping==1)
    standardVals=phone_F2;
elseif (imlooping==2)
    standardVals=phone_M2;
elseif (imlooping==3)
    standardVals=studio_F2;
elseif (imlooping==4)
    standardVals=studio_M2;
end;

[x,Fs]=audioread(name);


%--------------------------------------


%0.025sec per frame

samples_per_frame = round(Fs * 0.025);
sec=length(x)/Fs;
number_of_frames = floor(length(x)/samples_per_frame);
A=[0 0];
%1 framing -------------------------
max1=0;

for i= 1:number_of_frames
    frames(i,:)=x((i-1)*samples_per_frame+1 : i*samples_per_frame);
    if(max1<mean(abs(x((i-1)*samples_per_frame+1 : i*samples_per_frame))))
        max1=mean(abs(x((i-1)*samples_per_frame+1 : i*samples_per_frame)));
    end;
end;

count = 0;
temp = number_of_frames;
%----------------------------------------------
%I. SPEECH VS SILENCE -----------------------------

%x=reshape(frames',[],1);
for i=1:number_of_frames
    
    frame=x((i-1)*samples_per_frame+1 : i*samples_per_frame);
    ave=mean(abs(frame))/max1; %computing average magnitude of 1 sample of 1 frame, then normalizing
   
    %ave=sum(abs(x((i-1)*samples_per_frame+1 : i*samples_per_frame)))/(samples_per_frame*max);
    maxmag=max(abs(frame))/max(abs(x));
    
    if (ave<=0.04)|(maxmag<0.04) %mark as silence
        
    %if (maxmag<0.05)|(ave<0.05)
        count=count+1;
    end;
    if((ave>0.04)&&(maxmag>0.04))|(i==number_of_frames)
    %else
        if(count>=12) %check if theres a 300ms silence region(=12frames) right b4
            A=[A; (i-count+1) i];
            count = 0;
            
        end;
        count = 0;
        if(i==temp) break;
        end;
    end;
end;

%---------------------------------------------------------------------
%-----VOICED/UNVOICED------------------------------------------------
%ZCR computing
ZCRarr=zeros(1,number_of_frames);
A=[A;number_of_frames number_of_frames];
VUframes=zeros(1,number_of_frames);%0 is silence i've detected it already,
%20 stands for voiced 2 means unvoiced take it for granted :"> idkw
for i=2:(length(A)-1)
    %for j = (A((i),2)+1) : A((i+1),1) %loop speech region
    for j = (A((i),2)+1) : A((i+1),1)
        frame=x(((j-1)*samples_per_frame+1) : j*samples_per_frame);
        zcr=0;%computing ZCR foreach frame
        for k=2:(samples_per_frame)
            zcr=zcr+abs(sign(frame(k))-sign(frame(k-1)));
        end;
        zcr=zcr/samples_per_frame;
        ZCRarr(j)=zcr;
    end;
end;
ZCRmax=max(ZCRarr);
%STE computing
stetemp=0; ste=zeros(1,number_of_frames);
for i=1:number_of_frames
        frame=x(((i-1)*samples_per_frame+1):(i*samples_per_frame));
        steButDividedBySams=sum(abs(frame.*frame))/samples_per_frame;
        ste(i)=steButDividedBySams;
    end;
stetemp=max(ste);ste=ste./stetemp;
%%hhhh
for i=2:(length(A)-1)
    for j = (A((i),2)+1) : A((i+1),1) %loop speech region
        frame=x(((j-1)*samples_per_frame+1) : j*samples_per_frame);
       %steDividedBySams=sum(abs(frame.*frame))/(samples_per_frame*max(x));%normalize
        %disp(steDividedBySams);
        
        %frequency of hooman voice varies from 60-450Hz
        %which is equivalent to T=0.0167s -> 0.00222s
        %account for 8.89% - 66.8% of the length of ONE frame (0.025 sec)
        %lets say that this one varies from 7% - 70% frame's length
        %
        
        for shift=(floor(samples_per_frame*0.07)):(ceil(samples_per_frame*0.70))%1:(samples_per_frame-1) 
            zeroShiftACF=0;
            for bono=1:(samples_per_frame-shift)
                zeroShiftACF=zeroShiftACF+frame(bono)*frame(bono);
            end;
            acf=0;
            for idx=1:(samples_per_frame-shift)
                acf=acf+frame(idx)*frame(idx+shift);
            end;
            
            if((acf/zeroShiftACF)>=0.8)||(ste(j)>0.0283)
                if (ZCRarr(j)<=(ZCRmax)*0.38)
                    
                VUframes(j)=20;
                break;
               end;
                
                %break;
            end;
        end;
       if(VUframes(j)==0)VUframes(j)=2;
    end;
       end;
       
end;


%-------------------------------------------PLOTTING---------------------
xx=reshape(frames',[],1);
figure;
subplot(4,1,1);


plot(xx);
xlim([0 length(x)]);
title('Voiced/Unvoiced regions');
xlabel('Time axis');
ylabel('Amplitude');
%%%%
i=0;
while(true)%%if 2 silence region is not that far a way, take it as 1 one
    i=i+1;
    if(i+1<=length(A))
        if(A(i+1,1)-A(i,2)<=2)
        A(i,2)=A(i+1,2);
        A(i+1,:)=[];
        end;
    else break;
    end;
end;
for k=1:length(A)
   for l=1:2
       temporary = A(k,l)*samples_per_frame-samples_per_frame;
       if (temporary<0)
           temporary=temporary+samples_per_frame;
       end;
       if(mod(l,2)==1)
           line([temporary temporary],[-1 1],'Color',[.0 .0 .8]);
           if(A(k,l)~=number_of_frames)text(temporary,0.5,'Si');
       end;
       end;
   end;  
end;
sec=sec/length(x)*length(xx);
%%%%%%%%%%%%%%%%%%%%%%%%%%%% modify the VUframes array(which is storing
%%% voiced and unvoiced region. for instance, an unvoiced frame happens to 
%%% emerge from a large range of voiced ones(vvvvvvvvUVvvvvvvv), idk but
%%% it has to be voiced, it sure is
for k=2:(number_of_frames-1)
    if((VUframes(k)~=0)&&(VUframes(k-1)~=0))
        if(VUframes(k-1)==VUframes(k+1))&&(VUframes(k)~=VUframes(k-1))
            VUframes(k)=VUframes(k-1);
        end;
    end;
end;
    %%%%%%%%%%%%%%%%%%%%%%%%%%
for k=2:number_of_frames
    if(VUframes(k)~=0)&&(VUframes(k)~=VUframes(k-1))
        temporary= (k-1)*samples_per_frame;
        
        sec1=(k-1)*samples_per_frame/length(xx) * sec;
        if(VUframes(k)==20)
            line([temporary temporary],[-1 1],'Color',[.8 .0 .0]);
            %text(temporary,0.8,'V');
            text(temporary, 0.8, sprintf('V'));
            text(temporary, 0.5, sprintf('%0.2f',sec1));
        elseif(VUframes(k)==2)
            line([temporary temporary],[-1 1],'Color',[.0 .8 .0]);
            text(temporary,0.95,'UV');
            text(temporary, 0.65, sprintf('%0.2f',sec1));
        end;
    end;
end;
subplot(4,1,2);
plot(x);
title('Voiced/Unvoiced regions (*.lab results)');
xlim([0 length(x)]);
xlabel('Time axis');
ylabel('Amplitude');

len=length(standardVals);


for i=1:len
    temporary=standardVals(i,1)*samples_per_frame/0.025;
    if(standardVals(i,2)==0)
        line([temporary temporary],[-1 1],'Color',[.0 .0 .8]);
    end;
    if(standardVals(i,2)==1)
        line([temporary temporary],[-1 1],'Color',[.8 .0 .0]);
    end;
    if(standardVals(i,2)==2)
        line([temporary temporary],[-1 1],'Color',[.0 .8 .0]);
    end;
end;

%max1=max1/samples_per_frame;
subplot(4,1,3);

plot(ZCRarr);
xlim([0 number_of_frames]);
title('Zero-crossing rate (ZCR)');
xlabel('Time axis');
ylabel('ZCR');

subplot(4,1,4);
plot(ste);
xlim([0 number_of_frames]);
title('Short-time energy (STE)');
xlabel('Time axis');
ylabel('STE');
end;
