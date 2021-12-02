
lda = waitbar(0,'NN Training On Process ...');

for ii=1:28
cd database
img = imread(strcat(num2str(ii),'.jpg'));
cd ..
img=rgb2gray(img);
tinp = imresize(img,[150 333]);

% inp1 = Freg;
[ll,lh,hl,hh]=dwt2(tinp,'db1');
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
 QFeatll =[cont;corr;En;Homo]; 
 
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
 QFeatlh =[cont;corr;En;Homo]; 
 
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
 QFeathl =[cont;corr;En;Homo]; 
 
 QFeatfn=[QFeatll;QFeatlh;QFeathl];
 dBFeatfn(ii,:)=QFeatfn;
           waitbar(ii/9,lda);
end
close(lda);
dBFeatfn=dBFeatfn';

T=size(dBFeatfn,1);
%%%%%Neural network creation and training 
Nc = 1; T=1;
save dBFeatfn dBFeatfn;
for dfi=1:size(dBFeatfn,2)
    if Nc>1
      T = T+1;
      Nc =4;
      acti(:,dfi) = T; 
    else
      acti(:,dfi) = T;  
    end
    T=T+1;
end
actv = ind2vec(acti);   %%%%%Indices to vector creation
netp = newpnn(dBFeatfn,actv);   %%%%network training
save netp netp;
helpdlg('NNtraining completed');
return; 