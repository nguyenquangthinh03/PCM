clc;
close all;
clear all;
n=input('Enter for n-bit PCM system : '); %Encodebook Bit Length
n1=input('Enter Sampling Frequency : '); %Sampling Frequency
L = 2^n; %Number of Quantisation Levels

Vmax = input('Enter Amplitude of Analog Signal: ');
x = 0:pi/n1:4*pi; %Construction of Signal
ActualSignl=Vmax*sin(x); 
subplot(3,1,1);
plot(ActualSignl);
title('Analog Signal');
subplot(3,1,2); %Sampled Version
stem(ActualSignl);
grid on; 
title('Sampled Sinal');

Vmin=-Vmax; 
StepSize=(Vmax-Vmin)/L; 
QuantizationLevels=Vmin:StepSize:Vmax;
codebook=Vmin-(StepSize/2):StepSize:Vmax+(StepSize/2); 
[ind,q]=quantiz(ActualSignl,QuantizationLevels,codebook); 
NonZeroInd = find(ind ~= 0);
ind(NonZeroInd) = ind(NonZeroInd) - 1;
 
BelowVminInd = find(q == Vmin-(StepSize/2));
q(BelowVminInd) = Vmin+(StepSize/2);

subplot(3,1,3);
stem(q);
grid on; % Display the Quantize values
title('Quantized Signal');
figure
TransmittedSig = de2bi(ind,'left-msb'); 
SerialCode = reshape(TransmittedSig',[1,size(TransmittedSig,1)*size(TransmittedSig,2)]);
subplot(2,1,1);
grid on;
stairs(SerialCode); % Display the SerialCode Bit Stream
axis([0 100 -2 3]);
title('Transmitted Signal');

RecievedCode=reshape(SerialCode,n,length(SerialCode)/n);

index = bi2de(RecievedCode','left-msb');

q = (StepSize*index); %Convert into Voltage Values
q = q + (Vmin+(StepSize/2));
subplot(2,1,2);
grid on;
plot(q); % Plot Demodulated signal
title('Demodulated Signal');
