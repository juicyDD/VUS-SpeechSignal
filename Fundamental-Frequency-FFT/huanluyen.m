%if a frame is marked as voiced, it means that the 0.01 interval
%which is locating at the center of that frame is voiced. this marking
%makes no sense for the two bounds.
for imlooping = 1:4
    clearvars -except imlooping;
    
filePath='C:\Users\DELL\Desktop\ThiCK\TinHieuHuanLuyen\';
files = {'01MDA', '02FVA', '03MAB', '06FTB'};

name = char(strcat(filePath, files(imlooping), '.wav'));

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
if (imlooping==1)
    standardVals=s01MDA;
elseif (imlooping==2)
    standardVals=s02FVA;
elseif (imlooping==3)
    standardVals=s03MAB;
elseif (imlooping==4)
    standardVals=s06FTB;
end;
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
        if(ste(i+j)>0.000032441) 
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

continuousFrames = 0; %in an arbitrary region(voiced/silence)
currentType=subVUS(1);
for i=1:(number_of_frames+2)
    if(subVUS(i)==currentType)
        continuousFrames = continuousFrames + 1;
    elseif(subVUS(i)~=currentType)
        currentType=subVUS(i);
        if (continuousFrames<=10)
            %disp(continuousFrames);
            for j=1:(continuousFrames+1)
                subVUS(i-j)=currentType;
            end;
        end;
        continuousFrames=0;
    end;
end;
%---FUNDAMENTAL FREQUENCY(Using  window funcs) (CAU B)
%---FUNDAMENTAL FREQUENCY(Using  window funcs) (CAU B)
%---FUNDAMENTAL FREQUENCY(Using  window funcs) (CAU B)

FundamentalFrequency=[];
stopPointArr=[];
%disp('hello');
for i=1:number_of_frames
    if (subVUS(i+2)==1)
        frame=x(((i-1)*floor(samples_per_frame/3)+1):((i-1)*floor(samples_per_frame/3)+samples_per_frame));
         %foreach 8Hz, there's ONE fft point
        ft = fft(frame.*blackman(samples_per_frame),floor(Fs/8)); %ft is the fourier transform of this frame
        ft =abs(ft);
        [pks,locs]=findpeaks(real(ft));
        stopPoint=linearRegression(pks,locs);
        stopPoint =stopPoint/8;
        stopPointArr=[stopPointArr,stopPoint];
        %disp(stopPoint);
    end

