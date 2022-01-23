function [VA,VE,VI,VO,VU]=VowelFFT()
   A=[];E=[];I=[];O=[];U=[];
for imlooping = 1:21
    clearvars -except imlooping A E I O U;
    
filePath='C:\Users\DELL\Desktop\NguyenAmHuanLuyen-16k\';
files = {'07FTC','08MLD', '09MPD', '10MSD', '11MVD','12FTD','14FHH','06FTB','05MVB','04MHB','03MAB','02FVA','01MDA','15MMH','16FTH','17MTH','18MNK','19MXK','20MVK','21MTL','22MHL'};

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
mysignal=x(startP:startP+sams); c= [];

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
%c=real(c);
c=c';
c=mean(c);
%c=c(1:floor(length(c)/2));
c=c';
%[c,tc]=v_melcepst(mysignal,Fs,'M',26, floor(3*log(Fs)),floor(0.03*Fs),floor(0.03*Fs/2),0,0.5);
%c=mean(c);
switch imlooping2
    case 1
        A=[A,c];
    case 2
        E=[E,c];
    case 3
        I=[I,c];
    case 4
        O=[O,c];
    case 5
        U=[U,c];
end
%disp('hello');
%{
for i=number_of_frames:-1:1
    if (subVUS(i+2)==1)
        frame=x(((i-1)*floor(samples_per_frame/3)+1):((i-1)*floor(samples_per_frame/3)+samples_per_frame));
         %foreach 8Hz, there's ONE fft point
        ft=[];
        
        ft = fft(frame.*hamming(samples_per_frame),floor(Fs/10));
        
        ft=abs(ft)+1;
        ft = log(ft);
        %ft=ft.^2;
        ft0=ft;
        ft = ifft(ft,floor(Fs/10));
        
       
    end

end;
%}

%----------------------------
%fundamentalFrequency=[];
%f0ofFrame=zeros(1,number_of_frames);
%count = 0;

%disp(length(FundamentalFrequency));
%----------PLOTTING
%----------PLOTTING
%----------PLOTTING
%{
subplot(5,1,imlooping2);
plot(x(1:(number_of_frames+2)*floor(samples_per_frame/3)));
xlim([0 length(x)]);

oneInterval=length(x)/(number_of_frames+2);

title('Voiced/Silence regions');
xlabel('Time axis');
ylabel('Amplitude');
currentRegion = subVUS(1);
for i=1:length(subVUS)
    if(i==1)||(subVUS(i)~=currentRegion)
        if(subVUS(i)==1)
            line([oneInterval*(i-1) oneInterval*(i-1)],[-1 1],'Color',[.8 .0 .0]);
            text(oneInterval*(i-1), 0.8, sprintf('V'));
            text(oneInterval*(i-1), 0.5, sprintf('%0.2f',i*0.01));
        elseif(subVUS(i)==0)
            line([oneInterval*(i-1) oneInterval*(i-1)],[-1 1],'Color',[.0 .8 .0]);
            text(oneInterval*(i-1), 0.8, sprintf('Si'));
            text(oneInterval*(i-1), 0.5, sprintf('%0.2f',i*0.01));
        end;
        currentRegion=subVUS(i);
    end;
end;

%spectrogram(x,0.03*Fs,0.02*Fs,1024,floor(Fs/8),'yaxis');
%figure 1: results from my own voiced/silence detections
%figure;
%plot(x);
%}
end;
end;
 A=A';E=E';I=I';O=O';U=U';

for o = 1: 5
    Err=[];
    vectors=[];
    switch o
        case 1
            Title='Distortion(A)';
            vectors=A;
        case 2
            Title='Distortion(E)';
            vectors=E;
        case 3
            Title='Distortion(I)';
            vectors=I;
        case 4
            Title='Distortion(O)';
            vectors =O;
        case 5
            Title='Distortion(U)';
            vectors = U;
    end
    for l=1:length(vectors)
    
    %{
    [X,G,J,GG]=v_kmeans(vectors,l);
    Err=[Err,G];
    
    end
    figure;
    plot(Err);
    xlim([0 20]);
    title(Title);
        %}
end
% A :5,E:7, I:5,O:4, U:5 

[VA,G,J,GG]=v_kmeans(A,8);
[VE,G,J,GG]=v_kmeans(E,8);
[VI,G,J,GG]=v_kmeans(I,8);
[VO,G,J,GG]=v_kmeans(O,8);
[VU,G,J,GG]=v_kmeans(U,8);

%------------------------------
%---------------------------------
%-----------------KIEMTHU-------------
%-----------------KIEMTHU----------------
%-----------------KIEMTHU-------------
%---------------------------------
end

