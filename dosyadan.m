close all;
clc;
%% Veri Giri�i
   
% dosya = input('Dosya yolunu yaz�n�z: ','s');

[dosyaAdi, dosyaYolu] = uigetfile({'*.jpg';'*.png';'*.tiff';'*.bmp'; '*.gif'},'Bir yaprak resmi se�iniz');

Irgb = imread(fullfile(dosyaYolu, dosyaAdi));

%Renk uzay�n� HSV'ye d�n��t�r.
Ihsv = rgb2hsv(Irgb);

%-------------------------------------------------------------------------%

% G�r�nt�y� gri �l�ekli resme d�n��t�r.
Iv = Ihsv(:,:,3);

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

%Beyaz �st�ne siyah g�r�nt�y� ters �evir
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

Iin = [bwr ecc sol ipf scx avi avc smt ent hmg crl]';


%% De�erlendirme
%Networke elde edilen g�r�nt� �zelliklerini g�nder

sonuc = sim(net, Iin);

%% Sonu�

%%En uygun de?erin bulunup g�sterilmesi

[enBuyuk indis] = max(sonuc);

%% Sonu�
  
  figure;  
  subplot(2,2,[1 3]);
  imshow(Irgb);

  hold on
  subplot(2,2,2);
  bar(linspace(1,40,40), sonuc);
  title('Sonu�');

  subplot(2,2,4);
  title('��lenen G�r�nt�');
  imshow(Ibw);

  
  
   display(sonucSoyle(enBuyuk, indis));