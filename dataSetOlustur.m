clear all;
close all;
clc;
warning('off', 'all');

files = dosyalariBul('RGB');

featureSet = zeros(length(files),51);

% load dataSet;

tic

for d = 1:length(files)

    Irgb = imread(files{d});
     sprintf('%s', files{d})
    
    
    
    %Renk uzay�n� HSV'ye d�n��t�r.
    Ihsv = rgb2hsv(Irgb);

    %-------------------------------------------------------------------------%

    % G�r�nt�y� gri �l�ekli resme d�n��t�r.
    % hcsc = vision.ColorSpaceConverter;
    % 
    % hcsc.Conversion = 'RGB to Intensity';
    %     
    % Ig = step(hcsc, Ihsv);

    Iv = Ihsv(:,:,3);

    %-------------------------------------------------------------------------%





    %-------------------------------------------------------------------------%

    %G�r�nt�ye Medyan Filtresi uygula
    f = 5;
    filtre = vision.MedianFilter([f f]);

    Iv = step(filtre,Iv);

    %-------------------------------------------------------------------------%

    % Gri �l�ekli g�r�nt�y� siyah-beyaz g�r�nt�ye d�n��t�r.  
    at = vision.Autothresholder;

    Iwb = step(at, Iv);

    %-------------------------------------------------------------------------%


    Ibw = imcomplement(Iwb);


    %-------------------------------------------------------------------------%


    %300 pikselden daha k���k olan beyaz b�lgeleri kald�r
    Ibw = bwareaopen(Ibw,300,8);

    %-------------------------------------------------------------------------%

    
    Ivc = Iv;

    Ivc( ~any(Ibw,2), : ) = [];  %bos satirlar
    Ivc( :, ~any(Ibw,1) ) = [];  %boS s�tunlar


    %Bo� sat�r ve s�tunlar� yok et.
    Ibw( ~any(Ibw,2), : ) = [];  %bo� sat�rlar
    Ibw( :, ~any(Ibw,1) ) = [];  %bo� s�tunlar

    %Siyah Beyaz piksel say�lar�n�n oran�
    siyah_pikseller = sum(Ibw(:) == 0);
    beyaz_pikseller = sum(Ibw(:) == 1);
    bwr = siyah_pikseller / beyaz_pikseller;

    

    [L NUM] = bwlabel(Ibw, 8);


    for j=1:NUM
      L = changem(L, 1, j);
    end




    Ibw = imfill(Ibw,'holes');


    srgp = regionprops(L, 'all');
    sgcp = graycoprops(uint8(Ivc*255));


%% �zellikler

%Eccentricity
ecc = srgp.Eccentricity;

%Solidity
sol = srgp.Solidity;

center = srgp.Centroid;
diameter = mean([srgp.MajorAxisLength srgp.MinorAxisLength],2);
radii = diameter/2;

%Isoperimetric Factor
ipf = 4 * pi * srgp.Area/(srgp.Perimeter * srgp.Perimeter);

%Stochastic Convexity
scx = stochastic_convexity(Ivc, 100);

%Average Intensity
avi = mean2(Ivc);

%Average Contrast
avc = std2(Ivc);

%Smoothness
smt = 1 - 1 / (1 + avc^2);

%Entropy
ent = entropy(Ivc);


%Homogeneity
hmg = sgcp.Homogeneity;


%Correlation
crl = sgcp.Correlation;


    
featureSet(d, 1:11)    = [bwr ecc sol ipf scx avi avc smt ent hmg crl];    

 


end

save dataSet featureSet


toc
% 
% hold on;
% subplot(2,2,1);
% imshow(Irgb);
% title(sprintf('%s (RGB)', files{d}));
% % subplot(2,2,2);
% % imshow(Ihsv);
% % title(sprintf('%s (HSV)', files{d}));
% 
% subplot(2,2,3);
% imshow(Iv);
% title(sprintf('%s (Gri)', files{d}));
% subplot(2,2,[2 4]);
% imshow(Ibw);
% title(sprintf('%s (BW)', files{d}));
% hold on
% plot(stats.Centroid(1), stats.Centroid(2), 'r+');
% hold off;