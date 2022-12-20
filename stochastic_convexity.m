function scx = stochastic_convexity( L, noktaSayisi)
%STOCHASTÝC_CONVEXÝTY 
%   Resim üzerine rastgele noktalarý gönderip resmin üzerine isabet eden
%   nokta sayýsýný toplam nokta sayýsýna bölerek 0-1 arasýnda bir olasýlýk
%   deðeri döndür

isabet = 0;

msize = numel(L);
idx = randperm(msize);

for p = 1:noktaSayisi

    if L(idx(p)) == 1
        isabet = isabet + 1;
    end

end

scx = isabet / noktaSayisi;

