%% ��ջ��������Լ���������
clc
clear
close all
warning off 
format long
format compact
%% ����֧�����������з��࣬�����libsvm��ع���,����libsvm-3.12 ���·�����԰������ļ��з�ʽ��
%% �����MATLAB������43����������
%% ����ṹ����
%��ȡ����
load img_tz %��������

%%
%��������ά�����ߣ�ÿ��gabbor������1440ά��������ѵ�����磬���������PCA���н�ά
[pca1,pca2,pca3]=pca(input);
input=pca2(:,1:10);%���������matlab�Դ���pca��ά����
% �����ͽ�gabor��ȡ����1440ά������10ά

%�����ȡ150��������Ϊѵ��������ʣ�µ���Ϊ��������--Ҫ��ѵ���������� �޸�m����
rand('seed',0)
[m n]=sort(rand(1,size(input,1)));
m=150;
train_wine=input(n(1:m),:);
train_wine_labels=output(n(1:m),:);
test_wine=input(n(m+1:end),:);
test_wine_labels=output(n(m+1:end),:);

%% ֧��������
% ��������
bestc=41.7265;
bestg=0.0106;
cmd = ['-c ',num2str(bestc),' -g ',num2str(bestg)];
% ѵ��SVMģ��
model = svmtrain(train_wine_labels,train_wine,cmd);
[predict1] = svmpredict(train_wine_labels,train_wine,model);
%
[train_wine_labels n]=sort(train_wine_labels);%�Խ����������ʹ�û������Ľ��ͼֻ��һ��

figure;
hold on;
stem(train_wine_labels,'o');
plot(predict1(n),'r*');
xlabel('ѵ��������','FontSize',12);
ylabel('����ǩ','FontSize',12);
legend('ʵ��ѵ��������','Ԥ��ѵ��������');
title('ѵ����������','FontSize',12);
grid on;

%% SVM����Ԥ��
[predict_label,accuracy] = svmpredict(test_wine_labels,test_wine,model);
% ��ӡ���Լ�����׼ȷ��
total = length(test_wine_labels);
right = sum(predict_label == test_wine_labels);


%% �������
[test_wine_labels n]=sort(test_wine_labels);

figure;
hold on;
stem(test_wine_labels,'o');
plot(predict_label(n),'r*');
xlabel('���Լ�����','FontSize',12);
ylabel('����ǩ','FontSize',12);
legend('ʵ�ʲ��Լ�����','Ԥ����Լ�����');
title('���Լ�������','FontSize',12);
grid on;