function [x_bar, y_bar] = centerOfMass(image,xgrid,ygrid)

    eps = 10^(-6); % very small constant 
    
    x_bar = sum(sum((xgrid.*image)))/(sum(image(:))+eps);
    y_bar = sum(sum((ygrid.*image)))/(sum(image(:))+eps);

end