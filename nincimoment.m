function mm3 = nincimoment(Ivc, n)

    %NINCIMOMENT Görüntünün n dereceden momentini al
    %   Iv    :  Ihsv nin v parçasý
    %   p     :  histogram
    %   n     :  moment derecesi


    Z = Ivc(:);

    IL = unique(Z);      % Get all intensity levels
    noinle = numel(IL);      % Number of intensity levels
    p = hist(Ivc, noinle);    % Histogram

    m = mean(Z);

    mm3 = 0;
   
    for i = 1:noinle

        mm3 = mm3 + sum( (Z(i)-m).^n * p(i) );

    end
    
end

