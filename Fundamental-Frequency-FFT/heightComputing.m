function [Height,t] = heightComputing(pks,locs,pks2,locs2,i)
    %pks is peaks arr, pks2 is valleys arr
    
   
        Height = 0;
        t = 0;
        if(i==1)
            if(locs(i)<locs2(i))
                Height = abs(pks(i)-pks2(i));
                t = i;
                return;
            elseif(locs(i)>locs2(i))
                Height1 = abs(pks(i)-pks2(i));
                Height2 =abs(pks(i)-pks2(i+1));
                if (Height2<Height1)
                    t=i+1;
                else
                    t=i;
                end
                Height = min(Height1,Height2);
                return;
            end
        elseif(i==length(pks))
            if(length(pks2)<length(pks))
                Height =  abs(pks(i)-pks2(i-1));
                t = i-1;
                return;
            elseif(length(pks2)==length(pks))
                if(locs2(i)>locs(i))
                    Height1 = abs(pks(i)-pks2(i));
                    Height2 = abs(pks(i)-pks2(i-1));
                    if(Height2<Height1)
                        t=i-1;
                    else
                        t=i;
                    end;
                    Height = min(Height1,Height2);
                    return;
                elseif(locs2(i)<locs(i))
                    t=i;
                    Height =abs(pks(i)-pks2(i));
                    return;
                end
            elseif(length(pks2)>length(pks))
                Height1 = abs(pks(i)-pks2(i));
                Height2 = abs(pks(i)-pks2(i+1));
                if(Height2<Height1)
                    t=i+1;
                else
                    t=i;
                end;
                Height = min(Height1,Height2);
                return;
            end
                
        else
            if(locs(i)>locs2(i))
                Height1 =abs(pks(i)-pks2(i));
                Height2 = abs(pks(i)-pks2(i+1));
                if(Height2<Height1)
                    t=i+1;
                else
                    t=i;
                end;
                Height = min(Height1,Height2);
                return;
            elseif(locs(i)<locs2(i))
                Height1 =abs(pks(i)-pks2(i));
                Height2 = abs(pks(i)-pks2(i-1));
                if(Height2<Height1)
                    t=i-1;
                else
                    t=i;
                end;
                Height = min(Height1,Height2);
                return;
            end
        end
        
   
    
end
