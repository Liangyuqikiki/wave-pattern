%% 'Atlas V2015' comes from Allen Institute: https://portal.brain-map.org/
%%'hierarchy.xlsx' comes from: Fulcher, Ben D., et al. "Multimodal gradients across mouse cortex." Proceedings of the National Academy of Sciences 116.10 (2019): 4689-4695.
%% load allen atlas2015, count ROI number of the whole brain
fileLoc = 'D:\Kiki\paper 1';
% atlas name
atlasName = '23_2015_ROIsABM.mat';
load(fullfile(fileLoc, atlasName))

fileLoc = 'N:\EXPERIMENTAL DATA MIRROR\Dataset for registration M1532M\Atlas V2015';
% atlas name
atlasName = 'map_id_layer23.mat';
% load atlas matrix
load(fullfile(fileLoc, atlasName))
%% load allen atlas2015, count ROI number of the whole brain
fileLoc = 'D:\Kiki\paper 1';
% atlas name
atlasName = '23_2015_ROIsABM.mat';
% load atlas matrix
load(fullfile(fileLoc, atlasName))
myROI=ROI;
RC = [2 17 90 91 151 152 172 173 174 176 177 195 196 197 ...
    198 199 200 209 224 297 298 358 359 379 380 381 ...
    383 384 402 403 404 405 406 407];

% Removing regions with no data.
n=0;
for i=[9,24,27,28,29,30,33,46,53,54]
    myROI(i-n,:,:)=[];
    Acromym(i-n)=[];
    Labels(i-n)=[];
    n=n+1;
end
% combine VISa and VISrl into PTLp
for i=[27,5]
    myROI(i,:,:)=myROI(i,:,:)+myROI(i+1,:,:);
    myROI(i+1,:,:)=[];
    Acromym(i)={'PTLp'};
    Acromym(i+1)=[];
end
boundary=squeeze(sum(myROI,1));
boundary(boundary>1)=NaN;

%%  insert hierachy_newarea.xlsx   
cd('D:\Kiki\paper 1\for JNS');
C = readcell('hierarchy.xlsx');
Acromym2 = readcell('Acromym2.xlsx');
hierarchy=hierarchynewarea;
hie=zeros(1,size(myROI,1)/2);
hie_sys=zeros(1,size(myROI,1)/2);
atlasindex=zeros(1,size(myROI,1)/2);
for i=1:size(myROI,1)/2
    temp=Acromym(i);
    C = strsplit(temp{1},' ');
    for j=1:size(hierarchy,1) 
        if (strcmp(C{1},hierarchy{j,1}))
%             spaceindex(:,:)=spaceindex(:,:)+ACAd{j,i}.*squeeze(myROI(i,:,:));
            hie(i)=hierarchy{j,2};
            hie_sys(i)=hierarchy{j,3};
            atlasindex(i)=hierarchy{j,4};
            break;
        end
    end
end
hie=hie(2:end);
hie_sys=hie_sys(2:end);
Acromym2=Acromym2(2:end);

