function scx = stochastic_convexity( L, noktaSayisi)
%STOCHAST�C_CONVEX�TY 
%   Resim �zerine rastgele noktalar� g�nderip resmin �zerine isabet eden
%   nokta say�s�n� toplam nokta say�s�na b�lerek 0-1 aras�nda bir olas�l�k
%   de�eri d�nd�r

isabet = 0;

msize = numel(L);
idx = randperm(msize);

for p = 1:noktaSayisi

    if L(idx(p)) == 1
        isabet = isabet + 1;
    end

end

scx = isabet / noktaSayisi;

