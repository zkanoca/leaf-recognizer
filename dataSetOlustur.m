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
    
    
    
    %Renk uzayýný HSV'ye dönüþtür.
    Ihsv = rgb2hsv(Irgb);

    %-------------------------------------------------------------------------%

    % Görüntüyü gri ölçekli resme dönüþtür.
    % hcsc = vision.ColorSpaceConverter;
    % 
    % hcsc.Conversion = 'RGB to Intensity';
    %     
    % Ig = step(hcsc, Ihsv);

    Iv = Ihsv(:,:,3);

    %-------------------------------------------------------------------------%





    %-------------------------------------------------------------------------%

    %Görüntüye Medyan Filtresi uygula
    f = 5;
    filtre = vision.MedianFilter([f f]);

    Iv = step(filtre,Iv);

    %-------------------------------------------------------------------------%

    % Gri ölçekli görüntüyü siyah-beyaz görüntüye dönüþtür.  
    at = vision.Autothresholder;

    Iwb = step(at, Iv);

    %-------------------------------------------------------------------------%


    Ibw = imcomplement(Iwb);


    %-------------------------------------------------------------------------%


    %300 pikselden daha küçük olan beyaz bölgeleri kaldýr
    Ibw = bwareaopen(Ibw,300,8);

    %-------------------------------------------------------------------------%

    
    Ivc = Iv;

    Ivc( ~any(Ibw,2), : ) = [];  %bos satirlar
    Ivc( :, ~any(Ibw,1) ) = [];  %boS sütunlar


    %Boþ satýr ve sütunlarý yok et.
    Ibw( ~any(Ibw,2), : ) = [];  %boþ satýrlar
    Ibw( :, ~any(Ibw,1) ) = [];  %boþ sütunlar

    %Siyah Beyaz piksel sayýlarýnýn oraný
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


%% Özellikler

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