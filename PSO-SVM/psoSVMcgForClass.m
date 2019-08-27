function [bestCVaccuarcy,bestc,bestg,trace] = psoSVMcgForClass(train_wine_labels,train_wine,test_wine_labels,test_wine,pso_option)
if nargin == 4
    pso_option = struct('c1',0.9,'c2',0.9,'maxgen',100,'sizepop',10, ...
        'k',0.6,'wV',0.8,'wP',0.8,'v',5, ...
        'popcmax',10^2,'popcmin',10^(-2),'popgmax',10^2,'popgmin',10^(-2));
end
% c1:��ʼΪ1.5,pso�����ֲ���������
% c2:��ʼΪ1.7,pso����ȫ����������
% maxgen:��ʼΪ200,����������
% sizepop:��ʼΪ20,��Ⱥ�������
% k:��ʼΪ0.6(k belongs to [0.1,1.0]),���ʺ�x�Ĺ�ϵ(V = kX)
% wV:��ʼΪ1(wV best belongs to [0.8,1.2]),���ʸ��¹�ʽ���ٶ�ǰ��ĵ���ϵ��
% wP:��ʼΪ1,��Ⱥ���¹�ʽ���ٶ�ǰ��ĵ���ϵ��
% v:��ʼΪ3,SVM Cross Validation����
% popcmax:��ʼΪ100,SVM ����c�ı仯�����ֵ.
% popcmin:��ʼΪ0.1,SVM ����c�ı仯����Сֵ.
% popgmax:��ʼΪ1000,SVM ����g�ı仯�����ֵ.
% popgmin:��ʼΪ0.01,SVM ����c�ı仯����Сֵ.

Vcmax = pso_option.k*pso_option.popcmax;
Vcmin = -Vcmax ;
Vgmax = pso_option.k*pso_option.popgmax;
Vgmin = -Vgmax ;

eps = 10^(-3);

% ������ʼ���Ӻ��ٶ�
for i=1:pso_option.sizepop
    
    % ���������Ⱥ���ٶ�
    pop(i,1) = (pso_option.popcmax-pso_option.popcmin)*rand+pso_option.popcmin;
    pop(i,2) = (pso_option.popgmax-pso_option.popgmin)*rand+pso_option.popgmin;
    V(i,1)=Vcmax*rands(1,1);
    V(i,2)=Vgmax*rands(1,1);
    % �����ʼ��Ӧ��
    fitness(i) =fun(pop(i,:),train_wine_labels,train_wine,test_wine_labels,test_wine)
end

% �Ҽ�ֵ�ͼ�ֵ��
local_fitness=fitness;    % ���弫ֵ��ʼ��
local_x=pop;              % ���弫ֵ��

[global_fitness     bestindex]=min(fitness); % ȫ�ּ�ֵ
global_x=pop(bestindex,:);                   % ȫ�ּ�Сֵ��Ӧ��ȫ�ּ�ֵ��

% ÿһ����Ⱥ��ƽ����Ӧ��
avgfitness_gen = zeros(1,pso_option.maxgen);

% ����Ѱ��
for i=1:pso_option.maxgen
    
    for j=1:pso_option.sizepop
        
        %�ٶȸ���
        V(j,:) = pso_option.wV*V(j,:) + pso_option.c1*rand*(local_x(j,:) - pop(j,:)) + pso_option.c2*rand*(global_x - pop(j,:));
        if V(j,1) > Vcmax
            V(j,1) = Vcmax;
        end
        if V(j,1) < Vcmin
            V(j,1) = Vcmin;
        end
        if V(j,2) > Vgmax
            V(j,2) = Vgmax;
        end
        if V(j,2) < Vgmin
            V(j,2) = Vgmin;
        end
        
        %��Ⱥ����
        pop(j,:)=pop(j,:) + pso_option.wP*V(j,:);
        
        if pop(j,1) > pso_option.popcmax
            pop(j,1) =(pso_option.popcmax-pso_option.popcmin)*rand + pso_option.popcmin;
        end
        if pop(j,1) < pso_option.popcmin
            pop(j,1) = (pso_option.popcmax-pso_option.popcmin)*rand + pso_option.popcmin;
        end
        if pop(j,2) > pso_option.popgmax
            pop(j,2) =  (pso_option.popgmax-pso_option.popgmin)*rand + pso_option.popgmin;
        end
        if pop(j,2) < pso_option.popgmin
            pop(j,2) =  (pso_option.popgmax-pso_option.popgmin)*rand + pso_option.popgmin;
        end
        
        % ����Ӧ���ӱ���
        if rand>0.5
            k=ceil(2*rand);
            if k == 1
                pop(j,k) =(pso_option.popcmax-pso_option.popcmin)*rand + pso_option.popcmin;
            end
            if k == 2
                pop(j,k) = (pso_option.popgmax-pso_option.popgmin)*rand + pso_option.popgmin;
            end
        end
        
        %��Ӧ��ֵ
        fitness(j) = fun(pop(j,:),train_wine_labels,train_wine,test_wine_labels,test_wine);
        
        
        %�������Ÿ���
        if fitness(j) <local_fitness(j)
            local_x(j,:) = pop(j,:);
            local_fitness(j) = fitness(j);
        end
        
        if abs( fitness(j)-local_fitness(j) )<=eps && pop(j,1) > local_x(j,1)
            local_x(j,:) = pop(j,:);
            local_fitness(j) = fitness(j);
        end
        
        %Ⱥ�����Ÿ���
        if fitness(j) < global_fitness
            global_x = pop(j,:);
            global_fitness = fitness(j);
        end
        
        
    end
    
    avgfitness_gen(i) = sum(fitness)/pso_option.sizepop;%ƽ����Ӧ��
    fit_gen(i) = global_fitness;%�����Ӧ��
end
% ���
bestc = global_x(1);
bestg = global_x(2);
bestCVaccuarcy = -fit_gen(pso_option.maxgen);
trace=[fit_gen ;avgfitness_gen]';