
function filter_bank = construct_Gabor_filters(num_of_orient, num_of_scales, size1, fmax, ni, gamma, separation);
%����GaborС���˲���
%author:gcl.K
filter_bank = [];
if nargin <3
    disp('Wrong number of input parameters! The function requires at least three input arguments.')
    return;
elseif nargin >7
    disp('Wrong number of input parameters! The function takes no more than seven input arguments.')
    return;
elseif nargin==3
    fmax = 0.25;
    ni = sqrt(2);
    gamma = sqrt(2);
    separation = sqrt(2);
elseif nargin==4
    ni = sqrt(2);
    gamma = sqrt(2);
    separation = sqrt(2);
elseif nargin==5
    gamma = sqrt(2);
    separation = sqrt(2);
elseif nargin==6
    separation = sqrt(2);    
end

[a,b]=size(size1);
if a == 1 && b==1
    size1 = [size1 size1];
elseif a==1 && b==2
 
elseif a==2 && b==1
    size1=size1'; %��ʵ������û�б�Ҫ��
else
    disp('The parameter determining the size of the filters is not valid.')
    return;
end

filter_bank.spatial = cell(num_of_scales,num_of_orient);
filter_bank.freq = cell(num_of_scales,num_of_orient);

%�����˲���
for u = 0:num_of_scales-1 %����ÿ���߶�
    fu = fmax/(separation)^u;
    alfa = fu/gamma;
    beta = fu/ni;
    sigma_x = size1(2); 
    sigma_y = size1(1);
    for v = 0:num_of_orient-1 
        theta_v = (v/8)*pi;
        %��ոǲ��˲���
        for x=-sigma_x:sigma_x-1      %ʹ��������С��Ƶ�����
            for y=-sigma_y:sigma_y-1
                xc = x*cos(theta_v)+y*sin(theta_v);
                yc = -x*sin(theta_v)+y*cos(theta_v);
                gabor(sigma_y+y+1,sigma_x+x+1)= ((fu^2)/(pi*gamma*ni))*exp(-(alfa^2*xc^2 + beta^2*yc^2))*...
                    exp((2*pi*fu*xc)*i);
            end
        end 
        filter_bank.spatial{u+1,v+1} = gabor;
        filter_bank.freq{u+1,v+1}=fft2(gabor); 
    end
end

filter_bank.scales = num_of_scales;
filter_bank.orient = num_of_orient;











