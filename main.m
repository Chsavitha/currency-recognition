clc;
clear all;
close all;

cd Image
[file,path] = uigetfile('*.jpg;*.png','pick an image file');
img = imread(file);
cd ..
img=rgb2gray(img);
tinp = imresize(img,[150 333]);

figure('Name','Input Image','MenuBar','none');
imshow(tinp);

% inp1 = Freg;
[ll,lh,hl,hh]=dwt2(tinp,'db1');
img22=[ll,lh;hl,hh];
figure;
imshow(img22,[]);
hlp = ptp(ll);

 %%Gray level Co-occurance matrix on LL subband
 inp=hlp;
 max_level = max(max(inp));
 min_level = min(min(inp));
 NLevels = max_level-min_level;
 
 Gmatrix = graycomatrix(inp,'NumLevels',NLevels,'GrayLimits',[min_level max_level]);
 GLCM = graycoprops(Gmatrix);
 
 cont = GLCM.Contrast;
 corr = GLCM.Correlation;
 En = GLCM.Energy;
 Homo =  GLCM.Homogeneity;
 QFeatll11 =[cont;corr;En;Homo]; 
 
%  LH subband
 lhp = ptp(lh);


 %%Gray level Co-occurance matrix on LH subband
 inp=lhp;
 max_level = max(max(inp));
 min_level = min(min(inp));
 NLevels = max_level-min_level;
 
 Gmatrix = graycomatrix(inp,'NumLevels',NLevels,'GrayLimits',[min_level max_level]);
 GLCM = graycoprops(Gmatrix);
 
 cont = GLCM.Contrast;
 corr = GLCM.Correlation;
 En = GLCM.Energy;
 Homo =  GLCM.Homogeneity;
 Qft1 =[cont;corr;En;Homo]; 
 
%  HL subband
hlp = ptp(hl);

 %%Gray level Co-occurance matrix on LL subband
 inp=hlp;
 max_level = max(max(inp));
 min_level = min(min(inp));
 NLevels = max_level-min_level;
 
 Gmatrix = graycomatrix(inp,'NumLevels',NLevels,'GrayLimits',[min_level max_level]);
 GLCM = graycoprops(Gmatrix);
 
 cont = GLCM.Contrast;
 corr = GLCM.Correlation;
 En = GLCM.Energy;
 Homo =  GLCM.Homogeneity;
 QFeathl111 =[cont;corr;En;Homo];
 QFeatfn22=[QFeatll11;Qft1;QFeathl111];
 load Tt Tt
load netp netp;
Qfeature = Egrh(QFeatfn22);
Out = sim(netp,Qfeature);       %%%%Simulate query feature with trained network...
Out = vec2ind(Out==1);
helpdlg(strcat('Identified indian Rupees note is ..',num2str(Tt(Out))));


% Fakeness detection
cd database
idimg=imread(strcat(num2str(Out),'.jpg'));
idimg=rgb2gray(idimg);
idimg1 = imresize(idimg,[150 333]);
cd ..
% ROI selection
load rectfin rectfin;
rectid=squeeze(rectfin(Out,:,:));

for lpcr=1:4
crpimg11=imcrop(idimg1,rectid(lpcr,:));
if lpcr==1
    crpimg1=crpimg11;
elseif lpcr==2
    crpimg2=crpimg11;
elseif lpcr==3
    crpimg3=crpimg11;
elseif lpcr==4
    crpimg4=crpimg11;
end
end

for lpcr=1:4
    if lpcr==1
        imgana=crpimg1;
    elseif lpcr==2
        imgana=crpimg2;
    elseif lpcr==3
        imgana=crpimg3;
    elseif lpcr==4
        imgana=crpimg4;
    end
   figure; 
edglhp = edge(imgana,'canny');
imshow(edglhp);
imgid=zeros(size(imgana,1),size(imgana,2));
rr=size(imgana,1);
cc=size(imgana,2);
for rl=1:rr
    for cl=1:cc
        if edglhp(rl,cl)==1
            imgid(rl,cl)=imgana(rl,cl);
        else 
            imgid(rl,cl)=0;
        end
    end
end

%%Gray level Co-occurance matrix on LL subband
 inp=imgid;
 max_level = max(max(inp));
 min_level = min(min(inp));
 NLevels = max_level-min_level;
 
 Gmatrix = graycomatrix(inp,'NumLevels',NLevels,'GrayLimits',[min_level max_level]);
 GLCM = graycoprops(Gmatrix);
 
 cont = GLCM.Contrast;
 corr = GLCM.Correlation;
 En = GLCM.Energy;
 Homo =  GLCM.Homogeneity;
 QF1 =[cont;corr;En;Homo]; 
 
 QFt(lpcr,:)=QF1;
end
Qft=reshape(QFt,size(QFt,1)*size(QFt,1),1);
load Dbsvmfeat Dbsvmfeat
GroupTrain(:,1:14)=ones(1,14);
GroupTrain(:,15:28)=2*ones(1,14);
[result] = multisvm(Dbsvmfeat,GroupTrain,Qft');
if result==1
    helpdlg('Original Currency Identified');
elseif result==2
    helpdlg('Fake Currency Identified');
end