end;
%----------------------------
fundamentalFrequency=[];
f0ofFrame=zeros(1,number_of_frames);
count = 0;
for i=1:number_of_frames
    if(subVUS(i+2)==1)
        
        count = count + 1;
        frame=x(((i-1)*floor(samples_per_frame/3)+1):((i-1)*floor(samples_per_frame/3)+samples_per_frame));
         %foreach 8Hz, there's ONE fft point
        ft = fft(frame.*blackman(samples_per_frame),floor(Fs/8)); %ft is the fourier transform of this frame
        ft =log(abs(ft)+1); 
        %ft =abs(ft);
        ft=ft(1:stopPointArr(count));
        [pks,locs]=findpeaks(real(ft)); %local maximum
        [pks2,locs2]= findpeaks(real(-ft)); %local minimum
        pks2=-pks2;
        %disp(length(pks));
        %disp(length(pks2));
        [maxHeight,idxofMax,maxWidth] = couldReachFromValleys(pks,locs,pks2,locs2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%-----------------------
        %%--------------
        %modify peaks region
        about2del1=[]; %peaks
        about2del2=[]; %valle
        height1=[];
        %finalPeaks=[]; 
        c = 0;
        for j = 1 : length(pks)
            t=0;
            [Height,t] = heightComputing(pks,locs,pks2,locs2,j); %do cao tu 1 peak den local min thap nhat cua no
            dl = 0; dr = 0;
            if (j>1)
                dl=abs(locs(j-1) - locs (j));
            end
            if(j<length(pks))
                dr = abs(locs(j+1)-locs(j));
            end
            t2=0;t3=0;
            if(t>2)
                if (locs2(t)>locs(j))
                    %t2=pks2(t-1);
                    t2=min(pks2(t),pks2(t-1));
                    t3=max(pks2(t),pks2(t-1));
                    
                else
                    %t2=pks2(t+1);
                    t2=min(pks2(t),pks2(t+1));
                    t3=max(pks2(t),pks2(t+1));
                    
                end
                %{
                if(t2<pks2(t))
                    t2=pks2(t);
                    t3=pks2(t);
                end
                %}
            
            end
            %t2:local min be nhat(trong 2 local min ben canh 1 peak)
            %t3:local min lon nhat(trong 2 local min ben canh 1 peak)
            heightt=Height+abs(pks(j)-t2);
            heightt=heightt/2;
            %0.3*maxHeight %||abs(dl-locs(j))<8)||(abs(dr-locs(j))<8)
            %||heightt<0.4*maxHeight %(pks(j)<0.1*max(pks))
            %(Height<0.1*abs(max(pks)-min(pks2))
            %||(heightt<0.2*maxHeight)
            %||(heightt<0.1*maxHeight)||
            %ratio=0.2;
            [maxpks,idx]=max(pks);%tam=0;
            gapbetween2localmin=0;
            if(locs2(j)<locs(j))
                %tam=min(pks2(j),pks2(j+1));
                gapbetween2localmin=abs(locs2(j)-locs2(j+1));
            elseif (locs2(j)>locs(j)) && j~=1
               % tam=min(pks2(j),pks2(j-1));
                gapbetween2localmin=abs(locs2(j)-locs2(j-1));
            else
               % tam=pks2(j);
                gapbetween2localmin = locs2(j);
            end
            
            %(Height<0.05*(max(pks)-tam))||abs(dl-locs(j))<8||(abs(dr-locs(j))<8)||10^pks(j)<0.001* (10^max(pks))||
            %1/6=1/3*1/2
            highestpeaks=sort(pks,'descend');
            if(length(highestpeaks)>=3)
            highestpeaks=highestpeaks(1:3);
            else
                highestpeaks=highestpeaks(1);
            end
            meanofhighest=mean(highestpeaks);
            %&&pks(j)<0.25* (max(pks))
            %&&pks(j)<(1/3)*mean(highestpeaks)
            
            %if (((heightt*gapbetween2localmin <(1/4)*maxHeight*maxWidth)) &&pks(j)<(1/3)*meanofhighest ) ||  Height<0.05*(max(pks)-tam) ||abs(dl-locs(j))<=8||(abs(dr-locs(j))<=8)
            mangtam=pks2;thu=1;
            %[maxpks2,maxlocs2]=max(pks2);mangtam=pks2;mangtam(maxlocs2)=[];
            %[maxpks2,maxlocs2]=max(mangtam);mangtam(maxlocs2)=[];nhi1=0;
            
             if Height<0.001*(meanofhighest)||(((heightt*gapbetween2localmin <(1/20)*maxHeight*maxWidth))&&pks(j)<(0.6)*meanofhighest  )||abs(dl-locs(j))<=8||(abs(dr-locs(j))<=8)||((pks(j)-t2)/(pks(j)-t3)>2.5&&gapbetween2localmin<0.5*maxWidth)%||10^pks(j)<(1/500)*(10^mean(highestpeaks))
                 
                c= c + 1;
                about2del1(c)=j; 
                
                about2del2(c)=t;
                height1(c)=Height;
                j=j+1;
                %{
                 if(i==112)
                    disp(t);
                    disp(Height);
                    disp(j);
                    disp('---');
                end
                %}
                
                
            end
        end %/00:32 120521
        
        len=length(locs);
        pkss=pks;locss=locs;pkss2=pks2;locss2=locs2;
        
        for m=1:len
            
            for n = 1:length(about2del1)
                
                if (m==about2del1(n))
                    
                    if(locs(about2del1(n))<locs2(about2del2(n))) %n+1
                        if(m<len)&&(abs(pks(m+1)-pks2(m))<1.01*height1(n))&&(abs(pks(m+1)-pks2(m))>0.99*height1(n))
                            pkss(m+1)=(pks(m)+pks(m+1))/2;
                            locss(m+1)=(locs(m)+locs(m+1))/2;
                            pkss(m)=0;locss(m)=0;
                            pkss2(m)=0;locss(m)=0;
                            m=m+1;
                            
                            
                        else
                            
                            pkss(m)=0;locss(m)=0;
                            pkss2(m)=0;locss(m)=0;
                            
                            
                            
                        end
                    elseif(locs(m)>locs2(m)) %n-1
                        if((m-1) > 1)
                            if(abs(pks(m-1)-pks2(m))<1.01*height1(n))&&(abs(pks(m-1)-pks2(m))>0.99*height1(n))
                                pkss(m-1)=(pks(m)+pks(m-1))/2;
                                locss(m-1)=(locs(m)+locs(m-1))/2;
                                pkss(m)=0;locss(m)=0;
                                pkss2(m)=0;locss(m)=0;
                                m=m+1;
                            else
                            
                                pkss(m)=0;locss(m)=0;
                                pkss2(m)=0;locss(m)=0;
                                
                                
                            
                            end
                        end
                    end
                    
                end
            end
            
        end
       
        
        %modify peaks end region
        %
        
        GCD=ApproximateGCD(locss);
       %disp(GCD);
        if (GCD~=0)
            FundamentalFrequency = [FundamentalFrequency,GCD]; %store f0 of voiced regions
            f0ofFrame(i)=GCD;%store f0 of not only voiced regions but also silence ones
        end
        
        %{
        if(i==79)&&(imlooping==2)
                    disp(about2del1);
                    disp('---');
                    disp(locs);
                    disp(pkss);
                    disp('---');
                    disp(locss);
                    disp('---');
                    disp(GCD);
                    
        end
        %}
        %disp(maxHeight);
    end;
        
end
%disp(length(FundamentalFrequency));
%----------PLOTTING
%----------PLOTTING
%----------PLOTTING
%figure 1: results from my own voiced/silence detections
%figure;
%subplot(5,1,1);
%plot(x(1:(number_of_frames+2)*floor(samples_per_frame/3)));
%xlim([0 length(x)]);

oneInterval=length(x)/(number_of_frames+2);

%title('Voiced/Silence regions');
%xlabel('Time axis');
%ylabel('Amplitude');
currentRegion = subVUS(1);
for i=1:length(subVUS)
    if(i==1)||(subVUS(i)~=currentRegion)
        if(subVUS(i)==1)
            %line([oneInterval*(i-1) oneInterval*(i-1)],[-1 1],'Color',[.8 .0 .0]);
           % text(oneInterval*(i-1), 0.8, sprintf('V'));
            %text(oneInterval*(i-1), 0.5, sprintf('%0.2f',i*0.01));
        elseif(subVUS(i)==0)
          %  line([oneInterval*(i-1) oneInterval*(i-1)],[-1 1],'Color',[.0 .8 .0]);
          %  text(oneInterval*(i-1), 0.8, sprintf('Si'));
          %  text(oneInterval*(i-1), 0.5, sprintf('%0.2f',i*0.01));
        end;
        currentRegion=subVUS(i);
    end;
end;
%figure 2: results from *.lab 
%subplot(5,1,2);
%plot(x(1:(number_of_frames+2)*floor(samples_per_frame/3)));
%xlim([0 length(x)]);
%title('Voiced/Silence regions(*.lab results)');
%xlabel('Time axis');
%ylabel('Amplitude');
len = length(standardVals);
for i=1:len
    x=(standardVals(i,1)/0.01)*(samples_per_frame/3);
    if(standardVals(i,2)==1)
        %{
        line([x x],[-1 1],'Color',[.8 .0 .0]);
        text(x, 0.8, sprintf('V'));
        text(x, 0.5, sprintf('%0.2f',standardVals(i,1)));
    elseif(standardVals(i,2)==0)
        line([x x],[-1 1],'Color',[.0 .8 .0]);
        text(x, 0.8, sprintf('Sil'));
        text(x, 0.5, sprintf('%0.2f',standardVals(i,1)));
        %}
    end;
end;
%figure 3: plotting FFT(Fast Fourier Transform)
%subplot(5,1,3);
[x,Fs]=audioread(name);
i=81; %80
if(imlooping==4)
    i=116;
elseif (imlooping==3)
    i=137;
elseif (imlooping==2)
    i=179;%77
end
frame=x(((i-1)*floor(samples_per_frame/3)+1):((i-1)*floor(samples_per_frame/3)+samples_per_frame));
%ft = fft(frame,floor(Fs/1));
ft = fft(frame.*blackman(samples_per_frame),floor(Fs/8));

ft = log(abs(ft)+1);
%ft = abs(ft);
%plot(1:8:floor(Fs/8)*8,ft(1:floor(Fs/8)));
%ft=fftshift(ft);
%
%plot(1:8:floor(Fs/8)*8,ft(1:floor(Fs/8)));
%xlabel('Frequency (Hz)'); ylabel('Amplitude');
%plot(-floor(floor(Fs/8)*8/2):8:floor(floor(Fs/8)*8/2)-1,ft(1:floor(Fs/8)));
%%%%%%%%%%%
w=blackman(floor(length(ft)/8));

for i=1:300
    ft2(301-i)=ft(i);
end;
ft2=ft(1:1000); 
ftw=ft(1:length(w));%.*w(1:length(w));
pks=[];locs=[];
[pks,locs]=findpeaks(real(ft2));
[pks2,locs2]= findpeaks(real(-ft2));
%subplot(5,1,4);
locs = locs.*8-8;
locs2= locs2.*8-8;
pks2=-pks2;
%plot(1:8:length(ft2)*8,ft2,locs,pks,'pg',locs2,pks2,'ro');
%title('Local minimum vs. Local maximum');
%xlabel('Frequency(Hz)');ylabel('Amplitude');
%{
for dem=2:length(FundamentalFrequency)-1
            if(FundamentalFrequency(dem)>mean(nonzeros(FundamentalFrequency))*2)
                %FundamentalFrequency(dem)=0;
                FundamentalFrequency(dem)=min(FundamentalFrequency(dem-1),FundamentalFrequency(dem+1));
            elseif(FundamentalFrequency(dem)<mean(nonzeros(FundamentalFrequency))*(0.5))
                %FundamentalFrequency(dem)=0;
                FundamentalFrequency(dem)=max(FundamentalFrequency(dem-1),FundamentalFrequency(dem+1));
            end;
end
%}
for dem=2:length(f0ofFrame)-1
    if(f0ofFrame(dem)>mean(nonzeros(f0ofFrame))*1.5&&f0ofFrame(dem)~=0)||(f0ofFrame(dem)>450)
        %f0ofFrame(dem)=0;
        %f0ofFrame(dem)=min(f0ofFrame(dem-1),f0ofFrame(dem+1));
        f0ofFrame(dem)=mean(nonzeros(f0ofFrame));
    elseif(f0ofFrame(dem)<mean(nonzeros(f0ofFrame))*0.5&&f0ofFrame(dem)~=0)
        %f0ofFrame(dem)=0;
        %f0ofFrame(dem)=max(f0ofFrame(dem-1),f0ofFrame(dem+1));
        f0ofFrame(dem)=mean(nonzeros(f0ofFrame));
    end
end


f0ofFrame2=f0ofFrame;

for dem = 1:length(f0ofFrame)
   % if(f0ofFrame2(dem)~=0)
        count=0;
        if(f0ofFrame2(dem)~=0)
            count=1;
        end;
        if(dem-2)>0&&(dem+2)<length(f0ofFrame)
            if(f0ofFrame(dem-2)~=0)
                count = count + 1;
                f0ofFrame2(dem)=f0ofFrame2(dem)+f0ofFrame(dem-2);
            end
            if(f0ofFrame(dem-1)~=0)
                count = count + 1;
                f0ofFrame2(dem)=f0ofFrame2(dem)+f0ofFrame(dem-1);
            end
            if(f0ofFrame(dem+1)~=0)
                count = count + 1;
                f0ofFrame2(dem)=f0ofFrame2(dem)+f0ofFrame(dem+1);
            end
            if(f0ofFrame(dem+2)~=0)
                count = count + 1;
                f0ofFrame2(dem)=f0ofFrame2(dem)+f0ofFrame(dem+2);
            end
        end
        if(count~=0)
        f0ofFrame2(dem)=f0ofFrame2(dem)/count;
        end
  
   % end
    
end


%FundamentalFrequency=nonzeros(FundamentalFrequency);
FundamentalFrequency=nonzeros(f0ofFrame2);
%stdmean=StandardDeviation(FundamentalFrequency);
stdmean=StandardDeviation(FundamentalFrequency);
disp(files(imlooping));
disp('f0 mean:');

f0mean=nanmean(FundamentalFrequency);
disp(f0mean);
disp('std mean:');
disp(stdmean);
disp('-----------');
%plot(1:8:floor(length(ftw)/2)*8,ftw(1:floor(length(ftw)/2)));
%plot(w);
%plot(1:10:floor(Fs/1/15)*10,ft(1:floor(Fs/1/15)));
%subplot(5,1,5);

%plot(f0ofFrame2,'.');
%xlim([0,length(f0ofFrame2)]);
%xlabel('frame(n)');
%ylabel('frequency(Hz)');
f0meanstr =num2str(f0mean);
%titlearr=['F0 mean:'+f0mean];

%title({['Fundamental Frequency (mean):',f0meanstr,' | Standard Deviation (mean):',num2str(stdmean)]});
%idkwtd tbh

end;