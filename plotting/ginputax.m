function [x y b ax] = ginputax(n)
%SCd 12/02/2010
    x = zeros(n,1);
    y = x;
    b = x;
    ax = x;
    for ii = 1:n
        [x(ii) y(ii) b(ii)] = ginput(1);
        ax(ii) = gca;
    end 