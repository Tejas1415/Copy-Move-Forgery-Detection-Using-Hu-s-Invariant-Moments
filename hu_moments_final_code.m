clc
clear all
close all

i1=imread('tamp6.jpg'); 
i2=rgb2gray(i1);
figure,imshow(i2), title('Before Resize');
i2=imresize(i2, [64 64]);
figure, imshow(i2); title('i2');
figure, imshow(i2); title('i21');
[row, col] = size(i2);
i2=im2double(i2);

count5=0;
V=zeros(64,1);
counti=0;countj=0;S=zeros(1,2);
%hu=zeros(1,8);
hu=zeros(1,4);
add2=[0 0];
Blocks2 = cell(row/8,col/8);
for i=1:row-7
    counti = counti + 1;
   countj = 0;
    for j=1:col-7
        
        countj = countj + 1;
        Blocks2{counti,countj} = i2(i:i+7,j:j+7);
       count5=count5+1;
       [height, width] = size(image);
image=Blocks2{counti,countj};
% define a co-ordinate system for image 
xgrid = repmat((-floor(height/2):1:ceil(height/2)-1)',1,width);
ygrid = repmat(-floor(width/2):1:ceil(width/2)-1,height,1);

[x_bar, y_bar] = centerOfMass(image,xgrid,ygrid);

% normalize coordinate system by subtracting mean
xnorm = x_bar - xgrid;
ynorm = y_bar - ygrid;

% central moments
mu_11 = central_moments( image ,xnorm,ynorm,1,1);
mu_20 = central_moments( image ,xnorm,ynorm,2,0);
mu_02 = central_moments( image ,xnorm,ynorm,0,2);
mu_21 = central_moments( image ,xnorm,ynorm,2,1);
mu_12 = central_moments( image ,xnorm,ynorm,1,2);
mu_03 = central_moments( image ,xnorm,ynorm,0,3);
mu_30 = central_moments( image ,xnorm,ynorm,3,0);

%calculate first 8 hu moments of order 3
I_one   = mu_20 + mu_02;
I_two   = (mu_20 - mu_02)^2 + 4*(mu_11)^2;
I_three = (mu_30 - 3*mu_12)^2 + (mu_03 - 3*mu_21)^2;
I_four  = (mu_30 + mu_12)^2 + (mu_03 + mu_21)^2;
I_five  = (mu_30 - 3*mu_12)*(mu_30 + mu_12)*((mu_30 + mu_12)^2 - 3*(mu_21 + mu_03)^2) + (3*mu_21 - mu_03)*(mu_21 + mu_03)*(3*(mu_30 + mu_12)^2 - (mu_03 + mu_21)^2);
I_six   = (mu_20 - mu_02)*((mu_30 + mu_12)^2 - (mu_21 + mu_03)^2) + 4*mu_11*(mu_30 + mu_12)*(mu_21 + mu_03);
I_seven = (3*mu_21 - mu_03)*(mu_30 + mu_12)*((mu_30 + mu_12)^2 - 3*(mu_21 + mu_03)^2) + (mu_30 - 3*mu_12)*(mu_21 + mu_03)*(3*(mu_30 + mu_12)^2 - (mu_03 + mu_21)^2);
I_eight = mu_11*(mu_30 + mu_12)^2 - (mu_03 + mu_21)^2 - (mu_20 - mu_02)*(mu_30 + mu_12)*(mu_21 + mu_03);

%hu_moments_vector = [I_one, I_two, I_three,I_four,I_five,I_six,I_seven,I_eight];
hu_moments_vector = [I_one, I_two, I_three,I_four];
hu_moments_vector_norm= -sign(hu_moments_vector).*(log10(abs(hu_moments_vector)));
hu_moments_vector_norm = abs(hu_moments_vector_norm)*100;
hu_moments_vector_norm= round(hu_moments_vector_norm);
hu = vertcat(hu,hu_moments_vector_norm);

S=[counti countj];
        add2= vertcat(add2,S); 
    end
end
L=hu;
L(1,:)=[];
add2(1,:)=[];
L=[L add2];

L1=sortrows(L);

S2= [L1(:,end-1) L1(:,end)];

L1(:,end-1)=[];
L1(:,end)=[];
shiftvector=zeros(1,2); copy=zeros(1,6);
count55=0;
for i=2:3249
    K2=0; J2=0;
    if(isequal(L1(i,:),L1(i-1,:))==1)
count55=count55+1;
 K2=S2(i,1); J2=S2(i,2);
        K3=S2(i-1,1); J3= S2(i-1,2);
        s1= K2-K3; s2=J2-J3;
        s=[s1 s2];
        shiftvector = vertcat(shiftvector,s);
        c= [K2 J2 K3 J3 s1 s2];
        copy= vertcat(copy,c);
    end
end
copy(1,:)=[];
    
shiftvector(1,:)=[];
 shiftvector= abs(shiftvector);
matrix = unique(shiftvector, 'rows', 'stable');

[row2, col2]= size(shiftvector);
[row3, col3]= size(matrix);
cnt=0; repetition= zeros(row3,1);
for i=1:row3
    for j=1:row2
    if (matrix(i,:)== shiftvector(j,:))
        cnt=cnt+1;
    end
    end
        repetition(i,1)=cnt;
        cnt=0;
end

threshold = repetition > 2000 & repetition < 3000;
repetition
%tamp9.ico-(105,400)-*100

V2 = zeros(64,64);
c6=0;c7=0;
for i=1:row3
    if(threshold(i,:)==1)
        rep1= matrix(i,1);
        rep2= matrix(i,2);
        c7=c7+1;
     for j=2:row2
         if(shiftvector(j,:)==[rep1 rep2])
             rep3= copy(j,1); rep4= copy(j,2);
             rep5=copy(j,3); rep6=copy(j,4);
             V2(rep3:rep3+7, rep4:rep4+7)= ones(8,8);
             V2(rep5:rep5+7, rep6:rep6+7)= ones(8,8);
             c6=c6+1;
         end
     end
    end
end
figure,imshow(V2); title('copy moved part');
%V2=imresize(V2, [128 128]);
figure, imshow(~V2); title ('inverted image');
