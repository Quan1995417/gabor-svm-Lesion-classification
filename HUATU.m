
clc
clear
close all
%%
addpath gabor
fprintf('��ʼ����\n');
%%
filter_bank = construct_Gabor_filters(8, 5, [48 48]); %5���߶�8������
class1path=dir('����');
data_matrix1=[];
for i=1%:length(class1path)-2
    imgpath=['����\' class1path(i+2).name];%ú̿��·��
    img1=imread(imgpath);%��ȡͼƬ
    figure;imshow(img1);title('����ԭʼͼƬ')
    
    img2=rgb2gray(img1);%�ҶȻ�
    figure;imshow(img2);title('����ԭʼͼƬ�Ҷ�ͼ')
    
    img3= double(imresize(img2,[48 48],'bilinear'));  %����'bilinear'������˫���Բ�ֵ�㷨��չΪ48*48
    H2 = filter_image_with_Gabor_bank1(img3,filter_bank,64);%%��ȡgabor��������
    suptitle('������ӦGABOR��߶���������ͼ');
    data_matrix1=[data_matrix1 H2];%����ȡ�������Ž�data_matrix1��
    disp(sprintf('��������ļ����е�%iͼ��gabor������ȡ',i));
end
tz_image1=data_matrix1';

%%
class1path=dir('����');
data_matrix1=[];
for i=1%:length(class1path)-2
    imgpath=['����\' class1path(i+2).name];%ú̿��·��
    img1=imread(imgpath);%��ȡͼƬ
    figure;imshow(img1);title('����ԭʼͼƬ')
    
    img2=rgb2gray(img1);%�ҶȻ�
    figure;imshow(img2);title('����ԭʼͼƬ�Ҷ�ͼ')
    img3= double(imresize(img2,[48 48],'bilinear'));  %����'bilinear'������˫���Բ�ֵ�㷨��չΪ48*48
    H2 = filter_image_with_Gabor_bank1(img3,filter_bank,64);%%��ȡgabor��������
    data_matrix1=[data_matrix1 H2];%����ȡ�������Ž�data_matrix1��
        suptitle('�����ӦGABOR��߶���������ͼ');
    disp(sprintf('��������ļ����е�%iͼ��gabor������ȡ',i));
end
tz_image2=data_matrix1';

%% ������ �Լ���Ӧ��ǩ  ����������Ϊ��һ�� ������Ϊ�ڶ���
input=[tz_image1;tz_image2];
output=[ones(1,size(tz_image1,1)) 2*ones(1,size(tz_image2,1))]';

