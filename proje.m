clear all;
close all;
clc;
warning('off', 'all');

% files = dosyalariBul('RGB');
% save dosya_isimleri files;

load dosya_isimleri;
d = 2;

tic


  
Irgb = imread(files{d});

%Renk uzayini HSV'ye d�n�st�r.
Ihsv = rgb2hsv(Irgb);

%-------------------------------------------------------------------------%

% % G�r�nt�y� gri �l�ekli resme d�n�st�r.
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

% Gri �l�ekli g�r�nt�y� siyah-beyaz g�r�nt�ye d�n�st�r.  
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



%Bos satir ve s�tunlari kirp.
Ibw( ~any(Ibw,2), : ) = [];  %bos satirlar
Ibw( :, ~any(Ibw,1) ) = [];  %bos s�tunlar



%Siyah Beyaz piksel sayilarinin orani
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

toc

hold on;
subplot(2,2,1);
imshow(Irgb);
title(sprintf('%s (RGB)', files{d}));
% subplot(2,2,2);
% imshow(Ihsv);
% title(sprintf('%s (HSV)', files{d}));

subplot(2,2,3);
imshow(Ivc);
title(sprintf('%s (Gri)', files{d}));
subplot(2,2,[2 4]);
imshow(Ibw);
title(sprintf('%s (BW)', files{d}));
hold on
plot(srgp.Centroid(1), srgp.Centroid(2), 'r+');
hold off;