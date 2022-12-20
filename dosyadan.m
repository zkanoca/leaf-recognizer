close all;
clc;
%% Veri Giriþi
   
% dosya = input('Dosya yolunu yazýnýz: ','s');

[dosyaAdi, dosyaYolu] = uigetfile({'*.jpg';'*.png';'*.tiff';'*.bmp'; '*.gif'},'Bir yaprak resmi seçiniz');

Irgb = imread(fullfile(dosyaYolu, dosyaAdi));

%Renk uzayýný HSV'ye dönüþtür.
Ihsv = rgb2hsv(Irgb);

%-------------------------------------------------------------------------%

% Görüntüyü gri ölçekli resme dönüþtür.
Iv = Ihsv(:,:,3);

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

%Beyaz üstüne siyah görüntüyü ters çevir
Ibw = imcomplement(Iwb);


%-------------------------------------------------------------------------%


%300 pikselden daha küçük olan beyaz bölgeleri kaldýr
Ibw = bwareaopen(Ibw,300,8);

%-------------------------------------------------------------------------%

Ivc = Iv;

Ivc( ~any(Ibw,2), : ) = [];  %bos satirlar
Ivc( :, ~any(Ibw,1) ) = [];  %boS sütunlar



%Bos satir ve sütunlari kirp.
Ibw( ~any(Ibw,2), : ) = [];  %bos satirlar
Ibw( :, ~any(Ibw,1) ) = [];  %bos sütunlar



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

Iin = [bwr ecc sol ipf scx avi avc smt ent hmg crl]';


%% Deðerlendirme
%Networke elde edilen görüntü özelliklerini gönder

sonuc = sim(net, Iin);

%% Sonuç

%%En uygun de?erin bulunup gösterilmesi

[enBuyuk indis] = max(sonuc);

%% Sonuç
  
  figure;  
  subplot(2,2,[1 3]);
  imshow(Irgb);

  hold on
  subplot(2,2,2);
  bar(linspace(1,40,40), sonuc);
  title('Sonuç');

  subplot(2,2,4);
  title('Ýþlenen Görüntü');
  imshow(Ibw);

  
  
   display(sonucSoyle(enBuyuk, indis));