close all;
clc;


egit = ...
    input('Sistem egitilsin mi? (E/H): ', 's');

if strcmpi(egit, 'e')
    
  clear all;
     
  egitimYuzdesi = ...
      input('Veri setinin egitim için kullanilacak yüzdesi: ', 's');
  
  gecerlilikYuzdesi = ...
      input('Veri setinin geçerlilik kontrolü için kullanilacak yüzdesi: ', 's');
  
  testYuzdesi = ...
      input('Veri setinin test için kullanilacak yüzdesi: ', 's');
  
  noronSay = ...
      input('Nöron sayisi: ', 's');
  
    ey = str2double(egitimYuzdesi); % 80
    gy = str2double(gecerlilikYuzdesi); % 20
    ty = str2double(testYuzdesi); % 20
    ns = str2double(noronSay); % 30
  
    display('Sistem egitim asamasinda...')
    display('Lütfen bekleyiniz...');
 

%% içe Veri Aktar    
    load dataSet.mat;

    inputs = featureSet(:,1:11)';
    
    targets = featureSet(:,12:51)';
   
    %% Neural Network kismi

    % Create a Pattern Recognition Network
    hiddenLayerSize = ns;
  
    net = patternnet(hiddenLayerSize);

    net.divideParam.trainRatio = ey/100;
    net.divideParam.valRatio = gy/100;
    net.divideParam.testRatio = ty/100;
    
    net.trainParam.max_fail = 50;

    % Train the Network
    [net,tr] = train(net,inputs,targets);

    % Test the Network
    outputs = net(inputs);
    errors = gsubtract(targets,outputs);
    performance = perform(net,targets,outputs);

    % Recalculate Training, Validation and Test Performance
    trainTargets = targets .* tr.trainMask{1};
    valTargets = targets  .* tr.valMask{1};
    testTargets = targets  .* tr.testMask{1};
    trainPerformance = perform(net,trainTargets,outputs);
    valPerformance = perform(net,valTargets,outputs);
    testPerformance = perform(net,testTargets,outputs);
end


sec = input('Görüntü kaynagi belirtiniz: (K)amera / (D)osya: ', 's');

if strcmpi(sec, 'k')
	kameradan; %kameradan.m dosyasina devam et
elseif  strcmpi(sec, 'd')
    dosyadan; %dosyadan.m dosyasina devam et
end

    % View the Network
    % view(net)

    % Plots
    % Uncomment these lines to enable various plots.
    %figure, plotperform(tr)
    %figure, plottrainstate(tr)
    %figure, plotconfusion(targets,outputs)
    %figure, ploterrhist(errors)