[VA,VE,VI,VO,VU]=VowelFFT();
failedDetections=0;
for imlooping = 1:21
    clearvars -except imlooping VA VE VI VO VU failedDetections;
    
filePath='C:\Users\DELL\Desktop\NguyenAmKiemThu-16k\';
files = {'23MTL','24FTL','25MLM','27MCM','28MVN','29MHN','30FTN','32MTP','33MHP','34MQP','35MMQ','36MAQ','37MDS','38MDS','39MTS','40MHS','41MVS','42FQT','43MNT','44MTT','45MDV'};

%figure;
for imlooping2 = 1:5
    %disp (imlooping2);
    str='';
    switch imlooping2
        case 1
            str='\a.wav';
        case 2 
            str='\e.wav';
        case 3
            str='\i.wav';
        case 4 
            str = '\o.wav';
        case 5
            str ='\u.wav';
    end
name = char(strcat(filePath, files(imlooping), str));
displayname=char(strcat('Vowel detection: ',files(imlooping),str));
disp(displayname);
s30FTN=[0 0;0.59 1;0.97 0; 1.76 1; 2.11 0;3.44 1;3.77 0; 4.7 1; 5.13 0;5.96 1; 6.28 0];
s42FQT=[0 0;0.46 1;0.99 0; 1.56 1;2.13 0; 2.51 1;2.93 0; 3.79 1;4.38 0;4.77 1;5.22 0];
s44MTT=[0 0;0.93 1;1.42 0;2.59 1;3 0;4.71 1;5.11 0;6.26 1;6.66 0; 8.04 1;8.39 0];
s45MDV=[0 0;0.88 1;1.34 0;2.35 1;2.82 0;3.76 1;4.13 0;5.04 1;5.5 0;6.41 1;6.79 0];
s01MDA=[0 0;0.45 1;0.81 0;1.53 1;1.85 0;2.69 1;2.86 0;3.78 1;4.15 0;4.84 1;5.14 0];
s02FVA=[0 0; 0.83 1;1.37 0;2.09 1;2.6 0;3.57 1;4 0;4.76 1;5.33 0;6.18 1;6.68 0];
s03MAB=[0 0;1.03 1;1.42 0;2.46 1;2.8 0;4.21 1;4.52 0;6.81 1;7.14 0;8.22 1;8.5 0];
s06FTB=[0 0; 1.52 1;1.92 0;3.91 1;4.35 0;6.18 1;6.6 0;8.67 1;9.14 0;10.94 1;11.33 0];
%
%

%---------voiced/silence frames detection (Cau A)
%---------voiced/silence frames detection (Cau A)
%---------voiced/silence frames detection (Cau A)
[x,Fs]=audioread(name);
samples_per_frame = round(Fs * 0.03);
sec=length(x)/Fs; %length of record
number_of_frames = floor(length(x)/(samples_per_frame/3))-2;%foreach 0.01s, a new frame starts
%STE
stetemp=0; ste=zeros(1,number_of_frames);
for i=1:(number_of_frames)
        frame=x(((i-1)*floor(samples_per_frame/3)+1):((i-1)*floor(samples_per_frame/3)+samples_per_frame));
        steButDividedBySams=sum(abs(frame.*frame))/samples_per_frame;
        ste(i)=steButDividedBySams;
end;
subVUS=zeros(1,(number_of_frames+2)); %label voiced unvoiced foreach 0.01s interval
for i=2:(number_of_frames-1)
    count = 0;
    for j=-1:1:1
        if(ste(i+j)>0.0001) 
            count = count + 1;
        end;
    end;
    if (count>=2)
        subVUS(i)=1;
    else
        subVUS(i)=0;
    end;
        
end;
subVUS(1)=subVUS(2);
subVUS(number_of_frames)=subVUS(number_of_frames-1);
%{
continuousFrames = 0; %in an arbitrary region(voiced/silence)
currentType=subVUS(1);
for i=1:(number_of_frames+2)
    if(subVUS(i)==currentType)
        continuousFrames = continuousFrames + 1;
    elseif(subVUS(i)~=currentType)
        currentType=subVUS(i);
        if (continuousFrames<=15)
            %disp(continuousFrames);
            for j=1:(continuousFrames+1)
                
                subVUS(i-j)=currentType;
            end;
        end;
        continuousFrames=0;
    end;
end;
%}
%------SPECTROGRAM
%------SPECTROGRAM
%------SPECTROGRAM
subVUS2=subVUS;
num_voiced_frames = length(nonzeros(subVUS));
onethird = floor(num_voiced_frames/3);
temp = onethird;
while temp > 0
    for i=1:number_of_frames
        if (subVUS2(i+2)==1)
            subVUS2(i+2)=0;
            temp = temp - 1;
            break;
        end
    end
end
temp = onethird;
while temp > 0
    for i=number_of_frames:-1:1
        if (subVUS2(i+2)==1)
            subVUS2(i+2)=0;
            temp = temp - 1;
            break;
        end
    end
end

number_voiced=length(nonzeros(subVUS2));
for m=1:length(subVUS2)
    if(subVUS2(m)==1)
        startP=m;
        break;
    end
end
startP=m*Fs*0.01;
sams=number_voiced*Fs*0.01+0.02*Fs;
mysignal=x(startP:startP+sams);
c= [];
mysigfrs=(length(mysignal)-0.02*Fs)/(0.01*Fs);

for i=1:floor(mysigfrs)
    
        frame=mysignal(((i-1)*floor(samples_per_frame/3)+1):((i-1)*floor(samples_per_frame/3)+samples_per_frame));
         %foreach 8Hz, there's ONE fft point
        ft=[];
        
        ft = fft(frame.*hamming(samples_per_frame),512);
        ft=ft(1:floor(length(ft)/2));
        ft=real(ft);
        ft=abs(ft)+1;
        ft = log(ft);
        ft=ft/max(ft);
        c=[c,ft];
    
end

%c=mean(c);
%c=real(c);
c=c';
c=mean(c);
%c=c(1:floor(length(c)/2));
%c=c';
%[c,tc]=v_melcepst(mysignal,Fs,'M',26, floor(3*log(Fs)),floor(0.03*Fs),floor(0.03*Fs/2),0,0.5);
%c=mean(c);

[dA,n]=EuclideanDistance(c,VA);
[dE,n]=EuclideanDistance(c,VE);
[dI,n]=EuclideanDistance(c,VI);
[dO,n]=EuclideanDistance(c,VO);
[dU,n]=EuclideanDistance(c,VU);
D2=[dA,dE,dI,dO,dU];
[D,n]=min(D2);
switch n
    case 1
        disp('A');
    case 2
        disp('E');
    case 3
        disp('I');
    case 4
        disp('O');
    case 5
        disp('U');
end
if imlooping2~=n
    failedDetections =failedDetections + 1;
end
%disp( length (VA(:,1)) );

end
end

disp('Failed dectections:');
disp(failedDetections);
