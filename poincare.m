% histogram of the poincare index which is source+sink-saddle
all_b=zeros(length(trials),size(vfs,3));
all_bl=zeros(length(trials),length(trials));
exp_n=0;
for exp=1:length(trials)
    exp_n=exp_n+1;
    cd( 'N:\Kiki\2018 Feb 04\M2560F\0.5-4Hz\a0.5b10');
    % load experimental data from NARS
    % data name
    load (['Exp001_Fluo_00' num2str(exp) '_001_sequenceDataFiltered_bandpass0.5_4_done' '.mat']);
    params = setPatternParams(Fs);%radius=2,dura=0.02

    %%
    params.minCritRadius=3;
    params.minDuration=5;
    % %% Find all patterns
    % [patterns, pattTypes, colNames, pattLocs] = ...
    %     findAllPatterns(real(vfs), imag(vfs), params);
    % change from single to double
    [patterns, pattTypes, colNames, pattLocs] = ...
        findAllPatterns(double(real(vfsT)), double(imag(vfsT)), params);

    %% Also make a binary array showing the patterns active in every time step
    activeArrayT = makeActivePatternsArray(patterns, length(pattTypes), ...
        size(vfsT,3));
    b=sum(activeArrayT(3:4,:),1)-activeArrayT(5,:);
    all_b(exp_n,:)=b(1:26921);
    for i=1:length(trials)
        all_bl(exp_n,i)=length(find(b==i-7));   
    end
end

all_bl=all_bl./sum(all_bl,2);
figure
bar(mean(all_bl))
hold on
errorbar((1:13),mean(all_bl),std(all_bl,0,1).*0,std(all_bl,0,1),'.k')

  