function sonuc = sonucSoyle(enBuyuk, indis)

turler = {  'Quercus suber','Salix atrocinerea','Populus nigra','Alnus sp'...
              'Quercus robur','Crataegus monogyna','Ilex aquifolium','Nerium oleander'...
              'Betula pubescens','Tilia tomentosa','Acer palmaturu','Celtis sp'...
              'Corylus avellana','Castanea sativa','Populus alba','Acer negundo'...
              'Taxus bacatta','Papaver sp','Polypodium vulgare','Pinus sp'...
              'Fraxinus sp','Primula vulgaris','Erodium sp','Bougainvillea sp'...
              'Arisarum vulgare','Euonymus japonicus','Ilex perado ssp azorica','Magnolia soulangeana'...
              'Buxus sempervirens','Urtica dioica','Podocarpus sp','Acca sellowiana'...
              'Hydrangea sp','Pseudosasa japonica','Magnolia grandiflora','Geranium sp'...
              'Aesculus californica','Chelidonium majus','Schinus terebinthifolius','Fragaria vesca'};
          
          
  sonuc = sprintf('Y�zde %0.6f olas�l�kla %d. %s',enBuyuk*100, indis, turler{indis});        









% %%En uygun de�erin bulunup g�sterilmesi
% 
% [enBuyuk indis] = max(sonuc);
% 
% %Saymaya s�f�rdan ba�lamas� i�in indis de�erini bir azalt.
% indis = indis - 1;
% 
% %% Sonu�
%   
%   figure;  
%   subplot(1,2,1);
%   
%   bar(linspace(1,40,40), sonuc);
% 
%   subplot(1,2,2);
%   title('��lenen G�r�nt�');
%   imshow(sbk');
% 
%   soyle(enBuyuk, indis);