function GCD = ApproximateGCD(locss)
 
    GCD = 0;
    tempArr = [];
    for i = 1 : length(locss)
        if(locss(i)~=0)
            tempArr = [tempArr,locss(i)];
        end
    end
    
    tempArr=tempArr.*8;
    %disp(tempArr);
    GCDArr = [];
    for i=1:(length(tempArr))
        if (i~=1)
            x1 = tempArr(i);
            x2 = tempArr(i-1);
        else
            x1 = tempArr(i);
            x2 =0;
        end
        if (min(x1,x2)<70) 
            continue;
        end;
        
        if(abs(x1-x2)>70)
            GCDArr = [GCDArr,abs(x1-x2)];
        end;
            
    end
    %disp(length(GCDArr));
    c=0;
    GCDArr = sort(GCDArr,'descend');
    
    
    if (length(GCDArr)>=2)
        c=mean(GCDArr(1:2));
    else
        
        c=max(GCDArr);
    end
    
    
    GCDArr = GCDArr/c;
    GCDArr2=GCDArr;
    
    GCDArr2=[];
    lenGCD=length(GCDArr);
   %{ 
    if (c>300) 
        ratio=0.5;
    else
        ratio=0.2;
    end;
    %}
    ratio=0.7;
    for i=1:lenGCD-1
        if(GCDArr(i)>ratio)
        
            GCDArr2=[GCDArr2,GCDArr(i)];
        else
            if i==1||i==lenGCD%||i==lenGCD-1
                GCDArr2=[GCDArr2,GCDArr(i)];
                
                continue;
            else
                %minGCD=min(GCDArr(i-1),GCDArr(i+1));
                if (GCDArr(i)+GCDArr(i+1)) > 1.5 %
                    continue;%
                else%
                GCDArr2=[GCDArr2,(GCDArr(i)+GCDArr(i+1))];
                end;
                i=i+1;
                while GCDArr2(length(GCDArr2))<0.7&& ((i+1)<=length(GCDArr))&&(GCDArr(i)+GCDArr(i+1)) <1.5 

                    GCDArr2(length(GCDArr2))=GCDArr2(length(GCDArr2))+GCDArr(i+1);
                    i=i+1;
                end
            end
            
            
            
            %lenGCD=lenGCD-1;
            
        end
    end
    
    if (isempty(GCDArr2))
        
        GCD=0;
        return;
    end
    GCD=nonzeros(GCD);
    GCD = mean(GCDArr2.*c);
    
    return;
end

