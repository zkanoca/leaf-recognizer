function U = uniformity(Ivc)


    Z = Ivc(:);

    IL = unique(Z);        % Get all intensity levels
    noinle = numel(IL);    % Number of intensity levels
    p = hist(Ivc, noinle); % Histogram

    

    U = 0;
   
    for i = 1:noinle

        U = U + sum( p(i,:).^2 );

    end
    
end



;


