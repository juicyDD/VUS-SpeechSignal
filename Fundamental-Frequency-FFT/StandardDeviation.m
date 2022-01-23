function stdmean = StandardDeviation(FundamentalFrequency)
    f0 = mean(FundamentalFrequency);
    stdmean = 0;
    for i=1:length(FundamentalFrequency)
        stdmean = stdmean + (FundamentalFrequency(i)-f0)^2;
    end
    stdmean = stdmean / length(FundamentalFrequency);
    stdmean = sqrt(stdmean);
    return;
    
    
end