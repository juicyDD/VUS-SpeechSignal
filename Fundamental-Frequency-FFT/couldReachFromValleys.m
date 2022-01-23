function [maxHeight,idxofMax,maxWidth] = couldReachFromValleys(pks,locs,pks2,locs2)
    %pks is peaks arr, pks2 is valleys arr
    maxHeight = 0; temp = 0;idxofMax=0;maxWidth=0;
    for i = 1:length(pks)
        temp = 0;
        if(i==1)
            if(locs(i)<locs2(i))
                temp = temp + abs(pks(i)-pks2(i));
            elseif(locs(i)>locs2(i))
                temp = temp +  abs(pks(i)-pks2(i))+ abs(pks(i)-pks2(i+1));
                temp = temp / 2;
            end
        elseif(i==length(pks))
            if(length(pks2)<length(pks))
                temp = temp + abs(pks(i)-pks2(i-1));
            elseif(length(pks2)==length(pks))
                if(locs2(i)>locs(i))
                    temp = temp +abs(pks(i)-pks2(i))+abs(pks(i)-pks2(i-1));
                    temp = temp /2;
                elseif(locs2(i)<locs(i))
                    temp = temp +abs(pks(i)-pks2(i));
                end
            elseif(length(pks2)>length(pks))
                temp = temp +abs(pks(i)-pks2(i))+abs(pks(i)-pks2(i+1));
                temp = temp/2;
            end
                
        else
            if(locs(i)>locs2(i))
                temp = temp +abs(pks(i)-pks2(i))+abs(pks(i)-pks2(i+1));
                temp = temp/2;
            elseif(locs(i)<locs2(i))
                temp = temp +abs(pks(i)-pks2(i))+abs(pks(i)-pks2(i-1));
                temp = temp/2;
            end;
        end
        if (temp > maxHeight)
            maxHeight = temp;
            idxofMax=i;
            %
            
            if(locs2(idxofMax)<locs(idxofMax))
                tam=min(pks2(idxofMax),pks2(idxofMax+1));
                maxWidth=abs(locs2(idxofMax)-locs2(idxofMax+1));
            elseif (locs2(idxofMax)>locs(idxofMax)) && idxofMax~=1
                tam=min(pks2(idxofMax),pks2(idxofMax-1));
                maxWidth=abs(locs2(idxofMax)-locs2(idxofMax-1));
            else
                tam=pks2(idxofMax);
                maxWidth = locs2(idxofMax)-0;
            end
            %
        end
    end
end
