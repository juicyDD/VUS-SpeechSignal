function [d, n] =  EuclideanDistance(X,Vowel)
    DistanceArr=[];
    for i=1:length (Vowel(:,1))
        Voweli=[];
        Voweli=Vowel(i,:);
        d=0;
        for j=1:length(Voweli)
            d=d+(Voweli(j)-X(j)).^2;
        end
        d=sqrt(d);
        DistanceArr=[DistanceArr,d];
    end
    [d,n]=min(DistanceArr);
    return;
end