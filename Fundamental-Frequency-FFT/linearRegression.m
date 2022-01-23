
function stopPoint = linearRegression(pks,locs)
    
    
    len = length(pks); meanY=0;
    stopPoint=0;
    x=locs.*8;
    stopPoint=x(floor(length(x)/4));
    %pks=sort(pks,'descend');
    %maxpks = mean(pks(1:2));
    for i=1:(len-10)
        
        meanx=mean(x(i:i+10));
        meany=mean(pks(i:i+10));
        
        x2=x(i:i+10);
        y2=pks(i:i+10);
        
        stdx=sqrt(sum((x2-meanx).^2)/10);
        stdy=sqrt(sum((y2-meany).^2)/10);
        covxy=0;
        for k=1:10
            covxy=covxy+(x2(k)-meanx)*(y2(k)-meany);
        end
        covxy=covxy/(10-1);
        
        alpha=covxy*(stdy/stdx);
        alpha0=meany-alpha*meanx;
        %disp(alpha);
        if(alpha<0.268)&&(alpha>-0.268) %tan goc 15 do =0.268
            count = 0;
            for nhi=1:10
                
                if(y2(nhi)<max(pks)*0.2)
                    count = count+1;
               end
                
            end
           if (count>=3)&&(x(i)>250)
                stopPoint = x(i); %,round(length(x)/20))
                return;
            %end;
           
           end
        
        end
        
    
    end
    return;
end