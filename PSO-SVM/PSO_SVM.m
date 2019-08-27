%% ��ջ��������Լ���������
clc
clear
close all
warning off 
format long
format compact
%% ����ṹ����
%��ȡ����
load img_tz %��������

%%
%��������ά�����ߣ�ÿ��gabbor������1440ά��������ѵ�����磬���������PCA���н�ά
[pca1,pca2,pca3]=pca(input);
proportion=0;
i=1;
while(proportion < 95)
    proportion = proportion + pca3(i);
    i = i+1;
end
input=pca2(:,1:10);
%�����ȡѵ��������Ԥ������
rand('seed',0)
[m n]=sort(rand(1,size(input,1)));
m=150;
train_wine=input(n(1:m),:);
train_wine_labels=output(n(1:m),:);
test_wine=input(n(m+1:end),:);
test_wine_labels=output(n(m+1:end),:);

%% 
%%%%% ѡ����ѵ�SVM����c&g-��������Ⱥ�㷨����ѡ��
% ����Ⱥ������ʼ��
pso_option = struct('c1',0.9,'c2',0.9,...
    'maxgen',200,'sizepop',50, ...
    'k',0.6,'wV',0.8,'wP',0.8, ...
    'popcmax',10^2,'popcmin',10^(-2),...
    'popgmax',10^2,'popgmin',10^(-2));
%%
[bestacc,bestc,bestg,trace] = psoSVMcgForClass(train_wine_labels,train_wine,test_wine_labels,test_wine,pso_option);
GlobalParams=[bestc bestg];

figure
plot(trace(:,1),'p-','LineWidth',1.5);hold on
plot(trace(:,2),'*-','LineWidth',1.5)
xlabel('��������')
legend('��ǰ������Ӧ��ֵ','��ǰƽ����Ӧ��ֵ')
ylabel('��Ӧ��(���������)')
line1 = '��Ӧ������Accuracy[PSOѰ��]';
line2 = ['��ֹ����=', ...
    num2str(pso_option.maxgen),',��Ⱥ����pop=', ...
    num2str(pso_option.sizepop),')'];
line3 = ['Best c=',num2str(bestc),' g=',num2str(bestg), ...
    ' CVAccuracy=',num2str((1-trace(end,1))*100),'%'];
title({line1;line2;line3},'FontSize',12);



%%
cmd = ['-c ',num2str(bestc),' -g ',num2str(bestg)];
model = svmtrain(train_wine_labels,train_wine,cmd);
[predict1] = svmpredict(train_wine_labels,train_wine,model);
[train_wine_labels n]=sort(train_wine_labels);

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