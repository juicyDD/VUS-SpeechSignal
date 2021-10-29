clc;
clear;
%shift 35 -> 350
A= randi([1 100],1,500);
ACF = zeros(1,350-35+1);
for shift = 35:350
    acf=0;
    for i=1:(500-shift)
        acf=acf+A(i)*A(i+shift);
    end
    ACF(shift) = acf;
end
ACFzero = zeros(1,350-35+1);
for shift = 35:350
    acf=0;
    for i=1:(500-shift)
        acf=acf+A(i)*A(i);
    end
    ACFzero(shift) = acf;
end
Compare = zeros(1,350-35+1);
for shift = 35:350
    if ACFzero(shift)~=0
        Compare(shift) = ACF(shift)/ACFzero(shift);
    end;
end
figure;
subplot(3,1,1);
plot(ACF);
xlabel('Lag');
xlabel('ACF values with lag varies from 35 - 350 frame');
subplot(3,1,2);
plot(ACFzero);
xlabel('Lag');
xlabel('ACF values with lag equals 0');
subplot(3,1,3);
plot(Compare);
xlabel('Comparison of the two types of lag');
%neu tin hieu ko tuan hoan thi do tuong quan cua ACF so voi ACFzero luon
%nho hon 80%
