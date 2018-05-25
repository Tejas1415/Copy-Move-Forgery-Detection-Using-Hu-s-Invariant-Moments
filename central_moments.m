function cm = central_moments( image ,xnorm,ynorm,p,q)
    
    cm = sum(sum((xnorm.^p).*(ynorm.^q).*image));
    cm_00 = sum(sum(image)); %this is same as mu(0,0);
    % normalise moments for scale invariance
    cm = cm/(cm_00^(1+(p+q)/2));
    
end