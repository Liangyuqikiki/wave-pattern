%shuffled data by randomizing raw voltage signal temporally 164 (keeping power spectrum on each pixel 
%but randomizing the phase of the Fourier components) and 165 spatially (randomly shuffling the pixels)
for surroN=1:length(trials)
%% Phase randomized surrogate
%% fft
%fft
T=1:size(vfs,3);
%% temporal filtering highpass
general.fmin = 0.1;
general.attenuation = 20;
general.order = 3;
%attention!!
general.srate = 150; %sampling rate [Hz]
[b, a] = cheby2(general.order,general.attenuation,general.fmin*2/general.srate,'high' );%Riedner 2007

data=zeros(132,114,length(T));%(x,y,z)z represents total time duration
for j=1:114 
    for i=1:132
        cache=filtfilt(b,a,double(ratioSequence(i,j,T)));
        mcache = mean(cache);
        data(i,j,:) = cache - mcache;
    end
end

data_s=data;
for i=1:size(data,1)
    for j=1:size(data,2)
        if(mask(i,j)>0)
        Y = fft(squeeze(data(i,j,:)));   
        p = randn(size(data,3)/2-1,1);
        r=abs(Y);
        rr=zeros(size(data,3),1);
        rr(2:size(data,3)/2)=p;
        rr(size(data,3)/2+2:size(data,3))=-p(end:-1:1);
        YX= r.*cos(angle(Y)+2*pi*rr)+r.*1i.*sin(angle(Y)+2*pi*rr);
        YX(Y==0)=0;%avoid Nan in atan(imag(Y)./real(Y), Y=0, no amplitude in this frequency
        X = ifft(YX,'symmetric');
        data_s(i,j,:)=X;
        end
    end
end

%% spatial filtering
Mask_in=zeros(size(mask,1),size(mask,2));
index=0;
for r=1:size(mask,1)
    for c=1:size(mask,2)
        index=index+1;
        Mask_in(r,c)=index;                         
    end
end
mask0=mask;
mask0(mask<1)=0;
Mask_in0=Mask_in.*mask0;
Mask_in0(Mask_in0==0)=[];
mask_rand = randperm(length(Mask_in0));
data_s_s=data_s;
for i=1:length(Mask_in0)
    [r,c]=find(Mask_in==Mask_in0(i));
    [r1,c1]=find(Mask_in==Mask_in0(mask_rand(i)));    
    data_s_s(r,c,:)=data_s(r1,c1,:);
end

%% bandpass 
general.fmin = 0.5; 
general.fmax = 4;
general.attenuation = 20;
general.order = 3; 
general.srate = 150; %sampling rate [Hz]
[b, a] = cheby2(general.order,general.attenuation,[general.fmin*2/general.srate general.fmax*2/general.srate]);%Riedner 2007
data=zeros(size(data_s,1),size(data_s,2),size(data_s,3));

%% on hilbert data  

for ii=1:size(ratioSequence,1)
    for jj=1:size(ratioSequence,2)
        if(mask(ii,jj)~=0)
        cache=filtfilt(b,a,double(data_s_s(ii,jj,:)));
        mcache = mean(cache);
        data(ii,jj,:) = cache - mcache;
        end
    end
end

run('optical_flow01_10.m')
run('mousePatternDetectionMain.m')

cd( 'N:\Kiki\2017 Apr 19\0.5-9Hz\a0.5b10\surrogate fft');
filenm = ['Exp001_Fluo_018_001_sequenceDataFiltered_05_9' num2str(surroN) '.mat' ];
save(filenm, 'Fs','','cortexMask','rsData', 'vfs','vx','vy','pattLocs','activeArray','patterns',  '-mat');

end
