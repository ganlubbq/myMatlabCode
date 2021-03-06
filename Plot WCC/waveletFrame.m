% 27/05/2012
%This is a preliminary code to:
% 1) Frame the input speech and do hamming window;
% 2) Compute the wavelet decomposition of each frame of the speech

[fileName,pathName] = uigetfile('.wav','Select wave file');

fileName = fullfile(pathName, fileName);

[y,fs,nbits] = wavread(fileName);

epdParam=epdParamSet(fs);
ep = epdByVolHod(y, fs, nbits, epdParam, 0);
y2=y(ep(1):ep(2));
out = buffer2(y2,256,128); % Frame the signal into chunks

for i = 1:size(out,2)
    
    windowed(:,i) = hamming(256).*out(:,i); % Smoothen with Hamming window.
    [C(:,i),L(:,i)] = wavedec(windowed(:,i),3,'db4');
    wavelet(:,i) = appcoef(C(:,i),L(:,i),'db4',3);
    energy(:,i) = sum(wavelet(:,i).^2)/256;
    logEnergy(:,i) = 10*log10(eps+energy(:,i));
    cepstrum(:,i) = dct(logEnergy(:,i));
end

X = wavelet(:);
X = wave2mfcc(X);
%windowed = windowed(:);
%plot(windowed)